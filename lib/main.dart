import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Daily use
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

const api_key = "AIzaSyAaC-LPg5kZOg8Z6tsY8otswHL_wVmSP8E";

// Access the API key as an environment variable
void initialize() {
  final apiKey = Platform.environment[api_key];
  if(apiKey == null) {
    print('No \$API_KEY environment variable');
    exit(1);
  }
  final model = GenerativeModel(model: 'MODEL_NAME', apiKey: apiKey);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
        ),
      ),
      home: PaginaPrincipal(),
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _contadorFuego = 0;
  DateTime _ultimaConexion = DateTime.now();
  bool _fuegoEncendido = false;
  String _curso = "Curso";

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
      _curso = prefs.getString('curso') ?? "Curso";
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

  Future<void> generarEcuacion() async {
    // API endpoint for the Google Gemini Pro model
    final url = Uri.parse('https://vertexai.googleapis.com/v1/projects/<your-project-id>/locations/<location>/models/<your-model-id>:predict');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $api_key',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'instances': [
          {
            'input': 'Generate a mathematical equation for a quadratic function with roots at x = 2 and x = -1', // Prompt to generate equation
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final equation = data['predictions'][0]['content'];
      print('Equation: $equation');

      // Display the generated equation in your UI
      // (e.g., using a Text widget)
    } else {
      print('Error: ${response.statusCode}');
      // Handle errors more gracefully, e.g., display an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionCurso()));
                    if (result != null) {
                      setState(() {
                        _curso = result;
                      });
                    }
                  },
                  child: Icon(Icons.school),
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionCurso()));
                    if (result != null) {
                      setState(() {
                        _curso = result;
                      });
                    }
                  },
                  child: Text(
                    '$_curso',
                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Spacer(),
            _fuegoEncendido
                ? Icon(Icons.whatshot, color: Colors.orange)
                : Icon(Icons.whatshot, color: Colors.grey[700]),
            SizedBox(width: 4.0),
            Text(
              '$_contadorFuego',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.attach_money),
            SizedBox(width: 4.0),
            Text(
              '0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.calculate),
              onPressed: () {
                generarEcuacion();
              },
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: AppBar(
            title: Text('Tema seleccionado', style: TextStyle(color: Colors.black)), // Cambia el color aquí
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey[200],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection("Apartado 1", Colors.blue, context),
            SizedBox(height: 16.0),
            _buildSection("Apartado 2", Colors.green, context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Color color, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: color,
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Column(
            children: [
              _buildLessonButton(Icons.edit, context),
              SizedBox(height: 16),
              _buildLessonButton(Icons.edit, context),
              SizedBox(height: 16),
              _buildLessonButton(Icons.edit, context),
              SizedBox(height: 16),
              _buildLessonButton(Icons.edit, context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessonButton(IconData iconData, BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(iconData),
        onPressed: () {
          // Acción al presionar el botón de la lección
        },
      ),
    );
  }
}

class SeleccionCurso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un curso'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: const Text('Matemáticas'),
            children: <Widget>[
              ListTile(
                title: const Text('Algebra lineal'),
                onTap: () {
                  Navigator.pop(context, 'Algebra lineal');
                },
              ),
              ListTile(
                title: const Text('Geometría'),
                onTap: () {
                  Navigator.pop(context, 'Geometría');
                },
              ),
              ListTile(
                title: const Text('Cálculo 1'),
                onTap: () {
                  Navigator.pop(context, 'Cálculo 1');
                },
              ),
              ListTile(
                title: const Text('Cálculo 2'),
                onTap: () {
                  Navigator.pop(context, 'Cálculo 2');
                },
              ),
              ListTile(
                title: const Text('...'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Ciencias'),
            children: <Widget>[
              ListTile(
                title: const Text('...'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Programación'),
            children: <Widget>[
              ListTile(
                title: const Text('...'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}