import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_endpoint.dart';

class EndpointWidget extends StatelessWidget {
  final KlEndpoint endpoint;
  const EndpointWidget({@required this.endpoint});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListView(
      children: [
        Text(
          endpoint.name,
          style: theme.textTheme.headline6,
        ),
        Text(endpoint.description, style: theme.textTheme.bodyText2)
      ],
    );
  }
}

Future<void> showEndpointDialog(BuildContext context, KlEndpoint endpoint) {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
          child: Container(
              width: 300,
              height: 300,
              child: EndpointWidget(
                endpoint: endpoint,
              ))));
}

class RouteEndpoint extends StatelessWidget {
  final KlEndpoint endpoint;
  const RouteEndpoint({this.endpoint});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        body: EndpointWidget(
      endpoint: endpoint,
    ));
  }
}
