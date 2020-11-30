/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/widgets/widget_condition.dart';
import 'package:groningen_guide/widgets/widget_vars.dart';


class WidgetQuestion extends StatelessWidget {
  final KlQuestion question;
  final KlEngine engine;

  const WidgetQuestion({
    @required this.question, @required this.engine,
    Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: <Widget> [
              SizedBox(
                width: 50.0,
                child: Text('Name:', style: theme.textTheme.bodyText1,),
              ),
              Text('${question.name}'),
            ]
          ),
          Row(
            children: [
              SizedBox(
                width: 50.0,
                child: Text('Descr:', style: theme.textTheme.bodyText1,),
              ),
              Text('${question.description}'),
            ],
          ),

          Text('Conditions:', style: theme.textTheme.bodyText1,),
          ...
          enumerate(engine.questionConditions(question)).map((e) => 
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                children: <Widget> [
                  Text('${e[0]+1}: ', style: theme.textTheme.bodyText1),
                  WidgetCondition(element: e[1], engine: engine)
                ]
              ),
            ),
          ),
          Row(
            children: <Widget> [
              Text('Condition evaluated as: ', style: theme.textTheme.bodyText1,),
              WidgetEvaluator(val: engine.evaluateQuestion(question))
            ]
          ),
        ]
      ),
    );
  }
}