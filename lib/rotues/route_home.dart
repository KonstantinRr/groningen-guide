/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
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

  void _next(BuildContext context, QuestionData questionData) {
    var engine = Provider.of<KlEngine>(context, listen: false);
    var selectedOptions = questionData.selectedOptions();
    for (var i in selectedOptions)
      engine.evaluateEvents(i.events);
    engine.inference();
    var endpoint = engine.checkEndpoints();
    if (endpoint != null) {
      showEndpointDialog(context, endpoint);
    } else {
      engine.loadNextQuestion(questionData);
    }
  }

  void _previous(BuildContext context, QuestionData questionData) {

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
                    child: Text('Start Process'),
                  ),
                  onPressed: () {
                    // loads the next question
                    var engine = Provider.of<KlEngine>(context, listen: false);
                    engine.inference();
                    engine.loadNextQuestion(questionData);
                  },
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
      onDone: (context) => QuestionSession(
        child: Consumer<DebuggerProvider>(
          builder: (context, prov, _) => WidgetSizeRequirement(
            minHeight: 200, minWidth: 300,
            builder: (context, constraints) {
              return constraints.maxWidth <= 800.0
                ? buildConstrained(context, prov)
                : buildFull(context, prov);
            }
          )
        )
      ),
      onErr: (context, err) =>
        Center(child: Text('Error loading knowledge base $err'))
    );
  }
}
