import 'package:flutter/material.dart';
import 'pagina_principal.dart';

class FelicitacionesPage extends StatelessWidget {
  const FelicitacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Felicitaciones'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Felicidades!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Has completado la lección.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PaginaPrincipal()),
                );
              },
              child: const Text('Volver a la página principal'),
            ),
          ],
        ),
      ),
    );
  }
}
