/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/loader/asset_loader.dart';
import 'package:groningen_guide/widgets/widget_expression.dart';
import 'package:groningen_guide/widgets/widget_question.dart';
import 'package:groningen_guide/widgets/widget_vars.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<KlEngine>(
      builder: (context, engine, _) =>
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              ...
              engine.klBase.questions.map((q) =>
                QuestionWidget(question: q)
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: ExpressionParser(),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15.0),
                height: 40.0, width: 150.0,
                child: RaisedButton(
                  child: Text('Evaluate Model'),
                  onPressed: () {
                    engine.inference();
                  },
                ),
              )
            ]
          ),
        ),
    );
  }
}

class RouteHome extends StatelessWidget {
  const RouteHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KnowledgeBaseLoader(
      onLoad: (context, engine) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth <= 850.0) {
              return Scaffold(
                appBar: AppBar(backgroundColor: Colors.grey[100],),
                body: const SingleChildScrollView(child: MainScreen()),
              );
            } else {
              return Scaffold(
                appBar: AppBar(backgroundColor: Colors.grey[100]),
                body: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget> [
                    const Expanded(flex: 2, child: SingleChildScrollView(child: MainScreen())),
                    const Expanded(flex: 1, child: ClipRect(child: WidgetVars())),
                  ]
                )
              );
            }
          }
        );
      },
      onErr: (context) {
        return Center(child: Text('Error loading knowledge base'));
      },
    );
  }
}