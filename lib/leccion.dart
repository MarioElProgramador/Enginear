import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart'; // Importar flutter_math_fork
import 'pagina_principal.dart';
import 'ejercicio_calculo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generative_ai.dart';
import 'chatbot.dart';
import 'pagina_felicitaciones.dart';

class LeccionPage extends StatefulWidget {
  final String tema;
  final String apartado;
  final VoidCallback onLeccionCompleta;

  const LeccionPage({
    super.key,
    required this.tema,
    required this.apartado,
    required this.onLeccionCompleta,
  });

  @override
  _LeccionPageState createState() => _LeccionPageState();
}

class _LeccionPageState extends State<LeccionPage> {
  List<Map<String, dynamic>>? _ejercicios;
  int _currentExerciseIndex = 0;
  String? _respuestaUsuario;
  int _vidas = 0; // Inicializar con 0 para luego cargar las vidas desde SharedPreferences
  int _divisas = 0; // Inicializar con 0 para luego cargar las divisas desde SharedPreferences

  @override
  void initState() {
    super.initState();
    _cargarEjercicios();
    _cargarVidasYDivisas(); // Cargar las vidas y divisas desde SharedPreferences
  }

  Future<void> _cargarVidasYDivisas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _vidas = prefs.getInt('vidas') ?? 5; // Cargar las vidas, por defecto 5
      _divisas = prefs.getInt('divisas') ?? 0; // Cargar las divisas, por defecto 0
    });
  }

  Future<void> _guardarDivisas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('divisas', _divisas); // Guardar las divisas actualizadas
  }

  Future<void> _cargarEjercicios() async {
    if (widget.tema == 'Límites y Continuidad' && widget.apartado == 'Concepto de Límite') {
      setState(() {
        _ejercicios = ejerciciosCalculo;
      });
    } else {
      String? ejercicioGenerado = await generarEjercicio(widget.tema, widget.apartado);
      if (ejercicioGenerado != null) {
        final partes = ejercicioGenerado.split('Respuesta:');
        if (partes.length == 2) {
          final pregunta = partes[0].replaceAll(RegExp(r'\*\*(.*?)\*\*'), '').trim();
          final respuesta = partes[1].trim();
          setState(() {
            _ejercicios = [
              {
                'tipo': 'generated',
                'pregunta': pregunta,
                'respuesta': respuesta,
              }
            ];
          });
        } else {
          setState(() {
            _ejercicios = [];
          });
        }
      } else {
        setState(() {
          _ejercicios = [];
        });
      }
    }
  }

  void _completarEjercicio() async {
    if (_currentExerciseIndex < (_ejercicios?.length ?? 0) - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
    } else {
      await _actualizarRacha();
      widget.onLeccionCompleta();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FelicitacionesPage()),
      );
    }
  }

  Future<void> _actualizarRacha() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime ahora = DateTime.now();
    DateTime ultimaLeccionFecha = DateTime.parse(prefs.getString('ultimaLeccionFecha') ?? ahora.toString());

    if (ultimaLeccionFecha.day != ahora.day || ultimaLeccionFecha.month != ahora.month || ultimaLeccionFecha.year != ahora.year) {
      int contadorFuego = prefs.getInt('contadorFuego') ?? 0;
      if (ahora.difference(ultimaLeccionFecha).inDays == 1) {
        contadorFuego++;
      } else {
        contadorFuego = 1; // Reset racha si hay un salto de más de un día
      }
      await prefs.setInt('contadorFuego', contadorFuego);
    }

    await prefs.setString('ultimaLeccionFecha', ahora.toString());
    await prefs.setBool('fuegoEncendido', true);
  }

  void _mostrarPopupChatbot() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Desearías obtener ayuda del chatbot a cambio de 10 divisas? Tienes $_divisas.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_divisas >= 10) {
                  setState(() {
                    _divisas -= 10;
                    _guardarDivisas(); // Guardar las divisas actualizadas
                  });
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Chatbot()),
                  );
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No tienes suficientes divisas')),
                  );
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_ejercicios == null) {
      return Scaffold(
        appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PaginaPrincipal()),
              );
            },
            child: const Text(
              'Salir',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                '$_vidas',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: _mostrarPopupChatbot,
            ),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_ejercicios!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PaginaPrincipal()),
              );
            },
            child: const Text(
              'Salir',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                '$_vidas',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: _mostrarPopupChatbot,
            ),
          ],
        ),
        body: const Center(child: Text('No se pudieron cargar los ejercicios')),
      );
    }

    final currentExercise = _ejercicios![_currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PaginaPrincipal()),
            );
          },
          child: const Text(
            'Salir',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite, color: Colors.red),
            const SizedBox(width: 4),
            Text(
              '$_vidas',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: _mostrarPopupChatbot,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Math.tex(
              currentExercise['pregunta'],
              textStyle: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            if (currentExercise['tipo'] == 'fill_in_blank') ...[
              TextField(
                onChanged: (value) {
                  setState(() {
                    _respuestaUsuario = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tu respuesta',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_respuestaUsuario == currentExercise['respuesta']) {
                    _completarEjercicio();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Respuesta incorrecta')),
                    );
                  }
                },
                child: const Text('Verificar'),
              ),
            ],
            if (currentExercise['tipo'] == 'multiple_choice') ...[
              ...currentExercise['opciones'].map<Widget>((opcion) {
                return ListTile(
                  title: Text(opcion),
                  leading: Radio<String>(
                    value: opcion,
                    groupValue: _respuestaUsuario,
                    onChanged: (value) {
                      setState(() {
                        _respuestaUsuario = value;
                      });
                    },
                  ),
                );
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  if (_respuestaUsuario == currentExercise['respuesta']) {
                    _completarEjercicio();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Respuesta incorrecta')),
                    );
                  }
                },
                child: const Text('Verificar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
