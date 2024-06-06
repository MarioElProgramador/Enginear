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
    final prompt = '''
Generate a simple and fast exercise for the topic "$tema" and the subtopic "$apartado". The exercise should include a clearly defined question and answer. If there are any mathematical expressions involved, provide them in LaTeX format using "double dollar signs" for block mode and "single dollar signs" for inline mode. Ensure the question and the answer are clearly separated by "Respuesta:". The answer should be simple and direct.
''';
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
