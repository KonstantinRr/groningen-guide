import 'dart:convert';

/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:groningen_guide/kl/kl_base.dart';
import 'package:groningen_guide/kl_parser.dart';

class ExpressionStorage {
  final storage = <String, TreeElement> {};

  void insertExp(String exp) {
    try {
      var parsed = buildExpression(exp);
      storage[exp] = parsed;
    } catch(e) {
      print('Could not parse expression $exp : ${e.toString()}');
      throw e;
    }
  }

  ExpressionStorage(KlBase base) {
    // generates the expressions for all questions
    for (var q in base.questions) {
      q.conditions.forEach((e) => insertExp(e));
    }
    // generates the expressions for all rules
    for (var rule in base.rules) {
      rule.conditions.forEach((e) => insertExp(e));
    }
  }

  void info() {
    storage.forEach((key, value) => print('Expression: \'$key\' => $value'));
  }
}

class KlEngine {
  KlBase klBase;
  ExpressionStorage expressionStorage;

  KlEngine.fromString(String string) {
    var map = json.decode(string);
    klBase = KlBase.fromJson(map);
    expressionStorage = ExpressionStorage(klBase);
  }

  KlEngine(this.klBase) {
    expressionStorage = ExpressionStorage(klBase);
  }
}
