/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'dart:convert';

import 'package:flutter/foundation.dart';
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

  int evaluateExpression(String exp, ContextModel model) {
    if (!storage.containsKey(exp))
      insertExp(exp);

    return storage[exp].evaluate(model);
  }
  bool evaluateExpressionAsBool(String exp, ContextModel model)
    => evaluateExpression(exp, model) != 0;

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

class KlEngine extends ChangeNotifier {
  KlBase klBase;
  ExpressionStorage expressionStorage;
  ContextModel contextModel;

  factory KlEngine.fromString(String string) {
    var map = json.decode(string);
    return KlEngine(KlBase.fromJson(map));
  }

  KlEngine(this.klBase) {
    expressionStorage = ExpressionStorage(klBase);
    contextModel = ContextModel(assumeFalse: true);
  }

  bool evaluateConditionList(List<String> conditions) {
    for (var cond in conditions) {
      if (!expressionStorage.evaluateExpressionAsBool(cond, contextModel))
        return false;
    }
    return true;
  }

  void inference() {
    for (var rule in klBase.rules) {
      var result = evaluateConditionList(rule.conditions);
      print('Evaluating Rule \'${rule.name}\' => $result');
    }
    notifyListeners();
  }
}
