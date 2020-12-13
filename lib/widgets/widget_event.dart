/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/kl_parser.dart';
import 'package:provider/provider.dart';

class WidgetEvent extends StatelessWidget {
  final TreeElement element;
  const WidgetEvent({Key key, @required this.element}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        Expanded(child: Text(element.toString(), style: theme.textTheme.bodyText2)),
        IconButton(
          icon: Icon(Icons.play_arrow, color: Colors.green),
          onPressed: () {
            var contextProvider = Provider.of<KlContextProvider>(context, listen: false);
            contextProvider.updateContextModel((cm) {
              element.evaluate(cm);
            });
          },
        )
      ]
    );
  }
}