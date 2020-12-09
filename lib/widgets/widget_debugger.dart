/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/widgets/widget_questioninfo.dart';
import 'package:groningen_guide/widgets/widget_rule.dart';
import 'package:provider/provider.dart';

Iterable<List> enumerate(Iterable<dynamic> it) sync* {
  int index = 0;
  for (var val in it) {
    yield [ index, val ];
    index++;
  }
}

class WidgetEvaluator extends StatelessWidget {
  final bool val;
  const WidgetEvaluator({@required this.val, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Text('$val', style: theme.textTheme.bodyText2.copyWith(
        color: val ? Colors.green : Colors.red));
  }
}

class WidgetDebugger extends StatefulWidget {
  final bool includeScrollBar;
  const WidgetDebugger({this.includeScrollBar=true, Key key}) : super(key: key);

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
    return Container(
      width: 500.0,
      color: Colors.white,
      child: Consumer<KlBaseProvider>(
        builder: (context, klBaseProvider, _) {
          var view = SingleChildScrollView(
            controller: controller,
            child: Column(children: <Widget> [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: RaisedButton(
                  child: const Text('Edit Knowledge Base'),
                  onPressed: () => Navigator.of(context).pushNamed('/editor')
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                alignment: Alignment.center,
                child: Text('Variables', style: theme.textTheme.headline5,),
              ),
              Consumer<KlContextProvider>(
                builder: (context, contextProvider, _) => Column(
                  children: enumerate(contextProvider.model.entries).map((e) =>
                    Container(
                      padding: const EdgeInsets.all(7),
                      color: e[0].isOdd ? Colors.grey[200] : Colors.grey[100],
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: e[1].value != 0,
                            onChanged: (val) => contextProvider.updateContextModel(
                              (model) => model.setVar(e[1].key, val ? 1 : 0)),
                          ),
                          Container(
                            width: 150.0,
                            height: 40.0,
                            alignment: Alignment.center,
                            child: Text(e[1].key),
                          )
                        ],
                      ),
                    )
                  ).toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                alignment: Alignment.center,
                child: Text('Rules', style: theme.textTheme.headline5,),
              ),
              ...
              enumerate(klBaseProvider.base.rules).map<Widget>((r) =>
                Container(
                  padding: const EdgeInsets.all(7),
                  color: r[0].isOdd ? Colors.grey[200] : Colors.grey[100],
                  child: WidgetRule(rule: r[1])
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                alignment: Alignment.center,
                child: Text('Questions', style: theme.textTheme.headline5,),
              ),
              ...
              enumerate(klBaseProvider.base.questions).map((q) =>
                Container(
                  padding: const EdgeInsets.all(7),
                  color: q[0].isOdd ? Colors.grey[200] : Colors.grey[100],
                  child: WidgetQuestion(question: q[1])
                ),
              )
            ]
          ));

          return widget.includeScrollBar ?
            Scrollbar(
              child: view,
              controller: controller,
              isAlwaysShown: true,
              thickness: 8.0,
            ) : view;
        },
      ),
    );
  }
}