/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

class RouteUnknwon extends StatelessWidget {
  const RouteUnknwon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var name = ModalRoute.of(context).settings.name;
    return Scaffold(
      body: Center(
        child: Text('Error 404: Could not find route $name'),
      ),
    );
  }
}
