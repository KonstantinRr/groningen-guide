/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/loader/asset_loader.dart';
import 'package:groningen_guide/widgets/widget_expression.dart';
import 'package:groningen_guide/widgets/widget_question.dart';


class RouteHome extends StatelessWidget {
  const RouteHome({Key key}) : super(key: key);

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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: ExpressionParser(),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15.0),
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