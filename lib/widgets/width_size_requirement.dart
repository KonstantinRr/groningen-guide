/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

class WidgetSizeRequirement extends StatelessWidget {
  final double minWidth, minHeight;
  final Widget Function(BuildContext, BoxConstraints) builder;
  
  const WidgetSizeRequirement({Key key,
    this.minWidth, this.minHeight, @required this.builder});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var bFont = TextStyle(fontWeight: FontWeight.bold);

    return LayoutBuilder(
      builder: (context, constraints) {
        if ((minWidth == null || constraints.maxWidth >= minWidth) &&
          (minHeight == null || constraints.maxHeight >= minHeight))
          return builder(context, constraints);
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text('Please Scale your window to at least $minWidth, $minHeight in size!',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyText1,),
              const SizedBox(height: 7.0),

              RichText(
                text: TextSpan(
                  text: 'Width: ',
                  style: theme.textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: '${constraints.maxWidth}', style: bFont),
                    TextSpan(text: ' of '),
                    TextSpan(text: '$minWidth', style: bFont)
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Height: ',
                  style: theme.textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: '${constraints.maxHeight}', style: bFont),
                    TextSpan(text: ' of '),
                    TextSpan(text: '$minHeight', style: bFont)
                  ],
                ),
              ),
            ]
          ),
        );
      }
    );
  }
}
