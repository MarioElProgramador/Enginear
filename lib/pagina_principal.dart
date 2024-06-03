import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enginear/seleccion_curso.dart';
import 'package:enginear/data_structure.dart';
import 'package:enginear/seleccion_tema.dart';
import 'package:enginear/leccion.dart';  // Importar la pantalla de lección
import 'chatbot.dart';  // Importar el chatbot

class PaginaPrincipal extends StatefulWidget {
  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _contadorFuego = 0;
  DateTime _ultimaConexion = DateTime.now();
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
      _ultimaConexion = DateTime.parse(prefs.getString('ultimaConexion') ?? DateTime.now().toString());
      _fuegoEncendido = _esFuegoEncendido(_ultimaConexion);
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
    return diferencia.inDays >= 1;
  }

  Future<void> _verificarActualizacion() async {
    DateTime ahora = DateTime.now();
    if (ahora.day != _ultimaConexion.day || ahora.month != _ultimaConexion.month || ahora.year != _ultimaConexion.year) {
      setState(() {
        _contadorFuego++;
        _ultimaConexion = ahora;
        _fuegoEncendido = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('contadorFuego', _contadorFuego);
      await prefs.setString('ultimaConexion', _ultimaConexion.toString());
    }
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
    List<String> temas = materias[_materia]?[_asignatura]?.keys?.toList() ?? [];
    return temas.indexOf(_tema) + 1;
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PaginaPrincipal()),
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

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.06;
    double textSize = MediaQuery.of(context).size.width * 0.045;
    double spacing = MediaQuery.of(context).size.width * 0.02;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 160.0,
        leading: GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SeleccionCurso()),
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
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Icon(Icons.school, size: iconSize),
                SizedBox(width: 4.0),
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
        title: null,
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Icon(Icons.whatshot, color: _fuegoEncendido ? Colors.orange : Colors.grey[700], size: iconSize),
                SizedBox(width: spacing),
                Text(
                  '$_contadorFuego',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),
                ),
                SizedBox(width: spacing),
                Icon(Icons.favorite, size: iconSize, color: Colors.red),
                SizedBox(width: spacing),
                Text(
                  '$_vidas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),
                ),
                SizedBox(width: spacing),
                Icon(Icons.attach_money, size: iconSize, color: Colors.green),
                SizedBox(width: spacing * 0.5),
                Text(
                  '$_divisas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),
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
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tema ${_getTemaIndex()}: $_tema',
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_drop_down_circle),
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
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Apartado ${index + 1}: $apartado',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
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
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  // Acción para iniciar una lección
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LeccionPage(
                                        tema: _tema,
                                        apartado: apartado,
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
        iconSize: 40.0,
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
