import 'package:flutter/material.dart';
import 'package:enginear/data_structure.dart';
import 'package:enginear/seleccion_tema.dart';
import 'inf_appbar.dart';

class SeleccionCurso extends StatefulWidget {
  const SeleccionCurso({super.key});

  @override
  _SeleccionCursoState createState() => _SeleccionCursoState();
}

class _SeleccionCursoState extends State<SeleccionCurso> {

  final Map<String, bool> _expanded = {
    'Matemáticas': false,
    'Ciencias': false,
    'Programación': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Curso'),
      ),
      body: ListView(
        children: _expanded.keys.map((materia) {
          return Container(
            color: Colors.blue[50],
            child: ExpansionTile(
              title: Text(materia),
              initiallyExpanded: _expanded[materia]!,
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _expanded[materia] = expanded;
                });
              },
              children: _buildAsignaturaList(materia),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: InfAppBar(selectedIndex: 1),
    );
  }

  List<Widget> _buildAsignaturaList(String materia) {
    List<String> asignaturas = materias[materia]?.keys.toList() ?? [];
    return asignaturas.map((asignatura) {
      return Container(
        color: Colors.white,
        child: ListTile(
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
        ),
      );
    }).toList();
  }
}
