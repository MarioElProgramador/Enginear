import 'dart:io';
import 'package:enginear/pagina_principal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inf_appbar.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _imagenPerfil;
  String _nombreUsuario = "Usuario";
  int _experiencia = 0;
  int _selectedIndex = 2; // Índice de la pestaña Perfil

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreUsuario = prefs.getString('nombreUsuario') ?? "Usuario";
      _experiencia = prefs.getInt('exp') ?? 0;
      String? imagenPath = prefs.getString('imagenPerfil');
      if (imagenPath != null) {
        _imagenPerfil = File(imagenPath);
      }
    });
  }

  Future<void> _seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagenSeleccionada = await picker.pickImage(source: ImageSource.gallery);

    if (imagenSeleccionada != null) {
      setState(() {
        _imagenPerfil = File(imagenSeleccionada.path);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagenPerfil', imagenSeleccionada.path);
    }
  }

  Future<void> _cambiarNombre() async {
    TextEditingController _nombreController = TextEditingController(text: _nombreUsuario);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cambiar nombre de usuario'),
          content: TextField(
            controller: _nombreController,
            decoration: const InputDecoration(hintText: "Ingrese nuevo nombre"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  _nombreUsuario = _nombreController.text;
                });
                await prefs.setString('nombreUsuario', _nombreUsuario);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _goToMainPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => PaginaPrincipal()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goToMainPage,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _seleccionarImagen,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _imagenPerfil != null ? FileImage(_imagenPerfil!) : null,
                child: _imagenPerfil == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _nombreUsuario,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _cambiarNombre,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Exp: $_experiencia',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.star,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: InfAppBar(selectedIndex: _selectedIndex),
    );
  }
}

