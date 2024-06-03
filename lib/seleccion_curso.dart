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

  Map<String, bool> _expanded = {
    'Matemáticas': false,
    'Ciencias': false,
    'Programación': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Curso'),
      ),
      body: ListView(
        children: _expanded.keys.map((materia) {
          return ExpansionTile(
            title: Text(materia),
            initiallyExpanded: _expanded[materia]!,
            onExpansionChanged: (bool expanded) {
              setState(() {
                _expanded[materia] = expanded;
              });
            },
            children: _buildAsignaturaList(materia),
          );
        }).toList(),
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
