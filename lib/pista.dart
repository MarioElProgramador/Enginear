import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class PistaPage extends StatefulWidget {
  final String tema;
  final String apartado;

  const PistaPage({
    super.key,
    required this.tema,
    required this.apartado,
  });

  @override
  _PistaPageState createState() => _PistaPageState();
}

class _PistaPageState extends State<PistaPage> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final List<String> _pistas = [];
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
      _generatePista(widget.tema, widget.apartado);
    } else {
      throw Exception('Dotenv is not initialized. Make sure to load dotenv in main.dart');
    }
  }

  Future<void> _generatePista(String tema, String apartado) async {
    setState(() => _loading = true);

    try {
      final prompt = "Genera una pista para ayudar a resolver el ejercicio sobre el tema '$tema' y el apartado '$apartado' sin dar la respuesta completa.";
      final userMessage = Content.text(prompt);
      final response = await _chat.sendMessage(userMessage);
      final text = response.text;
      if (text != null) {
        setState(() {
          _pistas.add(text);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasApiKey = dotenv.env['API_KEY'] != null && dotenv.env['API_KEY']!.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pista"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: hasApiKey
                  ? ListView.builder(
                itemBuilder: (context, idx) {
                  final text = _pistas[idx];
                  return MessageWidget(text: text);
                },
                itemCount: _pistas.length,
              )
                  : ListView(
                children: const [
                  Text('No API key found. Please provide an API Key.'),
                ],
              ),
            ),
            if (_loading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String text;

  const MessageWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: MarkdownBody(
              selectable: true,
              data: text,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
