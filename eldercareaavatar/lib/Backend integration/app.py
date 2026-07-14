# app.py
import torch
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from transformers import AutoTokenizer, AutoModelForCausalLM

app = FastAPI(title="ElderConnect AI Backend", version="1.0")

# Load Llama 3.2 (Using the 3B Instruct variant for strong English/Korean response handling)
MODEL_ID = "meta-llama/Llama-3.2-3B-Instruct"

print("Loading Llama 3.2 model assets...")
tokenizer = AutoTokenizer.from_pretrained(MODEL_ID)
model = AutoModelForCausalLM.from_pretrained(
    MODEL_ID,
    torch_dtype=torch.bfloat16 if torch.cuda.is_available() else torch.float32,
    device_map="auto"
)
print("Model loaded successfully.")

class ChatRequest(BaseModel):
    message: str
    language: str = "en"  # "en" or "ko"

class ChatResponse(BaseModel):
    reply: str

@app.post("/api/chat", response_model=ChatResponse)
async def chat_with_llama(payload: ChatRequest):
    try:
        # Construct localized empathetic persona guidelines for elder care context
        system_prompt = (
            "You are a gentle, patient, and warm conversational assistant named ElderConnect AI. "
            "You are talking to an elderly individual. Use short, simple, reassuring sentences. "
            "Do not use complex terminology or jargon. Always answer matching the requested language format."
            if payload.language == "en" else
            "당신은 엘더커넥트의 따뜻하고 친절한 AI 말벗 도우미입니다. "
            "어르신과 대화하고 있으므로 언제나 높임말(해요체나 습니다체)을 사용하고, "
            "쉽고 명확하며 따뜻한 문장으로 짧게 답변해 주세요. 어려운 전문 용어는 피하세요."
        )

        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": payload.message}
        ]

        # Formatting context window templates matching Llama 3.2 architecture specs
        input_ids = tokenizer.apply_chat_template(
            messages,
            add_generation_prompt=True,
            return_tensors="pt"
        ).to(model.device)

        terminators = [
            tokenizer.eos_token_id,
            tokenizer.convert_tokens_to_ids("<|eot_id|>")
        ]

        outputs = model.generate(
            input_ids,
            max_new_tokens=256,
            eos_token_id=terminators,
            do_sample=True,
            temperature=0.7,
            top_p=0.9
        )

        response_ids = outputs[0][input_ids.shape[-1]:]
        generated_reply = tokenizer.decode(response_ids, skip_special_tokens=True).strip()

        return ChatResponse(reply=generated_reply)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)