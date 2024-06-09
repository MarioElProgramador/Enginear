import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pagina_principal.dart';
import 'chatbot.dart';
import 'pagina_felicitaciones.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class LeccionPage extends StatefulWidget {
  final String tema;
  final String apartado;
  final VoidCallback onLeccionCompleta;

  const LeccionPage({
    Key? key,
    required this.tema,
    required this.apartado,
    required this.onLeccionCompleta,
  }) : super(key: key);

  @override
  _LeccionPageState createState() => _LeccionPageState();
}

class _LeccionPageState extends State<LeccionPage> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  Map<String, dynamic>? _currentExercise;
  String? _respuestaUsuario;
  int _vidas = 0;
  int _divisas = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (dotenv.isInitialized) {
      _model = GenerativeModel(
        model: "gemini-pro",
        apiKey: dotenv.env['API_KEY']!,
      );
      _chat = _model.startChat();
    } else {
      throw Exception('Dotenv is not initialized. Make sure to load dotenv in main.dart');
    }
    _cargarVidasYDivisas();
    _generarEjercicio();
  }

  Future<void> _cargarVidasYDivisas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _vidas = prefs.getInt('vidas') ?? 5;
      _divisas = prefs.getInt('divisas') ?? 0;
    });
  }

  Future<void> _guardarDivisas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('divisas', _divisas);
  }

  Future<void> _generarEjercicio() async {
    setState(() {
      _loading = true;
    });

    try {
      final prompt = "Genera un ejercicio con respuesta para el tema '${widget.tema}' y el apartado '${widget.apartado}'.";
      final userMessage = Content.text(prompt);
      final response = await _chat.sendMessage(userMessage);
      final text = response.text;
      if (text != null) {
        final parts = text.split("**Respuesta:**");
        if (parts.length == 2) {
          setState(() {
            _currentExercise = {
              'pregunta': parts[0].trim(),
              'respuesta': parts[1].trim()
            };
          });
        } else {
          setState(() {
            _currentExercise = null;
          });
        }
      } else {
        setState(() {
          _currentExercise = null;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _completarEjercicio() async {
    await _actualizarRacha();
    widget.onLeccionCompleta();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FelicitacionesPage()),
    );
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

  @override
  Widget build(BuildContext context) {
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
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_currentExercise == null)
              const Center(child: Text('No se pudieron cargar los ejercicios'))
            else ...[
                MarkdownBody(
                  data: _currentExercise!['pregunta'],
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
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
                    if (_respuestaUsuario == _currentExercise!['respuesta']) {
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
