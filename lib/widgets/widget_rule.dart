/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_rule.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/widgets/widget_condition.dart';
import 'package:groningen_guide/widgets/widget_event.dart';
import 'package:groningen_guide/widgets/widget_debugger.dart';

class WidgetRule extends StatelessWidget {
  final KlEngine engine;
  final KlRule rule;

  const WidgetRule({@required this.engine,
    @required this.rule, Key key}) : super(key: key);

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
              Text('${rule.name}'),
            ]
          ),
          Row(
            children: [
              SizedBox(
                width: 50.0,
                child: Text('Descr:', style: theme.textTheme.bodyText1,),
              ),
              Text('${rule.description}'),
            ],
          ),

          Text('Conditions:', style: theme.textTheme.bodyText1,),
          ...
          enumerate(engine.ruleConditions(rule)).map((e) => 
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
              Text('Evaluated as: ', style: theme.textTheme.bodyText1,),
              WidgetEvaluator(val: engine.evaluateRule(rule))
            ]
          ),
          Column(
            children: [
              ...
              enumerate(rule.events).map((e) =>
                Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget> [
                      Text('Event ${e[0]+1}: ', style: theme.textTheme.bodyText1),
                      WidgetEvent(
                        element: engine.expressionStorage[e[1]],
                        engine: engine
                      )
                    ]
                  ),
                ),
              )
            ]
          )
        ]
      ),
    );
  }
}