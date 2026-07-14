// llama_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class LlamaService {
  // Update this endpoint targeting your backend server host IP address configuration
  static const String baseUrl = "http://10.0.2.2:8000"; 

  Future<String> fetchLlamaResponse(String message, String langCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
          'language': langCode,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['reply'] ?? "I could not understand that.";
      } else {
        return "Error linking to server. (Status: ${response.statusCode})";
      }
    } catch (e) {
      return "Unable to connect to your AI companion. Please check your network.";
    }
  }
}