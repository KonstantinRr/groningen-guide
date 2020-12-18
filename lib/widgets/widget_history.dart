

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/main.dart';
import 'package:provider/provider.dart';

class WidgetHistory extends StatelessWidget {
  const WidgetHistory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Consumer<QuestionData>(
      builder: (context, questionData, _) =>
        Column(
          children: [
            Text('History', style: theme.textTheme.headline6,),
            ...
            enumerate(questionData.previous).map((tup) => Container(
              padding: const EdgeInsets.all(7),
              color: tup.item1.isOdd ? Colors.grey[200] : Colors.grey[100],
              child: Text(tup.item2.item1.name),
            ))
          ],
        )
    );
  }
}