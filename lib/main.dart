import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart'; // Daily use
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:enginear/generative_ai.dart';
import 'package:enginear/pagina_principal.dart';
import 'package:enginear/seleccion_curso.dart';

// const api_key = "AIzaSyC8xzJqxO5dzqudep2va6BAJwmsv2hHX_U"; // Google Studio
const api_key = "AIzaSyAaC-LPg5kZOg8Z6tsY8otswHL_wVmSP8E";

// Access the API key as an environment variable
void initialize() {
  final apiKey = Platform.environment[api_key];
  if(apiKey == null) {
    print('No \$API_KEY environment variable');
    exit(1);
  }
  final model = GenerativeModel(model: 'gemini-pro', apiKey: const String.fromEnvironment('api_key'));
}

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
        ),
      ),
      home: PaginaPrincipal(),
    );
  }
}

