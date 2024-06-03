// leccion.dart
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'pagina_principal.dart';
import 'ejercicio_calculo.dart';

class LeccionPage extends StatefulWidget {
  final String tema;
  final String apartado;

  LeccionPage({required this.tema, required this.apartado});

  @override
  _LeccionPageState createState() => _LeccionPageState();
}

class _LeccionPageState extends State<LeccionPage> {
  final List<Map<String, dynamic>> _ejercicios = ejerciciosCalculo;
  int _currentExerciseIndex = 0;

  void _completarEjercicio() {
    if (_currentExerciseIndex < _ejercicios.length - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FelicitacionesPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = _ejercicios[_currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Lección: ${widget.tema} - ${widget.apartado}'),
        leading: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PaginaPrincipal()),
            );
          },
          child: Text(
            'Salir',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ejercicio ${_currentExerciseIndex + 1}:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (currentExercise['tipo'] == 'fill_in_blank') ...[
              Math.tex(
                currentExercise['pregunta'],
                textStyle: TextStyle(fontSize: 18),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Respuesta',
                ),
                onSubmitted: (value) {
                  if (value == currentExercise['respuesta']) {
                    _completarEjercicio();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Respuesta incorrecta')),
                    );
                  }
                },
              ),
            ] else if (currentExercise['tipo'] == 'multiple_choice') ...[
              Math.tex(
                currentExercise['pregunta'],
                textStyle: TextStyle(fontSize: 18),
              ),
              ...currentExercise['opciones'].map<Widget>((opcion) {
                return ListTile(
                  title: Text(opcion),
                  leading: Radio<String>(
                    value: opcion,
                    groupValue: currentExercise['respuesta'],
                    onChanged: (value) {
                      if (value == currentExercise['respuesta']) {
                        _completarEjercicio();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Respuesta incorrecta')),
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            ] else if (currentExercise['tipo'] == 'drag_and_drop') ...[
              Text(
                currentExercise['pregunta'],
                style: TextStyle(fontSize: 18),
              ),
              // Aquí necesitaríamos un widget de Drag & Drop, por simplicidad, solo mostramos las afirmaciones
              Column(
                children: currentExercise['afirmaciones'].map<Widget>((afirmacion) {
                  return ListTile(
                    title: Text(afirmacion),
                  );
                }).toList(),
              ),
            ],
            Spacer(),
            ElevatedButton(
              onPressed: _completarEjercicio,
              child: Text(_currentExerciseIndex < _ejercicios.length - 1 ? 'Completar' : 'Terminar Lección'),
            ),
          ],
        ),
      ),
    );
  }
}

class FelicitacionesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Felicitaciones'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Has completado la lección!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaPrincipal()),
                );
              },
              child: Text('Volver a la página principal'),
            ),
          ],
        ),
      ),
    );
  }
}
