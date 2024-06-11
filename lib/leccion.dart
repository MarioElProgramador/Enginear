import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pagina_principal.dart';
import 'pagina_felicitaciones.dart';
import 'chatbot.dart';
import 'generative_ai.dart';
import 'respuesta_ai.dart';

class LeccionPage extends StatefulWidget {
  final String materia;
  final String asignatura;
  final String tema;
  final String subapartado;
  final int vidas;
  final int divisas;
  final Function onLeccionCompleta;

  const LeccionPage({
    required this.materia,
    required this.asignatura,
    required this.tema,
    required this.subapartado,
    required this.vidas,
    required this.divisas,
    required this.onLeccionCompleta,
  });

  @override
  State<StatefulWidget> createState() => _LeccionPageState();
}

class _LeccionPageState extends State<LeccionPage> {
  Map<String, dynamic>? _currentExercise;
  String? _respuestaUsuario;
  bool _loading = false;
  late int _divisas;
  late int _vidas;

  @override
  void initState() {
    super.initState();
    _divisas = widget.divisas;
    _vidas = widget.vidas;
    _generarEjercicio();
  }

  Future<void> _generarEjercicio() async {
    setState(() => _loading = true);

    final ejercicio = await generarEjercicio(widget.tema, widget.subapartado);
    if (ejercicio != null) {
      setState(() {
        _currentExercise = ejercicio;
      });
    } else {
      setState(() {
        _currentExercise = {'tipo': 'error', 'contenido': 'No se pudo generar el ejercicio.'};
      });
    }

    setState(() => _loading = false);
  }

  void _completarEjercicio() async {
    if (_currentExercise == null) return;

    final pregunta = _currentExercise!['contenido'].split("Respuesta:")[0].trim();
    final respuestaUsuario = _respuestaUsuario?.trim() ?? '';

    // Verificamos la respuesta del usuario utilizando la API
    final bool respuestaCorrecta = await RespuestaApi.verificarRespuesta(pregunta, respuestaUsuario);

    // Si la respuesta es correcta, completamos el ejercicio y avanzamos a la página de felicitaciones
    if (respuestaCorrecta) {
      await _actualizarRacha();
      widget.onLeccionCompleta();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FelicitacionesPage()),
      );
    } else {
      // Si la respuesta es incorrecta, restamos una vida y mostramos un mensaje de error
      _restarVida();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Respuesta incorrecta. Inténtalo de nuevo.')),
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
        contadorFuego = 1;
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
          content: Text('¿Deseas obtener ayuda del chatbot a cambio de 10 divisas? Tienes $_divisas.'),
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
                    _guardarDivisas();
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

  Future<void> _guardarDivisas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('divisas', _divisas);
  }

  Future<void> _guardarVidas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('vidas', _vidas);
  }

  void _restarVida() {
    setState(() {
      _vidas--;
    });
    _guardarVidas();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth > 600 ? 200.0 : 150.0;

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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_loading)
                    const Center(child: CircularProgressIndicator())
                  else if (_currentExercise == null)
                    const Center(child: Text('No se pudieron cargar los ejercicios'))
                  else ...[
                      MarkdownBody(
                        data: _currentExercise!['contenido'].split("Respuesta:")[0].trim(),
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_currentExercise!['tipo'] == 'respuesta_corta') ...[
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
                      ] else if (_currentExercise!['tipo'] == 'seleccion_multiple') ...[
                        ..._generateMultipleChoiceOptions(_currentExercise!['contenido']),
                        const SizedBox(height: 20),
                      ] else if (_currentExercise!['tipo'] == 'rellenar_campos') ...[
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
                      ]
                    ],
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: SizedBox(
              width: buttonSize,
              child: ElevatedButton(
                onPressed: _completarEjercicio,
                child: const Text('Verificar'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _generateMultipleChoiceOptions(String content) {
    final parts = content.split("Opciones:");
    final optionsText = parts[1].trim().split("\n").where((line) => line.trim().isNotEmpty).toList();

    final List<String> options = [];
    for (var option in optionsText) {
      if (option.trim().startsWith("(")) {
        options.add(option.trim());
      }
    }

    return options.map((option) {
      return RadioListTile<String>(
        title: Text(option),
        value: option,
        groupValue: _respuestaUsuario,
        onChanged: (value) {
          setState(() {
            _respuestaUsuario = value;
          });
        },
      );
    }).toList();
  }
}
