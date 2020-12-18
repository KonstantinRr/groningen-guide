/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

class WidgetObjectName extends StatelessWidget {
  final String name;
  const WidgetObjectName({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        SizedBox(
          width: 50.0,
          child: Text('Name:', style: Theme.of(context).textTheme.bodyText1,),
        ),
        Expanded(child: Text(name)),
      ]
    );
  }
}