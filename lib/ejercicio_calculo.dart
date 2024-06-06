// ejercicio_calculo.dart
final List<Map<String, dynamic>> ejerciciosCalculo = [
  {
    'tipo': 'fill_in_blank',
    'pregunta': r'$$\lim_{x \to 2} (3x - 5) = \_\_\_$$',
    'respuesta': '1'
  },
  {
    'tipo': 'multiple_choice',
    'pregunta': r'¿Cuál es el valor de $$\lim_{x \to 0} \frac{\sin(x)}{x}$$?',
    'opciones': ['0', '1', 'Infinito', 'No existe'],
    'respuesta': '1'
  },
  {
    'tipo': 'drag_and_drop',
    'pregunta': 'Ordena las siguientes afirmaciones según el proceso de encontrar el límite de una función f(x) cuando x se aproxima a a.',
    'afirmaciones': [
      'Evaluar el valor de f(x) en a',
      'Considerar los límites laterales de f(x) en a',
      'Verificar que los límites laterales son iguales',
      'Concluir el valor del límite si los límites laterales coinciden'
    ],
    'respuesta': [
      'Considerar los límites laterales de f(x) en a',
      'Verificar que los límites laterales son iguales',
      'Evaluar el valor de f(x) en a',
      'Concluir el valor del límite si los límites laterales coinciden'
    ]
  },
  {
    'tipo': 'fill_in_blank',
    'pregunta': r'Si $$\lim_{x \to 3} f(x) = 7$$, entonces, por definición, para cualquier $$\epsilon > 0$$, existe un $$\delta > 0$$ tal que si $$0 < |x - 3| < \delta$$, entonces $$|f(x) - \_\_\_| < \epsilon$$.',
    'respuesta': '7'
  },
];
