import 'dart:math';
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
  int _expGanada = 0; // Variable para almacenar la experiencia ganada

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

    // Obtener el valor actual de las divisas o inicializarlo a 150 si es la primera vez
    int divisas = prefs.getInt('divisas') ?? 150;

    // Actualizar divisas
    divisas += 20;
    await prefs.setInt('divisas', divisas);

    // Actualizar racha de fuego
    int contadorFuego = prefs.getInt('contadorFuego') ?? 0;
    contadorFuego++;
    await prefs.setInt('contadorFuego', contadorFuego);
    await prefs.setBool('fuegoEncendido', true);

    // Asignar puntos de experiencia aleatorios entre 10 y 30
    _expGanada = Random().nextInt(21) + 10; // Genera un número entre 10 y 30 de experiencia
    int exp = prefs.getInt('exp') ?? 0;
    exp += _expGanada;
    await prefs.setInt('exp', exp);

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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                      children: [
                        Text(
                          '+$_expGanada exp',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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