import 'package:flutter/material.dart';
import 'pagina_principal.dart';
import 'chatbot.dart';
import 'perfil.dart';

class InfAppBar extends StatelessWidget {
  final int selectedIndex;
  const InfAppBar({required this.selectedIndex, Key? key}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Chatbot()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PaginaPrincipal()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PerfilPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: '', // Si no estan crashea
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '', // Si no estan crashea
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '', // Si no estan crashea
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
