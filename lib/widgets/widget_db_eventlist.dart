/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/main.dart';
import 'package:groningen_guide/widgets/widget_event.dart';
import 'package:provider/provider.dart';

class WidgetEventList extends StatelessWidget {
  final List<String> events;
  const WidgetEventList({Key key, this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Events', style: theme.textTheme.bodyText1,),
        ...
        enumerate(events).map((e) =>
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                Text('Event ${e.item1+1}: ', style: theme.textTheme.bodyText2),
                Expanded(child: Consumer<KlExpressionProvider>(
                  builder: (context, expressionStorage, _) =>
                    WidgetEvent(element: expressionStorage.storage[e.item2])
                ))
              ]
            ),
          ),
        )
      ],
    );
  }
}