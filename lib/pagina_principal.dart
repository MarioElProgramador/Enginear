import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enginear/seleccion_curso.dart';
import 'package:enginear/data_structure.dart';
import 'package:enginear/seleccion_tema.dart';
import 'package:enginear/leccion.dart';
import 'chatbot.dart';
import 'apuntes.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _contadorFuego = 0;
  DateTime _ultimaLeccionFecha = DateTime.now();
  bool _fuegoEncendido = false;
  String _materia = "Materia";
  String _asignatura = "Asignatura";
  String _tema = "Tema";
  int _divisas = 150;
  int _vidas = 5;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _contadorFuego = prefs.getInt('contadorFuego') ?? 0;
      _ultimaLeccionFecha = DateTime.parse(prefs.getString('ultimaLeccionFecha') ?? DateTime.now().toString());
      _fuegoEncendido = _esFuegoEncendido(_ultimaLeccionFecha);
      _materia = prefs.getString('materia') ?? "Materia";
      _asignatura = prefs.getString('asignatura') ?? "Asignatura";
      _tema = prefs.getString('tema') ?? "Tema";
      _divisas = prefs.getInt('divisas') ?? 150;
      _vidas = prefs.getInt('vidas') ?? 5;
    });
    _verificarActualizacion();
  }

  bool _esFuegoEncendido(DateTime fecha) {
    DateTime ahora = DateTime.now();
    Duration diferencia = ahora.difference(fecha);
    return diferencia.inDays < 1;
  }

  Future<void> _verificarActualizacion() async {
    DateTime ahora = DateTime.now();
    if (ahora.day != _ultimaLeccionFecha.day || ahora.month != _ultimaLeccionFecha.month || ahora.year != _ultimaLeccionFecha.year) {
      setState(() {
        _fuegoEncendido = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('fuegoEncendido', _fuegoEncendido);
    }
  }

  Future<void> _actualizarRacha() async {
    DateTime ahora = DateTime.now();
    setState(() {
      _ultimaLeccionFecha = ahora;
      if (!_fuegoEncendido) {
        _fuegoEncendido = true;
        _contadorFuego++;
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultimaLeccionFecha', _ultimaLeccionFecha.toString());
    await prefs.setBool('fuegoEncendido', _fuegoEncendido);
    await prefs.setInt('contadorFuego', _contadorFuego);
  }

  Future<void> _actualizarDivisas(int cantidad) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _divisas = cantidad;
    });
    await prefs.setInt('divisas', _divisas);
  }

  Future<void> _actualizarVidas(int cantidad) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _vidas = cantidad;
    });
    await prefs.setInt('vidas', _vidas);
  }

  int _getTemaIndex() {
    List<String> temas = materias[_materia]?[_asignatura]?.keys.toList() ?? [];
    return temas.indexOf(_tema) + 1;
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PaginaPrincipal()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Chatbot()),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onLeccionCompleta() {
    _actualizarRacha();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    double iconSize = isMobile ? 24.0 : MediaQuery.of(context).size.width * 0.04;
    double textSize = isMobile ? 18.0 : MediaQuery.of(context).size.width * 0.035;
    double spacing = isMobile ? 8.0 : MediaQuery.of(context).size.width * 0.015;
    double paddingHorizontal = isMobile ? 8.0 : MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SeleccionCurso()),
            );
            if (result != null) {
              setState(() {
                _materia = result['materia'] ?? _materia;
                _asignatura = result['asignatura'] ?? _asignatura;
                _tema = result['tema'] ?? _tema;
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('materia', _materia);
              await prefs.setString('asignatura', _asignatura);
              await prefs.setString('tema', _tema);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Row(
              children: [
                Icon(Icons.school, size: iconSize),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    _asignatura,
                    style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.whatshot, color: _fuegoEncendido ? Colors.orange : Colors.grey[700], size: iconSize),
                    SizedBox(width: spacing),
                    Text(
                      '$_contadorFuego',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),
                    ),
                  ],
                ),
                SizedBox(width: spacing * 2),
                Row(
                  children: [
                    Icon(Icons.favorite, size: iconSize, color: Colors.red),
                    SizedBox(width: spacing),
                    Text(
                      '$_vidas',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),
                    ),
                  ],
                ),
                SizedBox(width: spacing * 2),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: iconSize, color: Colors.green),
                    SizedBox(width: spacing * 0.5),
                    Text(
                      '$_divisas',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue[100],
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tema ${_getTemaIndex()}: $_tema',
                    style: const TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward), // Cambio de icono aquí
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeleccionTema(
                          materia: _materia,
                          asignatura: _asignatura,
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _tema = result['tema'] ?? _tema;
                      });
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('tema', _tema);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _getApartados().length,
              itemBuilder: (context, index) {
                String apartado = _getApartados()[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.green[100],
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Apartado ${index + 1}: $apartado',
                              style: const TextStyle(fontSize: 18),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.menu_book),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApuntesPage(
                                    tema: _tema,
                                    apartado: apartado,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LeccionPage(
                                        materia: _materia,
                                        asignatura: _asignatura,
                                        tema: _tema,
                                        subapartado: apartado,
                                        vidas: _vidas,
                                        divisas: _divisas,
                                        onLeccionCompleta: _onLeccionCompleta,
                                      ),
                                    ),
                                  );
                                },
                                iconSize: 50,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: '',
          ),
        ],
        iconSize: isMobile ? 28.0 : 40.0,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  List<String> _getApartados() {
    Map<String, List<String>>? temas = materias[_materia]?[_asignatura];
    List<String> apartados = temas?[_tema] ?? [];
    return apartados;
  }
}
