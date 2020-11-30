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
  final Widget Function(BuildContext) onErr;
  final Widget Function(BuildContext, KlEngine) onLoad;
  final String path;

  /// Creates a knowledge base builder with the given callbacks
  const KnowledgeBaseLoader({Key key,
    @required this.onErr, @required this.onLoad,
    this.path = 'assets/knowledge_base.json'}) : super(key: key);

  /// Loads a knowledge base from the given path
  Future<KlEngine> _loadKlBase(String path) async {
    var string = await rootBundle.loadString(path);
    var engine = KlEngine.fromString(string);
    engine.expressionStorage.info();
    return engine;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<KlEngine>(
      future: _loadKlBase(path),
      builder: (context, snap) {
        if (snap.hasData)
          return ChangeNotifierProvider<KlEngine>(
            create: (context) => snap.data,
            child: onLoad(context, snap.data)
          );
        return onErr(context);
      },
    );
  }
}