import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pagina_principal.dart';
import 'pagina_felicitaciones.dart';
import 'chatbot.dart';
import 'generative_ai.dart';
import 'respuesta_ai.dart';
import 'pista.dart';

class LeccionPage extends StatefulWidget {
  final String materia;
  final String asignatura;
  final String tema;
  final String subapartado;
  final int vidas;
  final int divisas;
  final VoidCallback onLeccionCompleta;

  const LeccionPage({
    Key? key,
    required this.materia,
    required this.asignatura,
    required this.tema,
    required this.subapartado,
    required this.vidas,
    required this.divisas,
    required this.onLeccionCompleta,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LeccionPageState();
}

class _LeccionPageState extends State<LeccionPage> {
  Map<String, dynamic>? _currentExercise;
  String? _respuestaUsuario;
  bool _loading = false;
  late int _divisas;
  late int _vidas;
  bool _pistaDesbloqueada = false;

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

    final contenido = _currentExercise!['contenido'];
    final pregunta = _eliminarPalabrasNoDeseadas(contenido.split("Respuesta:")[0].trim());
    final respuestaCorrecta = contenido.split("Respuesta:")[1].trim();
    final respuestaUsuario = _respuestaUsuario?.trim() ?? '';

    // Verificamos la respuesta del usuario utilizando la API
    final bool respuestaCorrectaBool = await RespuestaApi.verificarRespuesta(
      pregunta,
      respuestaUsuario,
      respuestaCorrecta,
    );

    // Si la respuesta es correcta, completamos el ejercicio y avanzamos a la página de felicitaciones
    if (respuestaCorrectaBool) {
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
    bool fuegoEncendido = prefs.getBool('fuegoEncendido') ?? false;

    if (!fuegoEncendido) {
      int contadorFuego = prefs.getInt('contadorFuego') ?? 0;
      if (ahora.difference(ultimaLeccionFecha).inDays >= 1) {
        contadorFuego++;
        await prefs.setInt('contadorFuego', contadorFuego);
        await prefs.setBool('fuegoEncendido', true);
      }
    }

    await prefs.setString('ultimaLeccionFecha', ahora.toString());
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

  void _mostrarPopupPista() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('¿Deseas obtener una pista a cambio de 10 divisas? Tienes $_divisas.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_divisas >= 10) {
                  setState(() {
                    _divisas -= 10;
                    _pistaDesbloqueada = true;
                    _guardarDivisas();
                  });
                  Navigator.of(context).pop();
                  _mostrarPista();
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

  void _mostrarPista() async {
    if (_pistaDesbloqueada) {
      await showModalBottomSheet(
        context: context,
        builder: (context) {
          return PistaPage(
            tema: widget.tema,
            apartado: widget.subapartado,
          );
        },
      );
    } else {
      _mostrarPopupPista();
    }
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
            onPressed: _mostrarPista,
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
                        data: _formatQuestion(_currentExercise!['contenido']),
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
                      ] else if (_currentExercise!['tipo'] == 'error') ...[
                        const Center(child: Text('No se pudo generar el ejercicio.')),
                      ]
                    ],
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: buttonSize,
                child: ElevatedButton(
                  onPressed: _completarEjercicio,
                  child: const Text('Verificar'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatQuestion(String content) {
    final parts = content.split("Respuesta:");
    final pregunta = parts[0].split("Opciones:")[0].trim();
    return _eliminarPalabrasNoDeseadas(pregunta).trim();
  }

  String _eliminarPalabrasNoDeseadas(String texto) {
    final lineas = texto.split('\n');
    final lineasFiltradas = lineas.map((linea) {
      return linea
          .replaceAll("Rellenar campos:", "")
          .replaceAll("Ejercicio:", "")
          .replaceAll("Exercise:", "")
          .replaceAll("Pregunta:", "")
          .replaceAll("Enunciado:", "")
          .trim();
    }).toList();
    return lineasFiltradas.join('\n').trim();
  }

  List<Widget> _generateMultipleChoiceOptions(String content) {
    final parts = content.split("Opciones:");
    if (parts.length < 2) {
      return [const Text('No se encontraron opciones de selección múltiple.')];
    }

    final optionsText = parts[1].trim().split("\n").where((line) => line.trim().isNotEmpty && !line.startsWith("Respuesta:")).toList();

    final List<String> options = [];
    bool optionsStarted = false;
    for (var line in optionsText) {
      if (line.trim().startsWith("(a)")) {
        optionsStarted = true;
      }
      if (optionsStarted) {
        options.add(line.trim());
        if (options.length == 4) break; // Solo necesitamos cuatro opciones
      }
    }

    if (options.length < 4) {
      return [const Text('No se encontraron suficientes opciones de selección múltiple.')];
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
