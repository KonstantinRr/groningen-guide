

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_engine.dart';
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
          ],
        )
    );
  }
}