/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/model_actions.dart';
import 'package:groningen_guide/rotues/route_endpoint.dart';
import 'package:groningen_guide/widgets/widget_title.dart';
import 'package:groningen_guide/widgets/width_size_requirement.dart';

class WidgetEnd extends StatelessWidget {
  const WidgetEnd({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Sorry!', style: theme.textTheme.headline5),
        ),
        Text('We could not reach any conclusion with the given answers',
          style: theme.textTheme.bodyText2),
      ]
    );
  }
}

class RouteEnd extends StatelessWidget {
  final bool showExitDialog;
  const RouteEnd({Key key, this.showExitDialog=true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetSizeRequirement(
      minHeight: 210.0,
      minWidth: 270.0,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.color,
          title: const WidgetTitle(),
        ),
        body: Center(child: Column(
          children: <Widget> [
            const WidgetEnd(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100.0,
                    height: 30.0,
                    child: RaisedButton(
                      child: Text('Previous'),
                      onPressed: () {
                        Navigator.of(context).pop(GoalDialogAction.Previous);
                      }
                    ),
                  ),
                  const SizedBox(width: 10.0,),
                  SizedBox(
                    width: 100.0,
                    height: 30.0,
                    child: RaisedButton(
                      child: Text('Reset'),
                      onPressed: () {
                        Navigator.of(context).pop(GoalDialogAction.Reset);
                      }
                    )
                  )
                ],
              )
            )
          ]
        ))
      ),
    );
  }
}