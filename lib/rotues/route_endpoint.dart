/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_endpoint.dart';
import 'package:groningen_guide/widgets/widget_title.dart';
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
    return Column(
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
                return Container(
                  height: 250.0, width: 250.0,
                  alignment: Alignment.center,
                  child: Text('Error loading image ${endpoint.image}')
                );
              if (!snap.hasData)
                return Container(
                  width: 250.0, height: 250.0,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 55.0, height: 55.0,
                    child: CircularProgressIndicator(),
                  )
                );
              return Container(
                  height: 250.0, width: 250.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: snap.data
                    )
                  ),
                );
            },
          ))
      ],
    );
  }
}

enum GoalDialogAction {
  Reset, Previous
}

class EndpointDialog extends StatelessWidget {
  final List<KlEndpoint> endpoints;
  const EndpointDialog({this.endpoints, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 500, height: 300,
        child: ListView(
          children: endpoints.map((e) => EndpointWidget(endpoint: e)).toList(),
        )
      ),
      actions: [
        FlatButton(
          child: Text('Previous'),
          onPressed: () =>
            // goes back a question
            Navigator.of(context).pop(GoalDialogAction.Previous)
        ),
        FlatButton(
          child: Text('Reset'),
          onPressed: () =>
            // resets the engine
            Navigator.of(context).pop(GoalDialogAction.Reset)
        )
      ],
    );
  }
}

Future<GoalDialogAction> showEndpointDialog(BuildContext context, List<KlEndpoint> endpoints) {
  return showDialog<GoalDialogAction>(
    context: context,
    builder: (context) => EndpointDialog(endpoints: endpoints,)
  ) ?? GoalDialogAction.Reset;
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
          onPressed: () => Navigator.of(context).pop(GoalDialogAction.Previous)
        ),
      ),
      body: EndpointWidget(
        endpoint: endpoint,
      )
    );
  }
}
