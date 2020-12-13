/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/main.dart';
import 'package:groningen_guide/widgets/widget_condition.dart';
import 'package:groningen_guide/widgets/widget_event.dart';
import 'package:groningen_guide/widgets/widget_debugger.dart';
import 'package:provider/provider.dart';

class WidgetQuestion extends StatelessWidget {
  final KlQuestion question;

  const WidgetQuestion({
    @required this.question,
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
              Expanded(child: Text('${question.name}')),
            ]
          ),
          Row(
            children: [
              SizedBox(
                width: 50.0,
                child: Text('Descr:', style: theme.textTheme.bodyText1,),
              ),
              Expanded(child: Text('${question.description}')),
            ],
          ),

          Text('Conditions:', style: theme.textTheme.bodyText1,),
          Consumer<KlExpressionProvider>(
            builder: (context, expressionProvider, _) => Column(
              children: enumerate(expressionProvider.storage.questionConditions(question)).map((e) => 
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: <Widget> [
                      Text('${e.item1}+1}: ', style: theme.textTheme.bodyText1),
                      Expanded(child: WidgetCondition(element: e.item2))
                    ]
                  ),
                ),
              ).toList(),
            )
          ),
          Row(
            children: <Widget> [
              Text('Condition evaluated as: ', style: theme.textTheme.bodyText1,),
              Expanded(child: Align(
                alignment: Alignment.centerRight,
                child: Consumer<KlEngine>(
                  builder: (context, engine, _) =>
                    WidgetEvaluator(val: engine.evaluateQuestion(question)))
              ))
            ]
          ),

          ...
          enumerate(question.options).map((option) =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      Text('Option ${option.item1}+1}: ', style: theme.textTheme.bodyText1),
                      Expanded(child: Text('${option.item2.description}')),
                    ]
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...
                      enumerate(option.item2.events).map((e) =>
                        Padding(
                          padding: EdgeInsets.only(left: 0.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget> [
                              Text('Event ${e.item1+1}: ', style: theme.textTheme.bodyText1),
                              Expanded(child: Consumer<KlExpressionProvider>(
                                builder: (context, expressionStorage, _) =>
                                  WidgetEvent(
                                    element: expressionStorage.storage[e.item2],
                                  )
                              ))
                            ]
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ]
            )
          )
        ]
      ),
    );
  }
}