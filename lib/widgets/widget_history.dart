/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/kl_parser.dart';
import 'package:groningen_guide/main.dart';
import 'package:groningen_guide/model_actions.dart';
import 'package:tuple/tuple.dart';

class WidgetHistroyElement extends StatelessWidget {
  final QuestionData questionData;
  final Tuple2<int, Tuple3<KlQuestion, List<bool>, ContextModel>> tup;
  const WidgetHistroyElement({
    @required this.questionData, @required this.tup, Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var question = tup.item2;
    return Container(
      padding: const EdgeInsets.all(7),
      color: tup.item1.isOdd ? Colors.grey[200] : Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          Row(
            children: <Widget> [
              Expanded(child: Text(tup.item2.item1.name)),
              IconButton(
                icon: Icon(Icons.play_arrow, color: Colors.green),
                splashRadius: 20.0,
                onPressed: () {
                  for (var i = questionData.previous.length; i > tup.item1; i--)
                    previousQuestion(context);
                }
              )
            ]
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: chain2(question.item1.options, question.item2).map((e) => 
                Row(
                  children: [
                    Checkbox(
                      value: e.item2,
                      onChanged: (val) {},
                    ),
                    Expanded(child: Text(e.item1.description),)
                  ],
                )).toList()
            ),
          )
        ]
      )
    );
  }
}
