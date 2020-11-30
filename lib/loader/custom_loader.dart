/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';


class CustomKnowledgeLoader extends StatefulWidget {
  const CustomKnowledgeLoader({Key key}) : super(key: key);

  @override
  CustomKnowledgeLoaderState createState() => CustomKnowledgeLoaderState();
}

class CustomKnowledgeLoaderState extends State<CustomKnowledgeLoader> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      width: 200.0,
      height: 350.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          Expanded(child: TextField(
            maxLines: null, minLines: null,
            controller: controller,
            decoration: InputDecoration.collapsed(
              hintText: 'Knowledge Base'
            ),
            expands: true,
          )),
          RaisedButton(
            child: Text('Load', style: theme.textTheme.button,),
            onPressed: () {},
          ),
        ]
      )
    );
  }
}