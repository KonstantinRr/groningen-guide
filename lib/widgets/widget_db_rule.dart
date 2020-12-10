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
import 'package:provider/provider.dart';

class WidgetRule extends StatelessWidget {
  final KlRule rule;

  const WidgetRule({@required this.rule, Key key}) : super(key: key);

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
              Expanded(child: Text('${rule.name}')),
            ]
          ),
          Row(
            children: [
              SizedBox(
                width: 50.0,
                child: Text('Descr:', style: theme.textTheme.bodyText1,),
              ),
              Expanded(child: Text('${rule.description}')),
            ],
          ),
          Text('Conditions:', style: theme.textTheme.bodyText1,),
          Consumer<KlExpressionProvider>(
            builder: (context, expressionProvider, _) => Column(
              children: enumerate(expressionProvider.storage.ruleConditions(rule)).map((e) => 
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: <Widget> [
                      Text('${e[0]+1}: ', style: theme.textTheme.bodyText1),
                      Expanded(child: WidgetCondition(element: e[1]))
                    ]
                  ),
                ),
              ).toList()
            )
          ),
          Row(
            children: <Widget> [
              Text('Evaluated as: ', style: theme.textTheme.bodyText1,),
              Expanded(child: Align(
                alignment: Alignment.centerRight,
                child: Consumer<KlEngine>(
                  builder: (context, engine, _) => WidgetEvaluator(val: engine.evaluateRule(rule))
                ),
              ))
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
                      Expanded(child: Consumer<KlExpressionProvider>(
                        builder: (context, expressionProvider, _) =>
                          WidgetEvent(
                            element: expressionProvider.storage[e[1]],
                          ),
                      ))
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