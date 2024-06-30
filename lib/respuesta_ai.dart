import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RespuestaApi {
  static Future<bool> verificarRespuesta(String pregunta, String respuestaUsuario, String respuestaCorrecta) async {
    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env['API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      print('API key is missing. Please check your .env file.');
      return false;
    }

    final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);
    final chat = model.startChat();

    final prompt = '''
Evaluate the user's response for the following question:

Question: "$pregunta"

User's Response: "$respuestaUsuario"

Correct Answer: "$respuestaCorrecta"

Reply with "correct" if the user's response is correct, otherwise reply with "incorrect".
''';

    try {
      final response = await chat.sendMessage(Content.text(prompt));
      final evaluation = response.text?.trim().toLowerCase();
      return evaluation == 'correct';
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
