// lib/ejercicios.dart

const List<Map<String, dynamic>> ejerciciosDefinicionDerivada = [
  {
    'tipo': 'multiple_choice',
    'pregunta': '¿Cuál es la derivada de f(x) = x^2?',
    'opciones': ['2x', 'x', '2', 'x^2'],
    'respuesta': '2x',
  },
  {
    'tipo': 'fill_in_blank',
    'pregunta': 'Encuentra la derivada de f(x) = 3x^3.',
    'respuesta': '9x^2',
  },
];

const List<Map<String, dynamic>> ejerciciosReglasDerivacion = [
  {
    'tipo': 'multiple_choice',
    'pregunta': '¿Cuál es la regla de la potencia para derivadas?',
    'opciones': [
      'Si f(x) = x^n, entonces f\'(x) = nx^(n-1)',
      'Si f(x) = x^n, entonces f\'(x) = n',
      'Si f(x) = x^n, entonces f\'(x) = x^(n-1)',
      'Si f(x) = x^n, entonces f\'(x) = n^x'
    ],
    'respuesta': 'Si f(x) = x^n, entonces f\'(x) = nx^(n-1)',
  },
  {
    'tipo': 'fill_in_blank',
    'pregunta': 'Deriva la función f(x) = 5x^4.',
    'respuesta': '20x^3',
  },
];
