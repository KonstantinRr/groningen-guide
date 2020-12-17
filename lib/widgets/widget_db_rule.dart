/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:groningen_guide/main.dart';
import 'package:groningen_guide/kl/kl_rule.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/widgets/widget_db_conditionlist.dart';
import 'package:groningen_guide/widgets/widget_db_description.dart';
import 'package:groningen_guide/widgets/widget_db_name.dart';
import 'package:groningen_guide/widgets/widget_event.dart';

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
          WidgetObjectName(name: rule.name),
          WidgetObjectDescription(description: rule.description),
          WidgetConditionList(
            eventCallback: (prov) => prov.storage.ruleConditions(rule),
            evaluatorCallback: (engine) => engine.evaluateRule(rule),
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
                      Text('Event ${e.item1+1}: ', style: theme.textTheme.bodyText1),
                      Expanded(child: Consumer<KlExpressionProvider>(
                        builder: (context, expressionProvider, _) =>
                          WidgetEvent(
                            element: expressionProvider.storage[e.item2],
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