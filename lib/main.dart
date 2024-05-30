import 'package:flutter/material.dart';
import 'package:enginear/loading_screen.dart'; // Asegúrate de tener el import correcto
import 'package:enginear/pagina_principal.dart'; // Asegúrate de tener el import correcto

void main() {
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
      home: LoadingScreen(), // Muestra la pantalla de carga al inicio
    );
  }
}
