/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/widgets/widget_db_evaluator.dart';
import 'package:provider/provider.dart';

import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/kl_parser.dart';
import 'package:groningen_guide/main.dart';
import 'package:groningen_guide/widgets/widget_condition.dart';

class WidgetConditionList extends StatelessWidget {
  final List<TreeElement> Function(KlExpressionProvider) eventCallback;
  final bool Function(KlEngine) evaluatorCallback;
  const WidgetConditionList({Key key,
    @required this.eventCallback,
    @required this.evaluatorCallback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget> [
          Text('Conditions:', style: theme.textTheme.bodyText1,),
          Consumer<KlExpressionProvider>(
            builder: (context, expressionProvider, _) => Column(
              children: enumerate(eventCallback(expressionProvider)).map((e) => 
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: <Widget> [
                      Text('${e.item1+1}: ', style: theme.textTheme.bodyText1),
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
                    WidgetEvaluator(val: evaluatorCallback(engine)))
              ))
            ]
          ),
      ]
    );
  }
}
