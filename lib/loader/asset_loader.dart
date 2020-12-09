/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

/// Loads a knowledge base from an application asset file
class KnowledgeBaseLoader extends StatelessWidget {
  final Widget Function(BuildContext) onLoad;
  final Widget Function(BuildContext, dynamic) onErr;
  final Widget Function(BuildContext) onDone;
  final String path;

  /// Creates a knowledge base builder with the given callbacks
  const KnowledgeBaseLoader({Key key,
    @required this.onLoad,
    @required this.onErr,
    @required this.onDone,
    this.path = 'assets/knowledge_base.json'}) : super(key: key);

  /// Loads a knowledge base from the given path
  Future<bool> _loadKlBase(BuildContext context, String path) async {
    var engine = Provider.of<KlEngine>(context, listen: false);
    var string = await rootBundle.loadString(path);
    engine.loadFromString(string);
    engine.expressionProvider.storage.info();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loadKlBase(context, path),
      builder: (context, snap) {
        if (snap.hasError)
          return onErr(context, snap.error);
        if (snap.hasData)
          return onDone(context);
        return onLoad(context);
      },
    );
  }
}