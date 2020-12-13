/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:provider/provider.dart';

class ActionInspector extends StatelessWidget {
  const ActionInspector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Consumer<DebuggerProvider>(
      builder: (context, prov, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Inspector', style: theme.textTheme.headline6),
            const SizedBox(width: 5,),
            Checkbox(
              value: prov.showDebugger,
              onChanged: (val) => prov.changeState()
            )
          ]
        ),
      )
    );
  }
}