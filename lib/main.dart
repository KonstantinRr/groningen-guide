import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_base.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(StudyGuide());
}

class KnowledgeBaseLoader extends StatelessWidget {
  final Widget Function(BuildContext) onErr;
  final Widget Function(BuildContext, KlBase) onLoad;
  final String path;
  const KnowledgeBaseLoader({this.onErr, this.onLoad,
    this.path = 'assets/knowledge_base.json', Key key}) : super(key: key);

  Future<KlBase> loadKlBase(String path) async {
    var string = await rootBundle.loadString(path);
    var map = json.decode(string);
    return KlBase.fromJson(map);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadKlBase(path),
      builder: (context, snap) {
        if (snap.hasData)
          return onLoad(context, snap.data);
        return onErr(context);
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: KnowledgeBaseLoader(
        onLoad: (context, base) {
          return ListView(
            padding: EdgeInsets.all(15),
            children: base.questions.map((q) =>
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(q.name, style: theme.textTheme.headline5),
                    Text(q.description, style: theme.textTheme.bodyText2,),
                    SizedBox(height: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: q.options.map((e) =>
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey[300]
                          ),
                          height: 50.0,
                          alignment: Alignment.center,
                          child: Text(e.description)
                        )
                      ).toList()
                    ),
                  ],
                ),
              )
            ).toList()
          );
        },
        onErr: (context) {
          return Center(child: Text('Error loading knowledge base'));
        },
      ),
    );
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
