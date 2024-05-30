import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String?> generarEcuacion() async {
  // Cargar las variables de entorno
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    print('API key is missing. Please check your .env file.');
    return null;
  }

  // Configurar el modelo de Google Generative AI
  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);
  final chat = model.startChat();

  try {
    final prompt = 'Generate a mathematical equation for a quadratic function with roots at x = 2 and x = -1';
    final response = await chat.sendMessage(Content.text(prompt));

    final equation = response.text;
    if (equation != null) {
      print('Equation: $equation');
      return equation;
    } else {
      print('No response from API.');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

