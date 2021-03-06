/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:tuple/tuple.dart';

import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/rotues/route_editor.dart';
import 'package:groningen_guide/rotues/route_end.dart';
import 'package:groningen_guide/rotues/route_endpoint.dart';
import 'package:groningen_guide/rotues/route_history.dart';
import 'package:groningen_guide/rotues/route_home.dart';
import 'package:groningen_guide/rotues/route_splash.dart';
import 'package:groningen_guide/rotues/route_unknown.dart';

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  // starts the main application
  runApp(const StudyGuide());
}

Iterable<Tuple2<int, T>> enumerate<T>(Iterable<T> it) sync* {
  int index = 0;
  for (var val in it) {
    yield Tuple2(index, val);
    index++;
  }
}

Iterable<Tuple2<A, B>> chain2<A, B>(Iterable<A> first, Iterable<B> second) sync* {
  var it1 = first.iterator;
  var it2 = second.iterator;
  while (it1.moveNext() && it2.moveNext())
    yield Tuple2<A, B>(it1.current, it2.current);
}

/// The main application widget that creates a [MaterialApp]
class StudyGuide extends StatelessWidget {
  const StudyGuide({Key key}) : super(key: key);

  /// Generates a [Route] when no other matching route is found
  Route onGenerateUnknownRoute(RouteSettings settings) =>
    MaterialPageRoute(builder: (context) => const RouteUnknown(),
      settings: RouteSettings(name: settings.name));

  /// Generates a [Route] for the specified [RouteSettings]
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'splash': return MaterialPageRoute(
        builder: (context) => const RouteSplash(destination: '/', delay: Duration(milliseconds: 500)),
        settings: const RouteSettings(name: 'splash'));
      case '/': return MaterialPageRoute(
        builder: (context) => RouteHome(),
        settings: const RouteSettings(name: '/'));
      case '/editor': return MaterialPageRoute(
        builder: (context) => const RouteEditor(),
        settings: const RouteSettings(name: 'editor'));
      case '/endpoint': return MaterialPageRoute(
        builder: (context) => RouteEndpoint.fromSettings(settings.arguments),
        settings: const RouteSettings(name: 'endpoint'));
      case '/end': return MaterialPageRoute(
        builder: (context) => const RouteEnd(),
        settings: const RouteSettings(name: 'end'));
      case '/history': return MaterialPageRoute(
        builder: (context) => const RouteHistory(),
        settings: const RouteSettings(name: 'history'));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return EngineSession(
      child: QuestionSession(
        child: MaterialApp(
          title: 'Angel\'s Groningen Guide',
          initialRoute: 'splash',
          onGenerateRoute: onGenerateRoute,
          onUnknownRoute: onGenerateUnknownRoute,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.lightBlue[300],
            accentColor: Colors.lightBlueAccent[300],
            appBarTheme: AppBarTheme(
              color: Colors.grey[100]
            ),
          ),
        ),
      )
    );
  }
}
