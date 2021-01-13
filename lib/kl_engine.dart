import 'dart:collection';

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
import 'package:groningen_guide/kl/kl_endpoint.dart';
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl/kl_question_option.dart';
import 'package:groningen_guide/kl/kl_rule.dart';
import 'package:groningen_guide/kl_parser.dart';
import 'package:groningen_guide/main.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

/// Stores a map that matches [String] elements to [TreeElement] objects.
/// It is used to retrieve the corresponding [TreeElement] objects and
/// acts similar to a cache.
class ExpressionStorage {
  final logger = Logger('ExpressionStorage');
  final storage = <String, TreeElement>{};

  /// Inserts a new expression into the map. It replaces the current
  /// expression if there is already one stored using this key.
  void insertExp(String exp) {
    try {
      var parsed = buildExpression(exp);
      storage[exp] = parsed;
    } catch (e) {
      logger.info('Could not parse expression $exp : ${e.toString()}');
      throw e;
    }
  }

  /// Finds the expression stored below this key
  TreeElement operator [](String elem) => storage[elem];

  /// Finds all expressions
  List<TreeElement> findExpressions(List<String> elements) =>
      elements.map<TreeElement>((e) => storage[e]).toList();

  /// Finds all variables stored in this knowledge base
  Set<String> findVariables() {
    var variables = <String>{};
    for (var tree in storage.values)
      variables
          .addAll(tree.findOfType(TokenType.IDENT).map((e) => e.values[0]));
    return variables;
  }

  /// Evaluates the expression stored at this key using the
  /// given [ContextModel]. Creates a new expression if the
  /// map does not already contain one.
  int evaluateExpression(String exp, ContextModel model) {
    if (!storage.containsKey(exp)) insertExp(exp);
    return storage[exp].evaluate(model);
  }

  /// Evaluates a given expression as a [bool] value
  bool evaluateExpressionAsBool(String exp, ContextModel model) =>
      evaluateExpression(exp, model) != 0;

  /// Loads all expressons sotred at the knowledge ase.
  ExpressionStorage(KlBase base, {bool aot=true}) {
    if (aot) {
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
      // generates the expressions for all endpoints
      for (var endpoint in base.endpoints) {
        endpoint.conditions.forEach((e) => insertExp(e));
      }
    }
  }

  /// Clears the list of stored entries
  void clear() {
    storage.clear();
  }

  /// Prints an info stream of all stored expressions
  void info() {
    logger.info('Variables: ${findVariables()}');
    storage
        .forEach((key, value) => logger.info('Expression: \'$key\' => $value'));
  }

  List<TreeElement> endpointConditions(KlEndpoint endpoint) =>
    endpoint.conditions.map((e) => storage[e]).toList();

  /// Returns the mapped list of [TreeElement] objects of rule conditions
  List<TreeElement> ruleConditions(KlRule rule) =>
      rule.conditions.map((e) => storage[e]).toList();

  /// Returns the mapped list of [TreeElement] objects of question conditions
  List<TreeElement> questionConditions(KlQuestion question) =>
      question.conditions.map((e) => storage[e]).toList();

  /// Returns the mapped list of [TreeElement] objects of rule events
  List<TreeElement> ruleEvents(KlRule rule) =>
      rule.events.map((e) => storage[e]).toList();

  /// Returns the mapped list of [TreeElement] objects of question option events
  List<TreeElement> questionOptionEvents(KlQuestionOption option) =>
      option.events.map((e) => storage[e]).toList();
}

/// Stores the the currently asked question as well as all
/// previous questions.
class QuestionData extends ChangeNotifier {
  /// The stack of previously asked questions;
  final List<Tuple3<KlQuestion, List<bool>, ContextModel>> previous = [];
  /// The order in which the questions were selected
  Queue<int> _selectionOrder = Queue();
  /// The currently asked question
  Tuple2<KlQuestion, List<bool>> _current;

  ContextModel loadPreviousQuestion() {
    var data = previous.last;
    _current = Tuple2(data.item1, List.generate(
      data.item1.options.length, (_) => false));
    previous.removeLast();
    notifyListeners();
    return data.item3;
  }

  /// Unloads the current question and puts it on the stack of
  /// previous asked questions.
  void unloadQuestion(ContextModel snapshot, {bool notify=true}) {
    if (_current != null) {
      previous.add(Tuple3<KlQuestion, List<bool>, ContextModel>(
        _current.item1, _current.item2, snapshot));
      _selectionOrder.clear();
      _current = null;
    }
    if (notify) notifyListeners();
  }

  /// Clears the stack of asked questions and the currently loaded question
  void clear() {
    previous.clear();
    _selectionOrder.clear();
    _current = null;
    notifyListeners();
  }

  /// Loads the given [question] and puts it on the
  void loadQuestion(KlQuestion question, ContextModel currentModel) {
    unloadQuestion(currentModel, notify: false);
    _current = Tuple2(question, List.generate(
      question.options.length, (_) => false));
    notifyListeners();
  }

  /// Checks if the question was already asked or is currently loaded
  bool containsQuestion(KlQuestion question) {
    var prev = previous.firstWhere(
      (element) => element.item1 == question,
      orElse: () => null) != null;
    return prev || _current?.item1 == question;
  }

  // ---- Options ---- //

  /// Gets the currently selected options
  List<KlQuestionOption> selectedOptions() {
    return enumerate(_current.item1.options)
      .where((e) => _current.item2[e.item1])
      .map<KlQuestionOption>((e) => e.item2)
      .toList();
  }

  /// Sets the answer option at the given [index] to [value]
  void setOption(int index, bool value) {
    if (current.item2[index] != value)
      changeOption(index);
  }

  /// Changes the answer option at the given [index]
  void changeOption(int index) {
    _current.item2[index] = !_current.item2[index];
    if (_current.item2[index]) {
      if (currentQuestion.options[index].exclusive) {
        _selectionOrder.clear();
        for (var i = 0; i < currentAnswers.length; i++)
          currentAnswers[i] = false;
        currentAnswers[index] = true;
      }

      // the item was newly selected
      _selectionOrder.add(index);
      if (_selectionOrder.length > _current.item1.maxAnswers) {
        _current.item2[_selectionOrder.first] = false;
        _selectionOrder.removeFirst();
      }
    } else {
      // the selection was removed
      _selectionOrder.remove(index);
    }
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

  bool get hasPrevious => previous.isNotEmpty;

  /// Returns the last asked question data, requires at least one previous question
  Tuple3<KlQuestion, List<bool>, ContextModel> get last => previous.last;
  /// Returns the last asked question, requires at least one previous question
  KlQuestion get lastQuestion => previous.last.item1;
  /// Returns the last given answers, requires at least one previous question
  List<bool> get lastAnswers => previous.last.item2;
  /// Returns the snapshot of the last question, requires at least one previous question
  ContextModel get lastSnapshot => previous.last.item3;

  void info() {
    for (var i = 0; i < previous.length; i++) {
      print('    Previous at $i');
      print('        Question ${previous[i].item1.name}');
      print('        Answers ${previous[i].item2}');
      print('        CM ${previous[i].item3}');
    }
  }

  @override
  String toString() => 'QuestionData[stack:${previous.length},current=${current!=null}]';

}

class DebuggerProvider extends ChangeNotifier {
  bool showDebugger;
  DebuggerProvider({this.showDebugger = false});

  void changeState() {
    showDebugger = !showDebugger;
    notifyListeners();
  }
}

class EngineSession extends StatefulWidget {
  final Widget child;
  const EngineSession({@required this.child, Key key}) : super(key: key);

  @override
  EngineSessionState createState() => EngineSessionState();
}

class EngineSessionState extends State<EngineSession> {
  final engine = KlEngine();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<KlEngine>(
          create: (context) => engine),
        ChangeNotifierProvider<KlBaseProvider>(
            create: (context) => engine.klBaseProvider),
        ChangeNotifierProvider<KlContextProvider>(
          create: (context) => engine.contextProvider),
        ChangeNotifierProvider<KlExpressionProvider>(
          create: (context) => engine.expressionProvider),
        ChangeNotifierProvider<DebuggerProvider>(
          create: (context) => DebuggerProvider())
      ],
      child: widget.child,
    );
  }
}

class KlBaseProvider extends ChangeNotifier {
  KlBase base;
  KlEngine parent;

  KlBaseProvider(this.base, this.parent);

  /// Upadtes the knowledge base by caling the update function
  void updateKnowledgeBase(void Function(KlBase) updater,
    {bool notifyParent = true}) {
    updater(base);
    notifyListeners();
    if (notifyParent) parent.notifyListeners();
  }
}

class KlContextProvider extends ChangeNotifier {
  ContextModel model;
  KlEngine parent;
  KlContextProvider(this.model, this.parent);

  void loadSnap(ContextModel newModel, {bool notifyParent = true}) {
    model = newModel;
    notifyListeners();
    if (notifyParent) parent.notifyListeners();
  }

  /// Updates the context model by calling the update function
  void updateContextModel(void Function(ContextModel) updater,
      {bool notifyParent = true}) {
    updater(model);
    notifyListeners();
    if (notifyParent) parent.notifyListeners();
  }
}

class KlExpressionProvider extends ChangeNotifier {
  ExpressionStorage storage;
  KlEngine parent;
  KlExpressionProvider(this.storage, this.parent);

  /// Updates the context model by calling the update function
  void updateContextModel(void Function(ExpressionStorage) updater,
      {bool notifyParent = true}) {
    updater(storage);
    notifyListeners();
    if (notifyParent) parent.notifyListeners();
  }
}

/// The main inference engine that stores a knowledge base [KlBase],
/// an [ExpressionStorage] and a [Contextmodel].
class KlEngine extends ChangeNotifier {
  KlBaseProvider klBaseProvider;
  KlExpressionProvider expressionProvider;
  KlContextProvider contextProvider;
  bool debug = true;
  final Logger logger = Logger('KlEngine');

  /// Creates a knowledge engine
  factory KlEngine.fromString(String string) =>
      KlEngine.empty()..loadFromString(string);

  /// Creates an empty knowledge engine where all members are null
  KlEngine.empty();

  /// Creates an empty knowledge base with default initialized members
  KlEngine() {
    klBaseProvider = KlBaseProvider(KlBase(), this);
    expressionProvider = KlExpressionProvider(
      ExpressionStorage(klBaseProvider.base), this);
    contextProvider = KlContextProvider(
      ContextModel(assumeFalse: true), this);
  }

  /// Loads a new knowledge base from a JSON encoded [String]
  void loadFromString(String string) {
    //try {
      // code that might throw
      var map = json.decode(string);
      var nklBase = KlBaseProvider(
        KlBase.fromJson(map), this);
      var nexpressionStorage = KlExpressionProvider(
        ExpressionStorage(nklBase.base), this);
      var ncontextModel = KlContextProvider(
        ContextModel(assumeFalse: true), this);
      ncontextModel.model.loadDefaultVars(
        nexpressionStorage.storage.findVariables());
      // assign new variables (cannot throw)
      klBaseProvider = nklBase;
      expressionProvider = nexpressionStorage;
      contextProvider = ncontextModel;
      // notifies listeners on the state change
      notifyAll();
    //} catch (e) {
    //  throw e;
    //}
  }

  void clear() {
    contextProvider.model.clear();
    contextProvider.model.loadDefaultVars(
      expressionProvider.storage.findVariables());
    notifyAll();
  }

  /// Updates the engine model by calling the update function
  void updateEngine(void Function(KlEngine) updater) {
    updater(this);
    notifyAll();
  }

  /// Evaluates a single condition
  bool evaluateCondition(String cond) => expressionProvider.storage
      .evaluateExpressionAsBool(cond, contextProvider.model);

  /// Evaluates a list of [conditions]. This function evaluates to [true]
  /// if all conditions evaluate to [true].
  bool evaluateConditionList(List<String> conditions) {
    for (var cond in conditions) {
      if (!expressionProvider.storage
          .evaluateExpressionAsBool(cond, contextProvider.model)) return false;
    }
    return true;
  }

  /// Evaluates a list of [events]. Events are evaluated in order
  bool evaluateEvents(List<String> events, {bool notifyOnChange = true}) {
    logger.info('Evaluating Events');
    var changed = false;
    for (var event in events) {
      logger.info('    $event');
      contextProvider.model.changed = false;
      expressionProvider.storage
          .evaluateExpression(event, contextProvider.model);
      changed |= contextProvider.model.changed;
    }
    if (changed && notifyOnChange) notifyAll();
    return changed;
  }

  /// Evaluates the conditions of a rule
  bool evaluateRule(KlRule rule) => evaluateConditionList(rule.conditions);
  /// Evaluates the conditions of a question
  bool evaluateQuestion(KlQuestion q) => evaluateConditionList(q.conditions);
  /// Evaluates the conditions of an endpoint
  bool evaluateEndpoint(KlEndpoint endpoint) => evaluateConditionList(endpoint.conditions);

  /// Runs the inference model by running through all rules and executing the
  /// event list of the rule conditions evaluate to [true].
  void inference() {
    var changed = true;
    for (var k = 0; changed; k++) {
      changed = false;
      logger.info('Evaluating Rules: Iteration $k');
      for (var i = 0; i < klBaseProvider.base.rules.length; i++) {
        var rule = klBaseProvider.base.rules[i];
        var result = evaluateConditionList(rule.conditions);
        logger.info('    $i: \'${rule.name}\' => $result');
        if (result) {
          changed |= evaluateEvents(rule.events);
        }
      }
    }
  }

  Iterable<KlEndpoint> checkEndpoints() sync* {
    for (var endpoint in klBaseProvider.base.endpoints) {
      var result = evaluateConditionList(endpoint.conditions);
      if (result) yield endpoint;
    }
  }

  void notifyAll() {
    notifyListeners();
    klBaseProvider.notifyListeners();
    expressionProvider.notifyListeners();
    contextProvider.notifyListeners();
  }

  /// Loads the next question to to the [QuestionData] object
  /// that is required to gain more information.
  List<KlQuestion> availableQuestions() {
    logger.info('Unloading current question');
    var questions = <KlQuestion>[];
    for (var i = 0; i < klBaseProvider.base.questions.length; i++) {
      var question = klBaseProvider.base.questions[i];
      // evaluates the question's conditions
      var conditions = evaluateQuestion(klBaseProvider.base.questions[i]);
      logger.info("Checking question ${question.name} conditions $conditions");
      if (!conditions) continue;

      questions.add(question);
    }
    return questions;
  }
}
