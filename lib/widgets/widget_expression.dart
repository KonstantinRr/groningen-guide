/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_parser.dart';

class ExpressionParser extends StatefulWidget {
  const ExpressionParser({Key key}) : super(key: key);

  @override
  ExpressionParserState createState() => ExpressionParserState();
}

class ExpressionParserState extends State<ExpressionParser> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _loadExpression() {
    try {
      var tree = buildExpression(controller.text);
      print(tree.istr());
    } catch (e, stacktrace) {
      print(stacktrace);
      print(e.toString());
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0, height: 150.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: TextField(
            maxLines: null, minLines: null,
            controller: controller,
            decoration: InputDecoration.collapsed(
              hintText: 'Expression'
            ),
            expands: true,
          ),),
          RaisedButton(
            child: Text('Load Expression'),
            onPressed: _loadExpression
          )
        ],
      )
    );
  }
}