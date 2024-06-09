// lib/ejercicio_calculo.dart

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class Quiz {
  final String statement;
  final List<QuizOption> options;
  final String correctOptionId;

  Quiz(
      {required this.statement,
        required this.options,
        required this.correctOptionId});
}

class QuizOption {
  final String id;
  final String option;

  QuizOption(this.id, this.option);
}

class TeXViewQuizExample extends StatefulWidget {
  final TeXViewRenderingEngine renderingEngine;

  const TeXViewQuizExample(
      {super.key, this.renderingEngine = const TeXViewRenderingEngine.katex()});

  @override
  State<TeXViewQuizExample> createState() => _TeXViewQuizExampleState();
}

class _TeXViewQuizExampleState extends State<TeXViewQuizExample> {
  int currentQuizIndex = 0;
  String selectedOptionId = "";
  bool isWrong = false;

  List<Quiz> quizList = [
    Quiz(
      statement: r"""<h3>¿Cuál es la derivada de \(f(x) = x^2\)?</h3>""",
      options: [
        QuizOption(
          "id_1",
          r""" <h2>(A)   \(2x\)</h2>""",
        ),
        QuizOption(
          "id_2",
          r""" <h2>(B)   \(x^2\)</h2>""",
        ),
        QuizOption(
          "id_3",
          r""" <h2>(C)   \(2\)</h2>""",
        ),
        QuizOption(
          "id_4",
          r""" <h2>(D)   \(x\)</h2>""",
        ),
      ],
      correctOptionId: "id_1",
    ),
    Quiz(
      statement: r"""<h3>Seleccione la regla de derivación correcta para \(f(x) = x^3\).</h3>""",
      options: [
        QuizOption(
          "id_1",
          r""" <h2>(A)   \(3x^2\)</h2>""",
        ),
        QuizOption(
          "id_2",
          r""" <h2>(B)   \(3x^3\)</h2>""",
        ),
        QuizOption(
          "id_3",
          r""" <h2>(C)   \(x^2\)</h2>""",
        ),
        QuizOption(
          "id_4",
          r""" <h2>(D)   \(x^3\)</h2>""",
        ),
      ],
      correctOptionId: "id_1",
    ),
    Quiz(
      statement: r"""<h3>¿Cuál es la derivada de la función \(f(x) = e^x\)?</h3>""",
      options: [
        QuizOption(
          "id_1",
          r""" <h2>(A)   \(e^x\)</h2>""",
        ),
        QuizOption(
          "id_2",
          r""" <h2>(B)   \(xe^x\)</h2>""",
        ),
        QuizOption(
          "id_3",
          r""" <h2>(C)   \(e^{2x}\)</h2>""",
        ),
        QuizOption(
          "id_4",
          r""" <h2>(D)   \(2e^x\)</h2>""",
        ),
      ],
      correctOptionId: "id_1",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("TeXView Quiz"),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: <Widget>[
          Text(
            'Quiz ${currentQuizIndex + 1}/${quizList.length}',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          TeXView(
            renderingEngine: widget.renderingEngine,
            child: TeXViewColumn(children: [
              TeXViewDocument(quizList[currentQuizIndex].statement,
                  style:
                  const TeXViewStyle(textAlign: TeXViewTextAlign.center)),
              TeXViewGroup(
                  children: quizList[currentQuizIndex]
                      .options
                      .map((QuizOption option) {
                    return TeXViewGroupItem(
                        rippleEffect: false,
                        id: option.id,
                        child: TeXViewDocument(option.option,
                            style: const TeXViewStyle(
                                padding: TeXViewPadding.all(10))));
                  }).toList(),
                  selectedItemStyle: TeXViewStyle(
                      borderRadius: const TeXViewBorderRadius.all(10),
                      border: TeXViewBorder.all(TeXViewBorderDecoration(
                          borderWidth: 3, borderColor: Colors.green[900])),
                      margin: const TeXViewMargin.all(10)),
                  normalItemStyle:
                  const TeXViewStyle(margin: TeXViewMargin.all(10)),
                  onTap: (id) {
                    selectedOptionId = id;
                    setState(() {
                      isWrong = false;
                    });
                  })
            ]),
            style: const TeXViewStyle(
              margin: TeXViewMargin.all(5),
              padding: TeXViewPadding.all(10),
              borderRadius: TeXViewBorderRadius.all(10),
              border: TeXViewBorder.all(
                TeXViewBorderDecoration(
                    borderColor: Colors.blue,
                    borderStyle: TeXViewBorderStyle.solid,
                    borderWidth: 5),
              ),
              backgroundColor: Colors.white,
            ),
          ),
          if (isWrong)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "¡Respuesta incorrecta! Por favor, elige la opción correcta.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (currentQuizIndex > 0) {
                      selectedOptionId = "";
                      currentQuizIndex--;
                    }
                  });
                },
                child: const Text("Anterior"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (selectedOptionId ==
                        quizList[currentQuizIndex].correctOptionId) {
                      selectedOptionId = "";
                      if (currentQuizIndex != quizList.length - 1) {
                        currentQuizIndex++;
                      }
                    } else {
                      isWrong = true;
                    }
                  });
                },
                child: const Text("Siguiente"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
