/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_endpoint.dart';
import 'package:groningen_guide/widgets/widget_db_conditionlist.dart';
import 'package:groningen_guide/widgets/widget_db_description.dart';
import 'package:groningen_guide/widgets/widget_db_name.dart';

class WidgetEndpoint extends StatelessWidget {
  final KlEndpoint endpoint;
  const WidgetEndpoint({Key key, @required this.endpoint}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WidgetObjectName(name: endpoint.name),
        WidgetObjectDescription(description: endpoint.description),
        WidgetConditionList(
          eventCallback: (prov) => prov.storage.endpointConditions(endpoint),
          evaluatorCallback: (engine) => engine.evaluateEndpoint(endpoint)
        ),
      ]
    );
  }
}
