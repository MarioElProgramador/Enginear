import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa el paquete dotenv
import 'package:enginear/loading_screen.dart'; // Importa la pantalla de carga

void main() async {
  await dotenv.load(fileName: ".env"); // Carga las variables de entorno
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enginear',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Establece el color de fondo a blanco
      ),
      home: const LoadingScreen(), // Pantalla de carga
    );
  }
}
