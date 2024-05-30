import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeleccionCurso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un curso'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: const Text('Matemáticas'),
            children: <Widget>[
              ListTile(
                title: const Text('Algebra lineal'),
                onTap: () {
                  _saveCourseSelection('Algebra lineal', context);
                },
              ),
              ListTile(
                title: const Text('Geometría'),
                onTap: () {
                  _saveCourseSelection('Geometría', context);
                },
              ),
              ListTile(
                title: const Text('Cálculo 1'),
                onTap: () {
                  _saveCourseSelection('Cálculo 1', context);
                },
              ),
              ListTile(
                title: const Text('Cálculo 2'),
                onTap: () {
                  _saveCourseSelection('Cálculo 2', context);
                },
              ),
              ListTile(
                title: const Text('...'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Ciencias'),
            children: <Widget>[
              ListTile(
                title: const Text('...'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Programación'),
            children: <Widget>[
              ListTile(
                title: const Text('...'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveCourseSelection(String course, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('curso', course);
    Navigator.pop(context, course);
  }
}
