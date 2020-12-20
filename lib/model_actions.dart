/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/rotues/route_endpoint.dart';
import 'package:provider/provider.dart';

Future<void> nextQuestion(BuildContext context) async {
  // finds the engine provider in the widget tree
  var engine = Provider.of<KlEngine>(context, listen: false);
  var questionData = Provider.of<QuestionData>(context, listen: false);
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
  var endpoints = engine.checkEndpoints().toList();

  if (endpoints.isNotEmpty) {
    print('Found Endpoints $endpoints');
    // we reached an endpoint and want to show the dialog
    var result = await showEndpointDialog(context, endpoints); // TODO multiple endpoints
    switch (result) {
      case GoalDialogAction.Previous:
        previousQuestion(context); // TODO side effects
        break;
      case GoalDialogAction.Reset:
        resetModel(context);
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
void previousQuestion(BuildContext context) {
  var model = Provider.of<KlContextProvider>(context, listen: false);
  var questionData = Provider.of<QuestionData>(context, listen: false);
  // only goes back if we have a question we can go back to
  if (questionData.previous.isNotEmpty) {
    // returns the latest context snapshot and loads the previous question
    var lastSnap = questionData.loadPreviousQuestion();
    // loads the snapshot as actual context model to the engine
    model.loadSnap(lastSnap);
  }
}



/// Loads the first question
void firstQuestion(BuildContext context) {
  var engine = Provider.of<KlEngine>(context, listen: false);
  var questionData = Provider.of<QuestionData>(context, listen: false);

  engine.inference();
  var questions = engine.availableQuestions();
  if (questions.isEmpty)
    Navigator.of(context).pushNamed('/end');
  else
    questionData.loadQuestion(questions.first, engine.contextProvider.model);
}

/// Resets the whole model
void resetModel(BuildContext context) {
  Provider.of<QuestionData>(context, listen: false).clear();
  Provider.of<KlEngine>(context, listen: false).clear();
}