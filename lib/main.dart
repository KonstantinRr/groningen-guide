/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/rotues/route_home.dart';
import 'package:groningen_guide/rotues/route_splash.dart';
import 'package:groningen_guide/rotues/route_unknown.dart';

void main() {
  // starts the main application
  runApp(const StudyGuide());
}


/// The main application widget that creates a [MaterialApp]
class StudyGuide extends StatelessWidget {
  const StudyGuide({Key key}) : super(key: key);

  /// Generates a [Route] when no other matching route is found
  Route onGenerateUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const RouteUnknwon(),
      settings: RouteSettings(name: settings.name));
  }

  /// Generates a [Route] for the specified [RouteSettings]
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'splash': return MaterialPageRoute(
        builder: (context) => const RouteSplash(destination: '/', delay: Duration(milliseconds: 500)),
        settings: const RouteSettings(name: 'splash'));
      case '/': return MaterialPageRoute(
        builder: (context) => const RouteHome(),
        settings: const RouteSettings(name: '/'));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groningen Guide',
      initialRoute: 'splash',
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onGenerateUnknownRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
    );
  }
}
