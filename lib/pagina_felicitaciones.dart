import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'pagina_principal.dart';

class FelicitacionesPage extends StatefulWidget {
  const FelicitacionesPage({super.key});

  @override
  _FelicitacionesPageState createState() => _FelicitacionesPageState();
}

class _FelicitacionesPageState extends State<FelicitacionesPage> {
  bool _recompensasAsignadas = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _asignarRecompensas();
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _asignarRecompensas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Actualizar divisas
    int divisas = prefs.getInt('divisas') ?? 0;
    divisas += 20;
    await prefs.setInt('divisas', divisas);

    // Actualizar racha de fuego
    int contadorFuego = prefs.getInt('contadorFuego') ?? 0;
    contadorFuego++;
    await prefs.setInt('contadorFuego', contadorFuego);
    await prefs.setBool('fuegoEncendido', true);

    setState(() {
      _recompensasAsignadas = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Deshabilitar volver atrás
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    '¡Felicidades!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Has completado la lección.',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 40),
                  if (_recompensasAsignadas) ...[
                    const Text(
                      'Recompensas asignadas:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '+20 divisas',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.attach_money,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Racha aumentada!',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.whatshot,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const PaginaPrincipal()),
                      );
                    },
                    child: const Text('Volver a la página principal'),
                  ),
                  if (!_recompensasAsignadas)
                    const CircularProgressIndicator(),
                ],
              ),
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
