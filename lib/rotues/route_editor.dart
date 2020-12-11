

import 'package:flutter/material.dart';
import 'package:groningen_guide/loader/custom_loader.dart';

class RouteEditor extends StatelessWidget {
  const RouteEditor({Key key}) : super(key: key);

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
      body: const CustomKnowledgeLoader(),
    );
  }
}
