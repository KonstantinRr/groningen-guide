

import 'package:flutter/material.dart';
import 'package:groningen_guide/widgets/widget_history.dart';

class RouteHistory extends StatelessWidget {
  const RouteHistory({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetHistory(),
    );
  }
}