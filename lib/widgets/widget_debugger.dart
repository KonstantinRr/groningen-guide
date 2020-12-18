/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_rule.dart';

import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/main.dart';
import 'package:groningen_guide/widgets/widget_db_endpoint.dart';
import 'package:groningen_guide/widgets/widget_db_question.dart';
import 'package:groningen_guide/widgets/widget_db_rule.dart';
import 'package:groningen_guide/widgets/widget_db_variables.dart';
import 'package:provider/provider.dart';

class WidgetDebuggerList<T> extends StatelessWidget {
  final List<T> list;
  final Widget Function(T) builder;
  final String name;
  const WidgetDebuggerList({Key key,
    @required this.name,
    @required this.list,
    @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget> [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 5),
          alignment: Alignment.center,
          child: Text(name, style: theme.textTheme.headline5,),
        ),
        ...
        enumerate(list).map<Widget>(
          (r) => Container(
            padding: const EdgeInsets.all(7),
            color: r.item1.isOdd ? Colors.grey[200] : Colors.grey[100],
            child: builder(r.item2),
          ),
        )
      ]
    );
  }
}

class WidgetRuleList extends StatelessWidget {
  final List<KlRule> rules;
  const WidgetRuleList({Key key, @required this.rules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 5),
          alignment: Alignment.center,
          child: Text('Rules', style: Theme.of(context).textTheme.headline5, ),
        ),
        ...
        enumerate(rules).map<Widget>(
          (r) => Container(
            padding: const EdgeInsets.all(7),
            color: r.item1.isOdd ? Colors.grey[200] : Colors.grey[100],
            child: WidgetRule(rule: r.item2)),
        ),
      ],
    );
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
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var view = Container(
      width: 400.0,
      color: Colors.white,
      child: ListView(
        controller: controller,
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
            const WidgetVariables(),
            Consumer<KlBaseProvider>(
              builder: (context, klBaseProvider, _) => WidgetDebuggerList(
                list: klBaseProvider.base.endpoints,
                name: 'Endpoints',
                builder: (endpoint) => WidgetEndpoint(endpoint: endpoint),
            )),
            Consumer<KlBaseProvider>(
              builder: (context, klBaseProvider, _) => WidgetDebuggerList(
                list: klBaseProvider.base.rules,
                name: 'Rules',
                builder: (rule) => WidgetRule(rule: rule),
            )),
            Consumer<KlBaseProvider>(
              builder: (context, klBaseProvider, _) => WidgetDebuggerList(
                list: klBaseProvider.base.questions,
                name: 'Question',
                builder: (question) => WidgetQuestion(question: question),
            )),
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
  }
}
