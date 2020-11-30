/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/widgets/widget_questioninfo.dart';
import 'package:groningen_guide/widgets/widget_rule.dart';
import 'package:provider/provider.dart';

Iterable<List> enumerate(Iterable<dynamic> it) sync* {
  int index = 0;
  for (var val in it) {
    yield [ index, val ];
    index++;
  }
}

class WidgetEvaluator extends StatelessWidget {
  final bool val;
  const WidgetEvaluator({@required this.val, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Text('$val', style: theme.textTheme.bodyText2.copyWith(
      color: val ? Colors.green : Colors.red));
  }
}

class WidgetVars extends StatelessWidget {
  const WidgetVars({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      color: Colors.white,
      child: Consumer<KlEngine>(
        builder: (context, engine, _) {
          return ListView(
            children: <Widget> [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                alignment: Alignment.center,
                child: Text('Variables', style: theme.textTheme.headline5,),
              ),
              ...
              enumerate(engine.contextModel.model.entries).map((e) =>
                Container(
                  padding: const EdgeInsets.all(7),
                  color: e[0].isOdd ? Colors.grey[200] : Colors.grey[100],
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: e[1].value != 0,
                        onChanged: (val) => engine.updateContextModel(
                          (model) => model.setVar(e[1].key, val ? 1 : 0)),
                      ),
                      Container(
                        width: 150.0,
                        height: 40.0,
                        alignment: Alignment.center,
                        child: Text(e[1].key),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                alignment: Alignment.center,
                child: Text('Rules', style: theme.textTheme.headline5,),
              ),
              ...
              enumerate(engine.klBase.rules).map<Widget>((r) =>
                Container(
                  padding: const EdgeInsets.all(7),
                  color: r[0].isOdd ? Colors.grey[200] : Colors.grey[100],
                  child: WidgetRule(engine: engine, rule: r[1])
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                alignment: Alignment.center,
                child: Text('Questions', style: theme.textTheme.headline5,),
              ),
              ...
              enumerate(engine.klBase.questions).map((q) =>
                Container(
                  color: q[0].isOdd ? Colors.grey[200] : Colors.grey[100],
                  child: WidgetQuestion(engine: engine, question: q[1])
                ),
              )
            ]
          );
        },
      ),
    );
  }
}