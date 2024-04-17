import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red, // Cambia el color de la barra de navegación
      ),
      home: PaginaPrincipal(), // Usamos la clase PaginaPrincipal como la página principal
    );
  }
}

class PaginaPrincipal extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.school), // Icono de la materia/asignatura seleccionada
            SizedBox(width: 8.0), // Espacio entre el icono y el siguiente elemento
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.whatshot), // Icono del fuego apagado
                    SizedBox(width: 4.0), // Espacio entre el icono y el número de días
                    Text(
                      '0', // Número de días consecutivos (por defecto 0)
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.0), // Espacio entre el siguiente elemento y el icono de la gema
            Row(
              children: [
                Icon(Icons.attach_money), // Icono del dinero
                SizedBox(width: 4.0), // Espacio entre el icono y el número de monedas
                Text(
                  '0', // Número de monedas del usuario (por defecto 0)
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0), // Altura deseada de la segunda barra
          child: AppBar(
            title: Text('Tema seleccionado'), // Título de la segunda barra

            automaticallyImplyLeading: false, // Oculta el botón de retorno
            backgroundColor: Colors.grey[200], // Color de fondo de la segunda barra
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Apartado 1
            _buildSection("Apartado 1", Colors.blue, context),
            SizedBox(height: 16.0),
            // Apartado 2
            _buildSection("Apartado 2", Colors.green, context),
            // Puedes añadir más apartados según sea necesario
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Color color, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: color,
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLessonButton(Icons.edit, context),
              _buildLessonButton(Icons.edit, context),
              _buildLessonButton(Icons.edit, context),
              _buildLessonButton(Icons.edit, context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessonButton(IconData iconData, BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(iconData),
        onPressed: () {
          // Acción al presionar el botón de la lección (puedes navegar a la página de la lección)
        },
      ),
    );
  }
}