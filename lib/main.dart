import 'package:flutter/material.dart';

void main() {
  runApp(StudyGuide());
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class UnknownRoute extends StatelessWidget {
  const UnknownRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var name = ModalRoute.of(context).settings.name;
    return Scaffold(
      body: Center(
        child: Text('Error 404: Could not find route $name'),
      ),
    );
  }
}

class StudyGuide extends StatelessWidget {
  Route onGenerateUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => UnknownRoute(),
      settings: RouteSettings(name: settings.name));
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/': return MaterialPageRoute(builder: (context) => Home(),
        settings: const RouteSettings(name: '/'));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groningen Guide',
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onGenerateUnknownRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
    );
  }
}
