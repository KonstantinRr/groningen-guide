/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/widgets/widget_vars.dart';
import 'package:tuple/tuple.dart';

class QuestionWidget extends StatelessWidget {
  final Tuple2<KlQuestion, List<bool>> question;
  final void Function(int) change;
  const QuestionWidget({@required this.question,
    @required this.change, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(question.item1.name, style: theme.textTheme.headline5),
          Text(question.item1.description, style: theme.textTheme.bodyText2,),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: enumerate(question.item1.options).map((e) =>
              FlatButton(
                onPressed: () => change(e[0]),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: question.item2[e[0]] ? Colors.lightBlue : Colors.grey[300]
                  ),
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Text(e[1].description)
                ),
              )
            ).toList()
          ),
        ],
      ),
    );
  }
}
