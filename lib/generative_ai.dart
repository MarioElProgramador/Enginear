// generative_ai.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String?> generarEjercicio(String tema, String apartado) async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    print('API key is missing. Please check your .env file.');
    return null;
  }

  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);
  final chat = model.startChat();

  try {
    final prompt = 'Generate a complete exercise for the topic "$tema" and the subtopic "$apartado". Provide the question and the answer clearly separated.';
    final response = await chat.sendMessage(Content.text(prompt));

    final exercise = response.text;
    if (exercise != null) {
      print('Exercise: $exercise');
      return exercise;
    } else {
      print('No response from API.');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
