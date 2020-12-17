/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

class WidgetEvaluator extends StatelessWidget {
  final bool val;
  const WidgetEvaluator({@required this.val, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Text('$val',
        style: theme.textTheme.bodyText2
          .copyWith(color: val ? Colors.green : Colors.red));
  }
}
