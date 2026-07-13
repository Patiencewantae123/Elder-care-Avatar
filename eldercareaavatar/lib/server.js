import express from 'express';
import dotenv from 'dotenv';
import { GoogleGenAI } from '@google/genai';
import { google } from 'googleapis';

dotenv.config();

const app = express();
app.use(express.json());

// Initialize Google Gemini Client
const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

// Initialize Google Calendar Client
const calendar = google.calendar('v3');
const oauth2Client = new google.auth.OAuth2(
  process.env.GOOGLE_CLIENT_ID,
  process.env.GOOGLE_CLIENT_SECRET
);

// 1. Tool Declarations for Function Calling
const tools = [
  {
    type: 'function',
    name: 'getLatestNews',
    description: 'Fetches recent news headlines on a requested topic.',
    parameters: {
      type: 'object',
      properties: {
        topic: { type: 'string', description: 'Subject or category of news' }
      },
      required: ['topic']
    }
  },
  {
    type: 'function',
    name: 'searchYouTubeMedia',
    description: 'Finds songs, music videos, or podcasts on YouTube.',
    parameters: {
      type: 'object',
      properties: {
        query: { type: 'string', description: 'Artist, song name, or video subject' }
      },
      required: ['query']
    }
  },
  {
    type: 'function',
    name: 'bookAppointment',
    description: 'Schedules doctor or personal appointments on the user calendar.',
    parameters: {
      type: 'object',
      properties: {
        title: { type: 'string', description: 'Title or reason for appointment' },
        dateTimeISO: { type: 'string', description: 'Start time in ISO 8601 format' }
      },
      required: ['title', 'dateTimeISO']
    }
  }
];

// Helper Tool Execution Handlers
async function handleNewsSearch(topic) {
  // Replace with a real news API provider like NewsAPI or Bing News
  return {
    headlines: [
      `Local health center expands senior wellness hours for ${topic}`,
      `New study highlights benefits of daily morning walks.`
    ]
  };
}

async function handleYouTubeSearch(query) {
  const youtube = google.youtube({ version: 'v3', auth: process.env.GEMINI_API_KEY });
  const res = await youtube.search.list({
    part: ['snippet'],
    q: query,
    maxResults: 1,
    type: ['video']
  });
  
  if (res.data.items?.length) {
    const video = res.data.items[0];
    return {
      title: video.snippet.title,
      videoId: video.id.videoId,
      url: `https://www.youtube.com/watch?v=${video.id.videoId}`
    };
  }
  return { message: "No video found." };
}

async function handleAppointmentBooking(title, dateTimeISO, userAuthToken) {
  oauth2Client.setCredentials({ access_token: userAuthToken });
  const start = new Date(dateTimeISO);
  const end = new Date(start.getTime() + 60 * 60 * 1000); // Default 1 hour slot

  const event = await calendar.events.insert({
    auth: oauth2Client,
    calendarId: 'primary',
    requestBody: {
      summary: title,
      start: { dateTime: start.toISOString() },
      end: { dateTime: end.toISOString() }
    }
  });

  return { status: 'confirmed', eventLink: event.data.htmlLink };
}

// 2. Avatar Speech Endpoint
app.post('/api/avatar/chat', async (req, res) => {
  try {
    const { message, userToken } = req.body;

    const interaction = await ai.create({
      model: 'gemini-2.5-flash',
      input: message,
      tools: tools,
      systemInstruction: `
        You are 'Buddy', an empathetic companion avatar for an elderly user.
        - Tone: Gentle, warm, patient, and easy to follow.
        - Share uplifting stories when asked.
        - Use tool functions when the user asks for news, songs/videos, or booking appointments.
      `
    });

    // Check if the model requested a tool execution
    const fcStep = interaction.steps?.find(s => s.type === 'function_call');

    if (fcStep) {
      let toolResult;

      switch (fcStep.name) {
        case 'getLatestNews':
          toolResult = await handleNewsSearch(fcStep.arguments.topic);
          break;
        case 'searchYouTubeMedia':
          toolResult = await handleYouTubeSearch(fcStep.arguments.query);
          break;
        case 'bookAppointment':
          toolResult = await handleAppointmentBooking(
            fcStep.arguments.title,
            fcStep.arguments.dateTimeISO,
            userToken
          );
          break;
      }

      // Return tool results back to Gemini to generate the natural verbal response
      const finalReply = await ai.create({
        model: 'gemini-2.5-flash',
        input: [
          { role: 'user', content: message },
          { role: 'model', content: fcStep },
          { role: 'function', name: fcStep.name, response: toolResult }
        ]
      });

      return res.json({
        replyText: finalReply.text,
        actionExecuted: fcStep.name,
        data: toolResult
      });
    }

    // Direct conversational reply (storytelling, greeting, chat)
    return res.json({
      replyText: interaction.text,
      actionExecuted: null
    });

  } catch (error) {
    console.error("Avatar API Error:", error);
    res.status(500).json({ error: "Something went wrong processing the avatar response." });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Node.js backend running on port ${PORT}`);
});