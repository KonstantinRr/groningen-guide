/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/main.dart';
import 'package:groningen_guide/widgets/widget_db_question.dart';
import 'package:groningen_guide/widgets/widget_db_rule.dart';
import 'package:groningen_guide/widgets/widget_db_variables.dart';
import 'package:provider/provider.dart';


class WidgetEvaluator extends StatelessWidget {
  final bool val;
  const WidgetEvaluator({@required this.val, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Text('$val',
        style: theme.textTheme.bodyText2
            .copyWith(color: val ? Colors.green : Colors.red));
  }
}

class WidgetDebugger extends StatefulWidget {
  final bool includeScrollBar;
  final bool showAlways;
  const WidgetDebugger({Key key,
    this.includeScrollBar = true,
    this.showAlways = false})
      : super(key: key);

  @override
  WidgetDebuggerState createState() => WidgetDebuggerState();
}

class WidgetDebuggerState extends State<WidgetDebugger> {
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      width: 400.0,
      color: Colors.white,
      child: Consumer<KlBaseProvider>(
        builder: (context, klBaseProvider, _) {
          var view = SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 45.0,
                  margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 5.0),
                  child: RaisedButton(
                    color: theme.primaryColor,
                    child: Text('Edit Knowledge Base', style: theme.textTheme.button,),
                    onPressed: () =>
                      Navigator.of(context).pushNamed('/editor')),
                ),
                Container(
                  height: 45.0,
                  margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 10.0),
                  child: RaisedButton(
                    color: theme.primaryColor,
                    child: Text('Reset', style: theme.textTheme.button,),
                    onPressed: () {
                      Provider.of<QuestionData>(context, listen: false).clear();
                      Provider.of<KlEngine>(context, listen: false).clear();
                    }
                  ),
                ),
                //Container(
                //  margin: const EdgeInsets.only(top: 10, bottom: 5),
                //  alignment: Alignment.center,
                //  child: Text('EndPoints', style: theme.textTheme.headline5,),
                //),
                //Column(
                //  children: klBaseProvider.base.endpoints.map((e) => null)
                //)
                const WidgetVariables(),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 5),
                  alignment: Alignment.center,
                  child: Text('Rules', style: theme.textTheme.headline5, ),
                ),
                ...
                enumerate(klBaseProvider.base.rules).map<Widget>(
                  (r) => Container(
                    padding: const EdgeInsets.all(7),
                    color: r.item1.isOdd ? Colors.grey[200] : Colors.grey[100],
                    child: WidgetRule(rule: r.item2)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 5),
                  alignment: Alignment.center,
                  child: Text(
                    'Questions',
                    style: theme.textTheme.headline5,
                  ),
                ),
                ...
                enumerate(klBaseProvider.base.questions).map(
                  (q) => Container(
                    padding: const EdgeInsets.all(7),
                    color: q.item1.isOdd ? Colors.grey[200] : Colors.grey[100],
                    child: WidgetQuestion(question: q.item2)),
                )
              ]
            )
          );

          return widget.includeScrollBar
            ? Scrollbar(
                child: view,
                controller: controller,
                isAlwaysShown: widget.showAlways,
                thickness: 8.0,
              )
            : view;
        },
      ),
    );
  }
}
