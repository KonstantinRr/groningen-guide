/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/widgets/widget_title.dart';
import 'package:groningen_guide/widgets/width_size_requirement.dart';

class RouteUnknown extends StatelessWidget {
  const RouteUnknown({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var name = ModalRoute.of(context).settings.name;

    return WidgetSizeRequirement(
      minHeight: 210.0,
      minWidth: 270.0,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.color,
          title: const WidgetTitle(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.accentColor,),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Text('Error 404: Could not find route $name', style: theme.textTheme.bodyText1,),
        ),
      ),
    );
  }
}
