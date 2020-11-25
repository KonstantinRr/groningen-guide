/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_base.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/kl_parser.dart';

void main() {
  runApp(StudyGuide());
}

class KnowledgeBaseLoader extends StatelessWidget {
  final Widget Function(BuildContext) onErr;
  final Widget Function(BuildContext, KlEngine) onLoad;
  final String path;
  const KnowledgeBaseLoader({this.onErr, this.onLoad,
    this.path = 'assets/knowledge_base.json', Key key}) : super(key: key);

  Future<KlEngine> loadKlBase(String path) async {
    var string = await rootBundle.loadString(path);
    var engine = KlEngine.fromString(string);
    engine.expressionStorage.info();
    return engine;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<KlEngine>(
      future: loadKlBase(path),
      builder: (context, snap) {
        if (snap.hasData)
          return onLoad(context, snap.data);
        return onErr(context);
      },
    );
  }
}

class CustomKnowledgeLoader extends StatefulWidget {
  const CustomKnowledgeLoader({Key key}) : super(key: key);

  @override
  CustomKnowledgeLoaderState createState() => CustomKnowledgeLoaderState();
}

class CustomKnowledgeLoaderState extends State<CustomKnowledgeLoader> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      width: 200.0,
      height: 350.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          Expanded(child: TextField(
            controller: controller,
            decoration: InputDecoration.collapsed(
              hintText: 'Expression'
            ),
            expands: true,
          )),
          RaisedButton(
            child: Text('Load', style: theme.textTheme.button,),
            onPressed: () {},
          ),
        ]
      )
    );
  }
}


class QuestionWidget extends StatelessWidget {
  final KlQuestion question;
  const QuestionWidget({@required this.question, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(question.name, style: theme.textTheme.headline5),
          Text(question.description, style: theme.textTheme.bodyText2,),
          SizedBox(height: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: question.options.map((e) =>
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
    );
  }
}

class ExpressionParser extends StatefulWidget {
  const ExpressionParser({Key key}) : super(key: key);

  @override
  ExpressionParserState createState() => ExpressionParserState();
}

class ExpressionParserState extends State<ExpressionParser> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _loadExpression() {
    try {
      var tree = buildExpression(controller.text);
      print(tree.istr());
    } catch (e, stacktrace) {
      print(stacktrace);
      print(e.toString());
      throw e;
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0, height: 150.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: TextField(
            maxLines: null, minLines: null,
            controller: controller,
            decoration: InputDecoration.collapsed(
              hintText: 'Expression'
            ),
            expands: true,
          ),),
          RaisedButton(
            child: Text('Load Expression'),
            onPressed: _loadExpression
          )
        ],
      )
    );
  }
}


class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KnowledgeBaseLoader(
        onLoad: (context, engine) {
          return ListView(
            padding: EdgeInsets.all(15),
            children: [
              ...
              engine.klBase.questions.map((q) =>
                QuestionWidget(question: q)
              ),
              ExpressionParser(),
              SizedBox(
                height: 40.0,
                width: 150.0,
                child: RaisedButton(
                  child: Text('Evaluate Model'),
                  onPressed: () {
                    engine.inference();
                  },
                ),
              )
            ]
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
