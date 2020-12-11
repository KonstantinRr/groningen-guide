/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_endpoint.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:provider/provider.dart';

class EndpointWidget extends StatelessWidget {
  final KlEndpoint endpoint;
  const EndpointWidget({@required this.endpoint});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListView(
      children: [
        Container(
          height: 50.0,
          alignment: Alignment.center,
          child: Text(
            endpoint.name,
            style: theme.textTheme.headline6,
          ),
        ),
        Text(endpoint.description, style: theme.textTheme.bodyText2)
      ],
    );
  }
}

class EndpointDialog extends StatelessWidget {
  final KlEndpoint endpoint;
  const EndpointDialog({this.endpoint, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      child: Container(
        width: 300, height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            Expanded(child: EndpointWidget(
              endpoint: endpoint,
            )),
            Row(
              children: <Widget> [
                FlatButton(
                  child: Text('Exit', style: theme.textTheme.button,),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  child: Text('Reset', style: theme.textTheme.button),
                  onPressed: () {
                    // resets the engine
                    Provider.of<QuestionData>(context, listen: false).clear();
                    Provider.of<KlEngine>(context, listen: false).clear();
                    Navigator.of(context).pop(true);
                  }
                )
              ]
            )
          ]
        )
      ),
    );
  }
}

Future<void> showEndpointDialog(BuildContext context, KlEndpoint endpoint) {
  return showDialog(
    context: context,
    builder: (context) => EndpointDialog(endpoint: endpoint,)
  );
}

class RouteEndpoint extends StatelessWidget {
  final KlEndpoint endpoint;
  const RouteEndpoint({@required this.endpoint});

  factory RouteEndpoint.fromSettings(Object settings) =>
    RouteEndpoint(endpoint: (settings as Map)['data'] as KlEndpoint);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.color,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () => Navigator.of(context).pop()
        ),
      ),
      body: EndpointWidget(
        endpoint: endpoint,
      )
    );
  }
}
