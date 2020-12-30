/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

/// This [Widget] is used to build a child [Widget] if and only if
/// the given minimum size requirements are fullfilled. It builds the
/// the [minBuilder] otherwise. The class specifies a default implementation
/// of [minBuilder] if no one is specified.
/// Specifying [minWidth] or [minHeight] disables the size requirement.
/// 
class WidgetSizeRequirement extends StatelessWidget {
  /// The minimum size requirements that are need to call [builder].
  final double minWidth, minHeight;
  /// The default child builder if no constraints are violated
  final Widget Function(BuildContext, BoxConstraints) builder;
  /// The builder if the constraints are violated
  final Widget Function(BuildContext, BoxConstraints) minBuilder;

  WidgetSizeRequirement({Key key,
    Widget Function(BuildContext, BoxConstraints) minBuilder,
    this.minWidth, this.minHeight, @required this.builder
  }) :
    minBuilder = minBuilder ?? ((ctx, cstr)
      => _buildMin(ctx, cstr, minWidth, minHeight)),
    super(key: key);

  /// The default builder when the size constraints are violated
  static Widget _buildMin(
    BuildContext context, BoxConstraints constraints,
    double minWidth, double minHeight) {
    var bFont = TextStyle(fontWeight: FontWeight.bold);
    var theme = Theme.of(context);
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
        (minWidth == null || constraints.maxWidth >= minWidth) &&
          (minHeight == null || constraints.maxHeight >= minHeight)
          ? builder(context, constraints)
          : minBuilder(context, constraints)
    );
  }
}
