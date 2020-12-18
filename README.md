## Groningen Guide | UNIVERSITY OF GRONINGEN

The Groningen tourist and study guide.
View the live website [here](https://studyguide.esync.dev).

## Getting Started
This project implements a tourist guide for the city of Groningen located in the north of the Netherlands using a customized knowledge engine. There is a detailed description on how the knowledge base and engine work [here](knowledgebase.md).

### Installing Flutter
The project is build using the [Flutter](https://flutter.dev/) framework. See the [documentation](https://flutter.dev/docs) for more information about [installing](https://flutter.dev/docs/get-started/install) the framework or building applications using it. Flutter allows to build native user interfaces for various different platforms with the same codebase. This includes support for Android (requires AndroidSDK) and iOS (requires MacOS & XCode) as well as web development using HTML with the combination of a JavaScript canvas. It also supports building as native Windows (requires WindowsSDK) and Linux (requires development headers)  executables, however this feature is still experimental.

```
git clone https://github.com/KonstantinRr/groningen-guide/
cd groningen-guide
flutter pub get    # Get the required dependencies
```


### Building the inference model
The inference model is mainly intended as an web interface but can be compiled to Android or iOS as well using the same codebase. See the build instructions below to see how to build for the specific target platform. The resulting files are located in the build/ directory.

```
flutter build web --release
flutter build android --release
flutter build ios --release
flutter build linux --release # EXPERIMENTAL
flutter build windows --release # EXPERIMENTAl
```

## Running the model
The inference model can also be dynamically deployed for testing.

```
flutter run -d web/android/ios/linux/windows
```

## Additional dependencies
The project uses a list of additional dependencies freely available from [pub](https://pub.dev/).

| Package | Version | License |
| ------- | ------- | ------- |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons) | ^1.0.0 | MIT |
| [url_launcher](https://pub.dev/packages/url_launcher) | ^5.7.10 | BSD |
| [provider](https://pub.dev/packages/provider) | ^4.3.2+2 | MIT |
| [tuple](https://pub.dev/packages/tuple/) | ^1.0.3 | BSD |
| [logging](https://pub.dev/packages/logging) | ^0.11.4 | BSD |
| [auto_size_text](https://pub.dev/packages/auto_size_text) | ^2.1.0 | MIT |

## Reference
This project is build for the course Knowledge Technology Practical at the University of Groningen (WBAI014-05).

Konstantin Rolf (S3750558)<br/>
Nicholas Koundouros (S3726444)<br/>
Livia Regus (S3354970)
