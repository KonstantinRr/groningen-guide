/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/main.dart';

class WidgetVariables extends StatefulWidget {
  const WidgetVariables({Key key}) : super(key: key);

  WidgetVariablesState createState() => WidgetVariablesState();
}

class WidgetVariablesState extends State<WidgetVariables> {
  bool showFalse = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Consumer<KlContextProvider>(
      builder: (context, contextProvider, _) {
        var trueFacts = contextProvider.model.countTrueFacts();
        var totalFacts = contextProvider.model.model.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 5),
              alignment: Alignment.center,
              child: Text('Variables', style: theme.textTheme.headline5),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text('Loaded $trueFacts of $totalFacts totalFacts'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                children: <Widget> [
                  Checkbox(
                    value: !showFalse,
                    onChanged: (changed) => setState(() => showFalse = !showFalse),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Hide false variables'),
                    ),
                  )
                ]
              ),
            ),
            Column(
              children: enumerate(contextProvider.model.entries)
                .where((e) => showFalse || e.item2.value != 0)
                .map((e) => Container(
                  padding: const EdgeInsets.all(7),
                  color: e.item1.isOdd
                    ? Colors.grey[200]
                    : Colors.grey[100],
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: e.item2.value != 0,
                        onChanged: (val) => contextProvider
                          .updateContextModel((model) => model
                            .setVar(e.item2.key, val ? 1 : 0)),
                      ),
                      Expanded(child: Container(
                        height: 40.0,
                        alignment: Alignment.center,
                        child: Text(e.item2.key),
                      ))
                    ],
                  ),
                )).toList(),
            ),
          ]
        );
      }
    );
  }
}
