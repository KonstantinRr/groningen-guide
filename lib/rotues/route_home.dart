/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_parser.dart';
import 'package:groningen_guide/rotues/route_endpoint.dart';
import 'package:groningen_guide/widgets/action_info.dart';
import 'package:groningen_guide/widgets/action_inspector.dart';
import 'package:groningen_guide/widgets/widget_title.dart';
import 'package:groningen_guide/widgets/width_size_requirement.dart';
import 'package:provider/provider.dart';

import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/loader/asset_loader.dart';
import 'package:groningen_guide/widgets/widget_question.dart';
import 'package:groningen_guide/widgets/widget_debugger.dart';

/// The main screen of the [RouteHome]
class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  Future<void> _next(BuildContext context, QuestionData questionData) async {
    // finds the engine provider in the widget tree
    var engine = Provider.of<KlEngine>(context, listen: false);
    // creates a snapshot from the current context model
    var snapshot = engine.contextProvider.model.snapshot();

    // evaluates all events that were selected
    for (var i in questionData.selectedOptions())
      engine.evaluateEvents(i.events);

    // unloads the question and stores the context model snapshot
    questionData.unloadQuestion(snapshot);

    // inferes additional variables
    engine.inference();
    // checks if any goals have been reached
    var endpoint = engine.checkEndpoints();

    if (endpoint != null) {
      // we reached an endpoint and want to show the dialog
      var result = await showEndpointDialog(context, endpoint);
      switch (result) {
        case GoalDialogAction.Previous:
          _previous(context, questionData); // TODO side effects
          break;
        case GoalDialogAction.Reset:
          _reset(context, questionData);
          break;
      }
    } else {
      // we have to ask a new question and check which are available
      var questions = engine.availableQuestions();
      // evaluates which questions were already asked
      var available = questions.where((question) {
        return !questionData.containsQuestion(question);
      }).toList();

      if (available.isEmpty) {
        // we don't have any new question to ask, jump to the general conclusion
        Navigator.of(context).pushNamed('/end');
      } else {
        // loads the first question that is available
        questionData.loadQuestion(
          available.first, engine.contextProvider.model);
      }
    }
  }

  /// Loads the previous question
  void _previous(BuildContext context, QuestionData questionData) {
    var model = Provider.of<KlContextProvider>(context, listen: false);
    // only goes back if we have a question we can go back to
    if (questionData.previous.isNotEmpty) {
      // returns the latest context snapshot and loads the previous question
      var lastSnap = questionData.loadPreviousQuestion();
      // loads the snapshot as actual context model to the engine
      model.loadSnap(lastSnap);
    }
  }

  /// Loads the first question
  void _first(BuildContext context, QuestionData questionData) {
    var engine = Provider.of<KlEngine>(context, listen: false);
    engine.inference();
    var questions = engine.availableQuestions();
    if (questions.isEmpty)
      Navigator.of(context).pushNamed('/end');
    else
      questionData.loadQuestion(questions.first, engine.contextProvider.model);
  }

  void _reset(BuildContext context, QuestionData questionData) {
    questionData.clear();
    Provider.of<KlEngine>(context, listen: false).clear();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Consumer<QuestionData>(
      builder: (context, questionData, _) => questionData.hasQuestion
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: QuestionWidget(
                question: questionData.current,
                change: (index) => questionData.changeOption(index),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 15.0),
                    height: 40.0,
                    width: 100.0,
                    child: RaisedButton(
                      child: const Text('Previous'),
                      onPressed: () => _previous(context, questionData)
                    ),
                  ),
                  const SizedBox(width: 10.0,),
                  Container(
                    margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    height: 40.0,
                    width: 100.0,
                    child: RaisedButton(
                      child: const Text('Next'),
                      onPressed: () => _next(context, questionData)
                    ),
                  )
                ]
              )
            ]
          )
        : Container(
            height: 250.0,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('There is currently no question loaded!',
                  style: theme.textTheme.headline6),
                FlatButton(
                  child: Container(
                    width: 100.0,
                    height: 40.0,
                    alignment: Alignment.center,
                    child: Text('Start Inference Process'),
                  ),
                  onPressed: () => _first(context, questionData)
                )
              ]
            )
        )
    );
  }
}

class QuestionSession extends StatelessWidget {
  final Widget child;
  const QuestionSession({@required this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuestionData(),
      child: child,
    );
  }
}

class RouteHome extends StatelessWidget {
  final GlobalKey debuggerKey = GlobalKey();
  RouteHome({Key key}) : super(key: key);

  AppBar _buildAppBar(BuildContext context) {
    var theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.appBarTheme.color,
      title: const WidgetTitle(),
      actions: [
        const ActionInspector(),
        const ActionInfo(),
      ],
    );
  }

  Widget buildConstrained(BuildContext context, DebuggerProvider prov) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        fit: StackFit.passthrough,
        children: <Widget> [
          const MainScreen(),
          if (prov.showDebugger)
            InkWell(
              onTap: () => prov.changeState(),
              child: Container(
                color: Colors.grey[600].withOpacity(0.3),
              ),
            ),
          Positioned(
            right: 0, left: 60.0,
            top: 0, bottom: 0,
            child: Visibility(
              visible: prov.showDebugger,
              child: WidgetDebugger(key: debuggerKey),
            ),
          )
        ]
      ),
    );
  }

  Widget buildFull(BuildContext context, DebuggerProvider prov) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Expanded(
            flex: 2,
            child: const MainScreen()
          ),
          Visibility(
            visible: prov.showDebugger,
            child: WidgetDebugger(key: debuggerKey),
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return KnowledgeBaseLoader(
      onLoad: (context) => const CircularProgressIndicator(),
      onDone: (context) => Consumer<DebuggerProvider>(
        builder: (context, prov, _) => WidgetSizeRequirement(
          minHeight: 200, minWidth: 300,
          builder: (context, constraints) {
            return constraints.maxWidth <= 800.0
              ? buildConstrained(context, prov)
              : buildFull(context, prov);
          }
        )
      ),
      onErr: (context, err) =>
        Center(child: Text('Error loading knowledge base $err'))
    );
  }
}
