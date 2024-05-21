import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:enginear/pagina_principal.dart';
import 'package:enginear/seleccion_curso.dart';

const api_key = "AIzaSyC8xzJqxO5dzqudep2va6BAJwmsv2hHX_U";

Future<void> generarEcuacion() async {
  // API endpoint for the Google Gemini Pro model
  final url = Uri.parse('https://vertexai.googleapis.com/v1/projects/<your-project-id>/locations/<location>/models/<your-model-id>:predict');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $api_key',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'instances': [
        {
          'input': 'Generate a mathematical equation for a quadratic function with roots at x = 2 and x = -1', // Prompt to generate equation
        },
      ],
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final equation = data['predictions'][0]['content'];
    print('Equation: $equation');

    // Display the generated equation in your UI
    // (e.g., using a Text widget)
  } else {
    print('Error: ${response.statusCode}');
    // Handle errors more gracefully, e.g., display an error message to the user
  }
}
