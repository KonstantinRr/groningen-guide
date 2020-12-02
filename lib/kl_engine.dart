/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:groningen_guide/kl/kl_base.dart';
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl/kl_question_option.dart';
import 'package:groningen_guide/kl/kl_rule.dart';
import 'package:groningen_guide/kl_parser.dart';
import 'package:groningen_guide/widgets/widget_vars.dart';
import 'package:tuple/tuple.dart';

class ExpressionStorage {
  final storage = <String, TreeElement> { };

  void insertExp(String exp) {
    try {
      var parsed = buildExpression(exp);
      storage[exp] = parsed;
    } catch(e) {
      print('Could not parse expression $exp : ${e.toString()}');
      throw e;
    }
  }

  TreeElement operator[](String elem) => storage[elem];

  List<TreeElement> findExpressions(List<String> elements) =>
    elements.map<TreeElement>((e) => storage[e]).toList();

  Set<String> findVariables() {
    var variables = <String> {};
    for (var tree in storage.values) {
      variables.addAll(
        tree.findOfType(TokenType.IDENT).map((e) => e.values[0])
      );
    }
    return variables;
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
      q.options.forEach((option) {
        option.events.forEach((event) => insertExp(event));
      });
    }
    // generates the expressions for all rules
    for (var rule in base.rules) {
      rule.conditions.forEach((e) => insertExp(e));
      rule.events.forEach((event) => insertExp(event));
    }
  }

  void info() {
    print('Variables: ${findVariables()}');
    storage.forEach((key, value) => print('Expression: \'$key\' => $value'));
  }
}

class QuestionData extends ChangeNotifier {
  final List<Tuple2<KlQuestion, List<bool>>> previous = [];
  Tuple2<KlQuestion, List<bool>> _current;
  
  void unloadQuestion() {
    if (_current != null)
      previous.add(_current);
    _current = null;
    notifyListeners();
  }

  void loadQuestion(KlQuestion question) {
    if (_current != null)
      previous.add(_current);
    _current = Tuple2(question, List.generate(
      question.options.length, (_) => false));
    notifyListeners();
  }

  bool containsQuestion(KlQuestion question) {
    return previous.firstWhere((element) => element.item1 == question,
      orElse: () => null) != null;
  }

  List<KlQuestionOption> selectedOptions() {
    return enumerate(_current.item1.options)
      .where((e) => _current.item2[e[0]])
      .map<KlQuestionOption>((e) => e[1])
      .toList();
  }

  void setOption(int index, bool value) {
    _current.item2[index] = value;
    notifyListeners();
  }

  void changeOption(int index) {
    _current.item2[index] = !_current.item2[index];
    notifyListeners();
  }

  bool get hasQuestion => _current != null;
  Tuple2<KlQuestion, List<bool>> get current => _current;
  KlQuestion get currentQuestion => _current.item1;
  List<bool> get currentAnswers => _current.item2;
}

class KlEngine extends ChangeNotifier {
  KlBase klBase;
  ExpressionStorage expressionStorage;
  ContextModel contextModel;
  bool debug = true;

  factory KlEngine.fromString(String string) 
    => KlEngine.empty()..loadFromString(string);

  KlEngine.empty();
  KlEngine() {
    klBase = KlBase(values: [], questions: [], rules: []);
    expressionStorage = ExpressionStorage(klBase);
    contextModel = ContextModel(assumeFalse: true);
  }

  void loadFromString(String string) {
    //try {
      // code that might throw
      var map = json.decode(string);
      var nklBase = KlBase.fromJson(map);
      var nexpressionStorage = ExpressionStorage(nklBase);
      var ncontextModel = ContextModel(assumeFalse: true);
      ncontextModel.loadDefaultVars(nexpressionStorage.findVariables());
      // assign new variables (cannot throw)
      klBase = nklBase;
      expressionStorage = nexpressionStorage;
      contextModel = ncontextModel;
      // notifies listeners on the state change
      notifyListeners();
    //} catch(e) {
    //  throw e;
    //}
  }

  void updateEngine(void Function(KlEngine) updater) {
    updater(this);
    notifyListeners();
  }

  void updateContextModel(void Function(ContextModel) updater) {
    updater(contextModel);
    notifyListeners();
  }
  void updateKnowledgeBase(void Function(KlBase) updater) {
    updater(klBase);
    notifyListeners();
  }

  bool evaluateConditionList(List<String> conditions) {
    for (var cond in conditions) {
      if (!expressionStorage.evaluateExpressionAsBool(cond, contextModel))
        return false;
    }
    return true;
  }

  void evaluateEvents(List<String> events) {
    print('Evaluating Events');
    for (var event in events) {
      print('    $event');
      expressionStorage.evaluateExpression(event, contextModel);
    }
    notifyListeners();
  }

  bool evaluateCondition(String cond) =>
    expressionStorage.evaluateExpressionAsBool(cond, contextModel);
  bool evaluateRule(KlRule rule) => evaluateConditionList(rule.conditions);
  bool evaluateQuestion(KlQuestion q) => evaluateConditionList(q.conditions);

  List<TreeElement> ruleConditions(KlRule rule)
    => rule.conditions.map((e) => expressionStorage[e]).toList();
  List<TreeElement> questionConditions(KlQuestion question)
    => question.conditions.map((e) => expressionStorage[e]).toList();

  void inference() {
    print('Evaluating Rules');
    for (var i = 0; i < klBase.rules.length; i++) {
      var rule = klBase.rules[i];
      var result = evaluateConditionList(rule.conditions);
      print('    $i: \'${rule.name}\' => $result');
      if (result) {
        evaluateEvents(rule.events);
      }
    }
  }

  void loadNextQuestion(QuestionData questionData) {
    print('Unloading current question');
    questionData.unloadQuestion();
    for (var i = 0; i < klBase.questions.length; i++) {
      if (!questionData.containsQuestion(klBase.questions[i])) {
        print('Loading Question ${klBase.questions[i]}');
        questionData.loadQuestion(klBase.questions[i]);
        break;
      }
    }
    notifyListeners();
  }
}
