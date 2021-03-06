/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

/// The title [Widget] that is build as part of the [AppBar].
class WidgetTitle extends StatelessWidget {
  const WidgetTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Angel\'s Groningen Guide');
  }
}