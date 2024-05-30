import 'package:flutter/material.dart';
import 'package:enginear/pagina_principal.dart'; // Asegúrate de tener el import correcto

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startFadeOut();
  }

  void _startFadeOut() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _opacity = 0.0;
      });
      // Navigate to the next screen after the fade out
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PaginaPrincipal()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 1),
          child: Image.asset('assets/images/logoWithBackground.png'), // Asegúrate de que la ruta sea correcta
        ),
      ),
    );
  }
}
