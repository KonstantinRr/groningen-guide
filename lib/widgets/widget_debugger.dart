/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl/kl_rule.dart';

import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/kl_parser.dart';
import 'package:groningen_guide/main.dart';
import 'package:groningen_guide/model_actions.dart';
import 'package:groningen_guide/widgets/widget_db_endpoint.dart';
import 'package:groningen_guide/widgets/widget_db_question.dart';
import 'package:groningen_guide/widgets/widget_db_rule.dart';
import 'package:groningen_guide/widgets/widget_db_variables.dart';
import 'package:groningen_guide/widgets/widget_history.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
        Padding(
          padding: EdgeInsets.all(5),
          child: Text('Loaded ${list.length} entries', style: theme.textTheme.bodyText1,),
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

class WidgetDebugger extends StatefulWidget {
  final bool includeScrollBar;
  final bool showAlways;
  final int initalPage;
  const WidgetDebugger({Key key,
    this.includeScrollBar = true,
    this.initalPage = 0,
    this.showAlways = false})
      : super(key: key);

  @override
  WidgetDebuggerState createState() => WidgetDebuggerState();
}

class WidgetDebuggerState extends State<WidgetDebugger> {
  final controller = ScrollController();
  List<Widget Function(BuildContext)> builders;
  int page;

  @override
  void initState() {
    super.initState();
    page = widget.initalPage;
    builders = [
      (context) => const WidgetVariables(),
      (context) => Consumer<KlBaseProvider>(
        builder: (context, klBaseProvider, _) => WidgetDebuggerList(
          list: klBaseProvider.base.endpoints,
          name: 'Endpoints',
          builder: (endpoint) => WidgetEndpoint(endpoint: endpoint),
      )),
      (context) => Consumer<KlBaseProvider>(
        builder: (context, klBaseProvider, _) => WidgetDebuggerList(
          list: klBaseProvider.base.rules,
          name: 'Rules',
          builder: (rule) => WidgetRule(rule: rule),
      )),
      (context) => Consumer<KlBaseProvider>(
        builder: (context, klBaseProvider, _) => WidgetDebuggerList(
          list: klBaseProvider.base.questions,
          name: 'Question',
          builder: (question) => WidgetQuestion(question: question),
      )),
      (context) => Consumer<QuestionData>(
        builder: (context, questionData, _) => WidgetDebuggerList<
          Tuple2<int, Tuple3<KlQuestion, List<bool>, ContextModel>>
        >(
          list: enumerate<Tuple3<KlQuestion, List<bool>, ContextModel>>(
            questionData.previous).toList(),
          name: 'History',
          builder: (data) => WidgetHistroyElement(tup: data, questionData: questionData,),
        ),
      )
    ];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildHeader(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      height: 60.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: FlatButton(
            child: Text('Variables', style: TextStyle(color: page == 0 ? theme.accentColor : null),),
            onPressed: () => setState(() => page = 0),
          )),
          Expanded(child: FlatButton(
            child: Text('Endpoints', style: TextStyle(color: page == 1 ? theme.accentColor : null)),
            onPressed: () => setState(() => page = 1),
          )),
          Expanded(child: FlatButton(
            child: Text('Rules', style: TextStyle(color: page == 2 ? theme.accentColor : null),),
            onPressed: () => setState(() => page = 2),
          )),
          Expanded(child: FlatButton(
            child: Text('Questions', style: TextStyle(color: page == 3 ? theme.accentColor : null),),
            onPressed: () => setState(() => page = 3),
          )),
          Expanded(child: FlatButton(
            child: Text('History', style: TextStyle(color: page == 4 ? theme.accentColor : null)),
            onPressed: () => setState(() => page = 4),
          ),)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var view = Container(
      color: Colors.white,
      child: ListView(
        controller: controller,
          children: <Widget>[
            Row(
              children: <Widget> [
                Expanded(child: Container(
                  height: 45.0,
                  margin: const EdgeInsets.all(5.0),
                  child: RaisedButton(
                    color: theme.primaryColor,
                    child: Text('Edit', style: theme.textTheme.button,),
                    onPressed: () =>
                      Navigator.of(context).pushNamed('/editor')),
                )),
                Expanded(child: Container(
                  height: 45.0,
                  margin: const EdgeInsets.all(5.0),
                  child: RaisedButton(
                    color: theme.primaryColor,
                    child: Text('Reset', style: theme.textTheme.button,),
                    onPressed: () => resetModel(context),
                  ),
                )),
              ]
            ),
            _buildHeader(context),
            builders[page](context)
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
