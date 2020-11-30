/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_question.dart';

class QuestionWidget extends StatelessWidget {
  final KlQuestion question;
  const QuestionWidget({@required this.question, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(question.name, style: theme.textTheme.headline5),
          Text(question.description, style: theme.textTheme.bodyText2,),
          SizedBox(height: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: question.options.map((e) =>
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[300]
                ),
                height: 50.0,
                alignment: Alignment.center,
                child: Text(e.description)
              )
            ).toList()
          ),
        ],
      ),
    );
  }
}