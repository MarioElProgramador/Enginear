import 'package:flutter/material.dart';

import 'package:enginear/generative_ai.dart';
import 'package:enginear/pagina_principal.dart';

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
                  Navigator.pop(context, 'Algebra lineal');
                },
              ),
              ListTile(
                title: const Text('Geometría'),
                onTap: () {
                  Navigator.pop(context, 'Geometría');
                },
              ),
              ListTile(
                title: const Text('Cálculo 1'),
                onTap: () {
                  Navigator.pop(context, 'Cálculo 1');
                },
              ),
              ListTile(
                title: const Text('Cálculo 2'),
                onTap: () {
                  Navigator.pop(context, 'Cálculo 2');
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
}
