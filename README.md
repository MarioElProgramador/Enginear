# Enginear - Aplicación Educativa Matemática

Enginear es una aplicación educativa matemática desarrollada en Flutter y Dart, diseñada para ofrecer una experiencia de aprendizaje interactiva y personalizada. Utiliza la inteligencia artificial generativa de Google (Gemini) para generar contenido educativo y brindar asistencia en tiempo real.

## Características

- **Selección de Cursos**: Los usuarios pueden elegir entre una amplia variedad de cursos, incluyendo álgebra lineal, geometría, cálculo 1, cálculo 2, y muchos más.
- **Generación de Ecuaciones**: La aplicación genera ecuaciones matemáticas utilizando una API de inteligencia artificial generativa, proporcionando problemas personalizados y adecuados para cada nivel de aprendizaje.
- **Interfaz de Usuario Interactiva**: Una interfaz de usuario intuitiva y fácil de usar, con secciones claramente definidas para diferentes temas y funcionalidades.
- **Asistencia de Chatbot**: Un chatbot integrado que proporciona ayuda adicional y pistas para resolver problemas matemáticos, disponible a cambio de divisas ganadas dentro de la aplicación.
- **Sistema de Pistas**: Obtén pistas para resolver ejercicios a cambio de divisas, ayudando a los estudiantes a avanzar en su aprendizaje.

## Instalación

Para instalar y ejecutar este proyecto, necesitarás tener instalado Flutter y Dart en tu sistema. Sigue los pasos a continuación para clonar este repositorio y ejecutar la aplicación:

1. Clona este repositorio:

    ```bash
    git clone https://github.com/<your-github-username>/<your-repo-name>
    cd <your-repo-name>
    ```

2. Instala las dependencias:

    ```bash
    flutter pub get
    ```

3. Ejecuta la aplicación:

    ```bash
    flutter run
    ```

## Compilación

### Android

Para generar una build para Android, utiliza el siguiente comando:

```bash
flutter build apk --release
```

El archivo APK generado se encontrará en build/app/outputs/flutter-apk/app-release.apk.

### Web

Para generar una build para la web en Windows, utiliza el siguiente comando:

```bash
flutter build web --release
```

Los archivos generados se encontrarán en el directorio build/web.

## API Key

Importante: Por razones de seguridad, se ha borrado la API key usada para el proyecto. Para que funcionen los aspectos importantes de la aplicación, necesitarás obtener una API key de Google Cloud Platform o Google Vertex AI.

1. Obtén una API key de Google Cloud Platform o Google Vertex AI.

2. Coloca la API key en un archivo .env dentro del proyecto, de la siguiente manera:

API_KEY="TU_API_KEY"
