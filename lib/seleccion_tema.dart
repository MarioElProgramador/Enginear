import 'package:flutter/material.dart';
import 'package:enginear/data_structure.dart';
import 'inf_appbar.dart';

class SeleccionTema extends StatelessWidget {
  final String materia;
  final String asignatura;

  const SeleccionTema({super.key, required this.materia, required this.asignatura});

  @override
  Widget build(BuildContext context) {
    List<String> temas = materias[materia]?[asignatura]?.keys.toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecciona un Tema"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: temas.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(temas[index]),
              onTap: () {
                Navigator.pop(context, {'tema': temas[index]});
              },
            );
          },
        ),
      ),
      bottomNavigationBar: InfAppBar(selectedIndex: 1),
    );
  }
}
