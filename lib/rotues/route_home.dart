/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/loader/asset_loader.dart';
import 'package:groningen_guide/widgets/widget_question.dart';
import 'package:groningen_guide/widgets/widget_debugger.dart';

/// The main screen of the [RouteHome]
class MainScreen extends StatelessWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Consumer<QuestionData>(
      builder: (context, questionData, _) =>
        Padding(
          padding: const EdgeInsets.all(15),
          child: questionData.hasQuestion ?
            Column(
              children: [
                QuestionWidget(
                  question: questionData.current,
                  change: (index) => questionData.changeOption(index),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15.0),
                  height: 40.0, width: 150.0,
                  child: RaisedButton(
                    child: const Text('Next'),
                    onPressed: () {
                      var engine = Provider.of<KlEngine>(context, listen: false);
                      var selectedOptions = questionData.selectedOptions();
                      for (var i in selectedOptions)
                        engine.evaluateEvents(i.events);
                      engine.inference();
                      engine.loadNextQuestion(questionData);
                      //engine.inference();
                    },
                  ),
                )
              ] 
            ) :
            Container(
              height: 150.0,
              alignment: Alignment.center,
              child: Column(
                children: <Widget> [
                  Text('There is currently no question loaded!', style: theme.textTheme.headline6),
                  FlatButton(
                    child: Container(
                      width: 100.0,
                      height: 40.0,
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
        ),
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
  const RouteHome({Key key}) : super(key: key);

  AppBar _buildAppBar(BuildContext context) {
    var theme = Theme.of(context);
    return AppBar(
      backgroundColor: Colors.grey[100],
      actions: [
        Consumer<KlEngine>(
          builder: (context, engine, _) =>
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget> [
                  Text('Inspector', style: theme.textTheme.headline6,),
                  SizedBox(width: 5,),
                  Checkbox(
                    value: engine.debug,
                    onChanged: (val) => engine.updateEngine(
                      (engine) { engine.debug = !engine.debug;}),
                  )
                ]
              ),
            )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KnowledgeBaseLoader(
      onLoad: (context) => CircularProgressIndicator(),
      onDone: (context) {
        return QuestionSession(
          child: Consumer<KlEngine>(
          builder: (context, engine, _) =>
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth <= 850.0) {
                  return Scaffold(
                    appBar: _buildAppBar(context),
                    body: SingleChildScrollView(child: MainScreen()),
                  );
                } else {
                  return Scaffold(
                    appBar: _buildAppBar(context),
                    body: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget> [
                        Expanded(flex: 2, child: SingleChildScrollView(child: MainScreen())),
                        if (engine.debug)
                          const WidgetDebugger(),
                      ]
                    )
                  );
                }
              }
            )
        ));
      },
      onErr: (context, err) =>
        Center(child: Text('Error loading knowledge base $err'))
    );
  }
}