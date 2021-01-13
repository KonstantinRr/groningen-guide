/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/kl_parser.dart';
import 'package:groningen_guide/main.dart';
import 'package:groningen_guide/widgets/widget_debugger.dart';

import 'package:groningen_guide/widgets/widget_history.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class RouteHistory extends StatelessWidget {
  const RouteHistory({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<QuestionData>(
        builder: (context, questionData, _) => WidgetDebuggerList<
          Tuple2<int, Tuple3<KlQuestion, List<bool>, ContextModel>>
        >(
          list: enumerate<Tuple3<KlQuestion, List<bool>, ContextModel>>(
            questionData.previous).toList(),
          name: 'History',
          builder: (data) => WidgetHistroyElement(tup: data, questionData: questionData,),
        ),
      ),
    );
  }
}