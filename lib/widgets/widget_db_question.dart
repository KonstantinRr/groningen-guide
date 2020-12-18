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
import 'package:groningen_guide/widgets/widget_db_conditionlist.dart';
import 'package:groningen_guide/widgets/widget_db_description.dart';
import 'package:groningen_guide/widgets/widget_db_eventlist.dart';
import 'package:groningen_guide/widgets/widget_db_name.dart';
import 'package:groningen_guide/widgets/widget_db_variables.dart';
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
          WidgetObjectName(name: question.name),
          WidgetObjectDescription(description: question.description),
          WidgetConditionList(
            eventCallback: (prov) => prov.storage.questionConditions(question),
            evaluatorCallback: (engine) => engine.evaluateQuestion(question)
          ),

          ...
          enumerate(question.options).map((option) =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      Text('Option ${option.item1+1}: ', style: theme.textTheme.bodyText1),
                      Expanded(child: Text('${option.item2.description}')),
                    ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: WidgetEventList(events: option.item2.events)
                )
              ]
            )
          )
        ]
      ),
    );
  }
}