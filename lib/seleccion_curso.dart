// lib/seleccion_curso.dart

import 'package:flutter/material.dart';
import 'package:enginear/data_structure.dart';
import 'package:enginear/seleccion_tema.dart';

class SeleccionCurso extends StatefulWidget {
  @override
  _SeleccionCursoState createState() => _SeleccionCursoState();
}

class _SeleccionCursoState extends State<SeleccionCurso> {
  String? _selectedMateria;
  String? _selectedAsignatura;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Curso'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            title: Text('Matemáticas'),
            children: _buildAsignaturaList('Matemáticas'),
          ),
          ExpansionTile(
            title: Text('Química'),
            children: _buildAsignaturaList('Química'),
          ),
          ExpansionTile(
            title: Text('Programación'),
            children: _buildAsignaturaList('Programación'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAsignaturaList(String materia) {
    List<String> asignaturas = materias[materia]?.keys.toList() ?? [];
    return asignaturas.map((asignatura) {
      return ListTile(
        title: Text(asignatura),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeleccionTema(
                materia: materia,
                asignatura: asignatura,
              ),
            ),
          );
          if (result != null && result['tema'] != null) {
            Navigator.pop(context, {
              'materia': materia,
              'asignatura': asignatura,
              'tema': result['tema'],
            });
          }
        },
      );
    }).toList();
  }
}
