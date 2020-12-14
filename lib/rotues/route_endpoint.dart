/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_endpoint.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/widgets/widget_title.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<ImageProvider> loadImageFromAsset(String image) async {
  if (image.startsWith('http://') || image.startsWith('https://'))
    return NetworkImage(image);

  // load as asset
  try {
    var bytes = await rootBundle.load(image);
    return MemoryImage(bytes.buffer.asUint8List());
  } catch (_) {
    print('Could not load bytes');
    rethrow;
  }
}

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
          child: Text(endpoint.name, style: theme.textTheme.headline6),
        ),
        Text(endpoint.description, style: theme.textTheme.bodyText2),
        if (endpoint.image != null)
          Center(child: FutureBuilder<ImageProvider>(
            future: loadImageFromAsset(endpoint.image),
            builder: (context, snap) {
              if (snap.hasError)
                return Text('Error loading image ${endpoint.image}');
              if (snap.hasData)
                return Container(
                  height: 250.0, width: 250.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: snap.data
                    )
                  ),
                );
              return Container(
                width: 100.0, height: 100.0,
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              );
            },
          ))
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
    return AlertDialog(
      title: Container(
        width: 500, height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            Expanded(child: EndpointWidget(
              endpoint: endpoint,
            )),
          ]
        )
      ),
      actions: [
        //FlatButton(
        //  child: Text('Exit', style: theme.textTheme.button,),
        //  onPressed: () {
        //    Navigator.of(context).pop(true);
        //  },
        //),
        FlatButton(
          child: Text('Reset'),
          onPressed: () {
            // resets the engine
            Provider.of<QuestionData>(context, listen: false).clear();
            Provider.of<KlEngine>(context, listen: false).clear();
            Navigator.of(context).pop(true);
          }
        )
      ],
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
        title: const WidgetTitle(),
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
