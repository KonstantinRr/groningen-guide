/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

class WidgetLogo extends StatelessWidget {
  final double size;
  final EdgeInsets margin;
  const WidgetLogo({@required this.size,
    this.margin, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: const BoxDecoration(
        image: const DecorationImage(
          fit: BoxFit.contain,
          image: const AssetImage('assets/images/logo.png')
        )
      ),
    );
  }
}
