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
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(endpoint.description, style: theme.textTheme.bodyText2),
        ),
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

Future<GoalDialogAction> showEndpointDialog(
  BuildContext context, List<KlEndpoint> endpoints, {GoalDialogAction def, bool showOne=true}) async {
  if (showOne)
    endpoints = endpoints.isEmpty ? [] : [endpoints.first];

  var routeResult = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      scrollable: false,
      content: Container(
        width: 700,
        child: Scrollbar(
          thickness: 4,
          child: ListView(
            shrinkWrap: true,
            children: endpoints.map(
              (e) => EndpointWidget(endpoint: e)).toList(),
          )
        )
      ),
      actions: <Widget> [
        FlatButton(
          child: Text('Previous'),
          onPressed: () =>
            // goes back a question
            Navigator.of(context).pop<GoalDialogAction>(GoalDialogAction.Previous)
        ),
        FlatButton(
          child: Text('Reset'),
          onPressed: () =>
            // resets the engine
            Navigator.of(context).pop<GoalDialogAction>(GoalDialogAction.Reset)
        )
      ],
    )
  );
  return (routeResult is GoalDialogAction) ? routeResult : def;
}

Future<GoalDialogAction> showEndpointRoute(
  BuildContext context, List<KlEndpoint> endpoints, {GoalDialogAction def}) async {
  var routeResult = await Navigator.of(context)
    .pushNamed('/endpoint', arguments: {'endpoints': endpoints});
  return (routeResult is GoalDialogAction) ? routeResult : def;
}

class RouteEndpoint extends StatelessWidget {
  final List<KlEndpoint> endpoints;
  const RouteEndpoint({@required this.endpoints});

  factory RouteEndpoint.fromSettings(Object settings) =>
    RouteEndpoint(endpoints: (settings as Map)['endpoints'] as List<KlEndpoint>);

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: ListView.builder(
            itemCount: endpoints.length,
            itemBuilder: (context, i) => EndpointWidget(
              endpoint: endpoints[i],
            )
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40.0, width: 100.0,
                child: FlatButton(
                  child: Text('Previous'),
                  color: theme.primaryColor,
                  onPressed: () =>
                    // goes back a question
                    Navigator.of(context).pop<GoalDialogAction>(GoalDialogAction.Previous)
                ),
              ),
              SizedBox(width: 10.0,),
              SizedBox(
                height: 40.0, width: 100.0,
                child: FlatButton(
                  child: Text('Reset'),
                  color: theme.primaryColor,
                  onPressed: () =>
                    // resets the engine
                    Navigator.of(context).pop<GoalDialogAction>(GoalDialogAction.Reset)
                ),
              )
            ],
          )
        ]
      )
    );
  }
}
