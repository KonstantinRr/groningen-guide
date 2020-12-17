# Groningen Guide | UNIVERSITY OF GRONINGEN

The Groningen tourist and study guide.
View the live website [here](https://studyguide.esync.dev).

## Getting Started
This project implements a tourist guide for the city of Groningen located in the north of the Netherlands. There is a detailed description on how the knowledge base and engine work [here](knowledgebase.md).

## Building

### Installing Flutter
The project is build using the [Flutter](https://flutter.dev/) framework. See the [documentation](https://flutter.dev/docs) for more information about installing the framework or building applications using it. Flutter allows to build native user interfaces for various different platforms with the same codebase. This includes Android, iOS as well as web development using HTML with the combination of a JavaScript canvas.

### Building the study guide
The study guide is mainly intended as an web interface but can be compiled to Android or iOS as well using the same codebase. See the build instructions below for more information. The resulting files are located in the build/ directory. Use any suitable web server to run the web version of the project.

```
flutter build web --release
flutter build android --release
flutter build ios --release
```

## Reference
This project is build for the course Knowledge Technology Practical at the University of Groningen (WBAI014-05).
Konstantin Rolf (S3750558)
Nicholas Koundouros (S3726444)
Livia Regus (S3354970)
