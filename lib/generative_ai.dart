import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:math';

Future<Map<String, dynamic>?> generarEjercicio(String tema, String apartado) async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    print('API key is missing. Please check your .env file.');
    return null;
  }

  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);
  final chat = model.startChat();
  final random = Random();
  final exerciseTypes = ['respuesta_corta', 'seleccion_multiple', 'rellenar_campos'];
  final selectedType = exerciseTypes[random.nextInt(exerciseTypes.length)];

  final prompt = '''
Generate an exercise for the topic "$tema" and the subtopic "$apartado". The exercise should be of the type "$selectedType".

- For "respuesta_corta", the question should require a short answer (1 to 8 characters).
- For "seleccion_multiple", the question should have exactly 4 multiple choice options labeled as (a), (b), (c), (d) with only one correct answer, each option on a new line, formatted as follows:
  Pregunta: [your question here]
  Opciones:
  (a) Option 1
  (b) Option 2
  (c) Option 3
  (d) Option 4
  Respuesta: [correct option letter]
- For "rellenar_campos", provide a sentence with one missing word to be filled in. The word should be short (1 to 8 characters).

Ensure the question and the answer are clearly separated by "Respuesta:".
''';


  try {
    final response = await chat.sendMessage(Content.text(prompt));
    final exerciseText = response.text;
    if (exerciseText != null) {
      final cleanedText = exerciseText.replaceAll('**', '').trim();
      print('Exercise: $cleanedText');
      return {
        'tipo': selectedType,
        'contenido': cleanedText,
      };
    } else {
      print('No response from API.');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
