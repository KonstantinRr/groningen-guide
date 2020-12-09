import 'dart:convert';

/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:provider/provider.dart';


class CustomKnowledgeLoader extends StatefulWidget {
  const CustomKnowledgeLoader({Key key}) : super(key: key);

  @override
  CustomKnowledgeLoaderState createState() => CustomKnowledgeLoaderState();
}

class CustomKnowledgeLoaderState extends State<CustomKnowledgeLoader> {
  final controller = TextEditingController();
  final scroll = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    var provider = Provider.of<KlEngine>(context);
    var prettyprint = encoder.convert(provider.klBase.toJson());
    controller.text = prettyprint;
  }

  void _load() {
    var prov = Provider.of<KlEngine>(context, listen: false);
    prov.loadFromString(controller.text);
  }

  void _verify() {

  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          Expanded(child: Scrollbar(
            isAlwaysShown: true,
            thickness: 8.0,
            controller: scroll,
            child: Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(20.0),
              color: Colors.grey[100],
              child: TextField(
                scrollController: scroll,
                maxLines: null, minLines: null,
                controller: controller,
                decoration: InputDecoration.collapsed(
                  hintText: 'Knowledge Base'
                ),
                expands: true,
              ),
            ),
          )),
          Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                RaisedButton(
                  child: Text('Load', style: theme.textTheme.button),
                  onPressed: _load,
                ),
                const SizedBox(width: 10.0,),
                RaisedButton(
                  child: Text('Verify', style: theme.textTheme.button),
                  onPressed: _verify,
                )
              ]
            ),
          ),
        ]
      )
    );
  }
}