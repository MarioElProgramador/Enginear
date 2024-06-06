import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  final List<Map<String, dynamic>> _chatHistory = [];

  @override
  void initState() {
    super.initState();
    if (dotenv.isInitialized) {
      _model = GenerativeModel(
        model: "gemini-pro",
        apiKey: dotenv.env['API_KEY']!,
      );
      _chat = _model.startChat();
      _sendInitialMessage();
    } else {
      throw Exception('Dotenv is not initialized. Make sure to load dotenv in main.dart');
    }
  }

  void _sendInitialMessage() {
    const initialMessage = "¡Hola! Soy el chatbot aplicado a Enginear utilizando Gemini. Mis conocimientos son generales y no específicos al entorno de matemáticas, por lo que recomiendo un uso responsable. ¿En qué puedo ayudarte hoy?";
    setState(() {
      _chatHistory.add({'text': initialMessage, 'isUser': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasApiKey = dotenv.env['API_KEY'] != null && dotenv.env['API_KEY']!.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot de Enginear"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: hasApiKey
                  ? ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, idx) {
                  final content = _chatHistory[idx];
                  final text = content['text'];
                  final isUser = content['isUser'];
                  return MessageWidget(
                    text: text,
                    isFromUser: isUser,
                  );
                },
                itemCount: _chatHistory.length,
              )
                  : ListView(
                children: const [
                  Text('No API key found. Please provide an API Key.'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        hintText: 'Escribe tu mensaje',
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(14),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(14),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      onFieldSubmitted: (String value) {
                        _sendChatMessage(value);
                      },
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 15,
                  ),
                  if (!_loading)
                    IconButton(
                      onPressed: () async {
                        _sendChatMessage(_textController.text);
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  else
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() => _loading = true);

    try {
      setState(() {
        _chatHistory.add({'text': message, 'isUser': true});
      });

      final userMessage = Content.text(message);
      final response = await _chat.sendMessage(userMessage);
      final text = response.text;
      if (text != null) {
        setState(() {
          _chatHistory.add({'text': text, 'isUser': false});
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _textController.clear();
      setState(() => _loading = false);
    }
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isFromUser;

  const MessageWidget({
    super.key,
    required this.text,
    required this.isFromUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: isFromUser ? Colors.blue[100] : Colors.grey[300],
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
                p: TextStyle(
                  color: isFromUser ? Colors.black : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
