import 'package:enginear/pagina_principal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa el paquete dotenv
import 'package:enginear/chatbot.dart'; // Asegúrate de que la ruta sea correcta

void main() async {
  await dotenv.load(fileName: ".env"); // Carga las variables de entorno
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaginaPrincipal(), // Asegúrate de que la ruta sea correcta
    );
  }
}
