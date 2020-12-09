/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_base.dart';
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl/kl_question_option.dart';
import 'package:groningen_guide/kl/kl_rule.dart';
import 'package:groningen_guide/kl_parser.dart';
import 'package:groningen_guide/widgets/widget_debugger.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

/// Stores a map that matches [String] elements to [TreeElement] objects.
/// It is used to retrieve the corresponding [TreeElement] objects and
/// acts similar to a cache.
class ExpressionStorage {
  final logger = Logger('ExpressionStorage');
  final storage = <String, TreeElement> { };

  /// Inserts a new expression into the map. It replaces the current
  /// expression if there is already one stored using this key.
  void insertExp(String exp) {
    try {
      var parsed = buildExpression(exp);
      storage[exp] = parsed;
    } catch(e) {
      logger.info('Could not parse expression $exp : ${e.toString()}');
      throw e;
    }
  }

  /// Finds the expression stored below this key
  TreeElement operator[](String elem) => storage[elem];

  /// Finds all expressions
  List<TreeElement> findExpressions(List<String> elements) =>
    elements.map<TreeElement>((e) => storage[e]).toList();

  /// Finds all variables stored in this knowledge base
  Set<String> findVariables() {
    var variables = <String> {};
    for (var tree in storage.values)
      variables.addAll(
        tree.findOfType(TokenType.IDENT).map((e) => e.values[0]));
    return variables;
  }

  /// Evaluates the expression stored at this key using the
  /// given [ContextModel]. Creates a new expression if the
  /// map does not already contain one.
  int evaluateExpression(String exp, ContextModel model) {
    if (!storage.containsKey(exp))
      insertExp(exp);
    return storage[exp].evaluate(model);
  }

  /// Evaluates a given expression as a [bool] value
  bool evaluateExpressionAsBool(String exp, ContextModel model)
    => evaluateExpression(exp, model) != 0;

  /// Loads all expressons sotred at the knowledge ase.
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

  /// Clears the list of stored entries
  void clear() {
    storage.clear();
  }

  /// Prints an info stream of all stored expressions
  void info() {
    logger.info('Variables: ${findVariables()}');
    storage.forEach((key, value) => logger.info('Expression: \'$key\' => $value'));
  }
}

/// Stores the the currently asked question as well as all
/// previous questions.
class QuestionData extends ChangeNotifier {
  final List<Tuple2<KlQuestion, List<bool>>> previous = [];
  Tuple2<KlQuestion, List<bool>> _current;
  
  /// Unloads the current question and puts it on the stack of
  /// previous asked questions.
  void unloadQuestion() {
    if (_current != null)
      previous.add(_current);
    _current = null;
    notifyListeners();
  }

  /// Loads the current [question] and puts it on the 
  void loadQuestion(KlQuestion question) {
    if (_current != null)
      previous.add(_current);
    _current = Tuple2(question, List.generate(
      question.options.length, (_) => false));
    notifyListeners();
  }

  /// Checks if the question was already asked or is currently loaded
  bool containsQuestion(KlQuestion question) {
    var prev = previous.firstWhere((element) => element.item1 == question,
      orElse: () => null) != null;
    return prev || _current?.item1 == question;
  }

  // ---- Options ---- //

  /// Gets the currently selected options 
  List<KlQuestionOption> selectedOptions() {
    return enumerate(_current.item1.options)
      .where((e) => _current.item2[e[0]])
      .map<KlQuestionOption>((e) => e[1])
      .toList();
  }

  /// Sets the answer option at the given [index] to [value]
  void setOption(int index, bool value) {
    _current.item2[index] = value;
    notifyListeners();
  }

  /// Changes the answer option at the given [index]
  void changeOption(int index) {
    _current.item2[index] = !_current.item2[index];
    notifyListeners();
  }

  /// Returns whether there is currently a question loaded
  bool get hasQuestion => _current != null;
  /// Returns the current question as well as the answers
  Tuple2<KlQuestion, List<bool>> get current => _current;
  /// Returns the currently loaded question
  KlQuestion get currentQuestion => _current?.item1;
  /// Returns the currently loaded answers
  List<bool> get currentAnswers => _current?.item2;
}

class EngineSession extends StatelessWidget {
  final Widget child;
  const EngineSession({@required this.child, Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<KlEngine>(
      create: (context) => KlEngine(),
      child: child,
    );
  }
}

/// The main inference engine that stores a knowledge base [KlBase],
/// an [ExpressionStorage] and a [Contextmodel].
class KlEngine extends ChangeNotifier {
  KlBase klBase;
  ExpressionStorage expressionStorage;
  ContextModel contextModel;
  bool debug = true;
  final Logger logger = Logger('KlEngine');

  /// Creates a knowledge engine
  factory KlEngine.fromString(String string) 
    => KlEngine.empty()..loadFromString(string);

  /// Creates an empty knowledge engine where all members are null
  KlEngine.empty();
  /// Creates an empty knowledge base with default initialized members
  KlEngine() {
    klBase = KlBase(values: [], questions: [], rules: []);
    expressionStorage = ExpressionStorage(klBase);
    contextModel = ContextModel(assumeFalse: true);
  }

  /// Loads a new knowledge base from a JSON encoded [String]
  void loadFromString(String string) {
    try {
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
    } catch(e) {
      throw e;
    }
  }

  /// Updates the engine model by calling the update function
  void updateEngine(void Function(KlEngine) updater) {
    updater(this);
    notifyListeners();
  }
  /// Updates the context model by calling the update function
  void updateContextModel(void Function(ContextModel) updater) {
    updater(contextModel);
    notifyListeners();
  }
  /// Upadtes the knowledge base by caling the update function
  void updateKnowledgeBase(void Function(KlBase) updater) {
    updater(klBase);
    notifyListeners();
  }

  /// Evaluates a single condition
  bool evaluateCondition(String cond) =>
    expressionStorage.evaluateExpressionAsBool(cond, contextModel);

  /// Evaluates a list of [conditions]. This function evaluates to [true]
  /// if all conditions evaluate to [true].
  bool evaluateConditionList(List<String> conditions) {
    for (var cond in conditions) {
      if (!expressionStorage.evaluateExpressionAsBool(cond, contextModel))
        return false;
    }
    return true;
  }

  /// Evaluates a list of [events]. Events are evaluated in order
  void evaluateEvents(List<String> events) {
    logger.info('Evaluating Events');
    for (var event in events) {
      logger.info('    $event');
      expressionStorage.evaluateExpression(event, contextModel);
    }
    notifyListeners();
  }

  /// Evaluates the conditions of a rule
  bool evaluateRule(KlRule rule) => evaluateConditionList(rule.conditions);
  /// Evaluates the conditions of a question
  bool evaluateQuestion(KlQuestion q) => evaluateConditionList(q.conditions);

  /// Returns the mapped list of [TreeElement] objects of rule conditions
  List<TreeElement> ruleConditions(KlRule rule)
    => rule.conditions.map((e) => expressionStorage[e]).toList();
  /// Returns the mapped list of [TreeElement] objects of question conditions
  List<TreeElement> questionConditions(KlQuestion question)
    => question.conditions.map((e) => expressionStorage[e]).toList();

  /// Returns the mapped list of [TreeElement] objects of rule events
  List<TreeElement> ruleEvents(KlRule rule)
    => rule.events.map((e) => expressionStorage[e]).toList();
  /// Returns the mapped list of [TreeElement] objects of question option events
  List<TreeElement> questionOptionEvents(KlQuestionOption option)
    => option.events.map((e) => expressionStorage[e]).toList();

  /// Runs the inference model by running through all rules and executing the
  /// event list of the rule conditions evaluate to [true].
  void inference() {
    var change = true;
    for (var k = 0; change; k++) {
      logger.info('Evaluating Rules: Iteration $k');
      change = false;
      for (var i = 0; i < klBase.rules.length; i++) {
        var rule = klBase.rules[i];
        var result = evaluateConditionList(rule.conditions);
        logger.info('    $i: \'${rule.name}\' => $result');
        if (result) {
          change = true;
          evaluateEvents(rule.events);
        }
      }
    }
  }

  /// Loads the next question to to the [QuestionData] object
  /// that is required to gain more information.
  void loadNextQuestion(QuestionData questionData) {
    logger.info('Unloading current question');
    questionData.unloadQuestion();
    for (var i = 0; i < klBase.questions.length; i++) {
      if (!questionData.containsQuestion(klBase.questions[i])) {
        logger.info('Loading Question ${klBase.questions[i]}');
        questionData.loadQuestion(klBase.questions[i]);
        break;
      }
    }
    notifyListeners();
  }
}
