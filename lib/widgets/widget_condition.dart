/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/kl_parser.dart';
import 'package:groningen_guide/widgets/widget_vars.dart';


class WidgetCondition extends StatelessWidget {
  final TreeElement element;
  final KlEngine engine;
  const WidgetCondition({Key key,
    @required this.engine,@required this.element}) : super(key: key);

  Widget _evaluate(BuildContext context, ThemeData theme) {
    try {
      var b = element.evaluate(engine.contextModel) != 0;
      return WidgetEvaluator(val: b);
    } catch(e) {
      return IconButton(
        splashRadius: 2.0,
        icon: Icon(Icons.error, color: Colors.red),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error evaluating expression: $e'),
              actions: [
                FlatButton(
                  child: Text('okay'),
                  onPressed: () => Navigator.of(context).pop(true)
                )
              ],
            )
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      children: <Widget> [
        Text(element.toString(), style: theme.textTheme.bodyText2),
        Text(' = '),
        _evaluate(context, theme)
      ]
    );
  }
}