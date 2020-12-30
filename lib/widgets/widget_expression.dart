/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/kl_parser.dart';

/// This [Widget] represents a [TextField] where it is possible
/// to enter text that is parsed as expression. 
class ExpressionParser extends StatefulWidget {
  final double width, height;
  final void Function(TreeElement) onSuccess;
  final void Function(dynamic, StackTrace) onError;

  const ExpressionParser({this.width, this.height,
    this.onError, this.onSuccess, Key key}) :
    super(key: key);

  /// Creates an [ExpressionParserState]
  @override
  ExpressionParserState createState() => ExpressionParserState(
    onError: onError, onSuccess: onSuccess);
}

/// The [State] associated with [ExpressionParser]
class ExpressionParserState extends State<ExpressionParser> {
  final controller = TextEditingController();
  void Function(TreeElement) onSuccess;
  void Function(dynamic, StackTrace) onError;


  ExpressionParserState({
    @required void Function(TreeElement) onSuccess,
    @required void Function(dynamic, StackTrace) onError,
  }) {
    onSuccess ??= _showSuccessDialog;
    onError ??= _showErrorDialog;
  }
  
  void _showErrorDialog(dynamic err, StackTrace stack) {
    showDialog(
      context: context,
      builder: (context) {
        var theme = Theme.of(context);
        return AlertDialog(
          title: Text('Error', style: theme.textTheme.headline6,),
          content: Text('${err.toString()}', style: theme.textTheme.bodyText1,),
        );
      }
    );
  }

  void _showSuccessDialog(TreeElement tree) {
    showDialog(
      context: context,
      builder: (context) {
        var theme = Theme.of(context);
        return AlertDialog(
          title: Text('Success', style: theme.textTheme.headline6,),
          content: Text(tree.istr(), style: theme.textTheme.bodyText1,),
          actions: [
            FlatButton(
              child: Text('Exit'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      }
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Loads the currently entered expression to the
  void _loadExpression() {
    try {
      var tree = buildExpression(controller.text);
      onSuccess(tree);
    } catch (e, stacktrace) {
      onError(e, stacktrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextField(
              maxLines: null, minLines: null,
              controller: controller,
              decoration: InputDecoration.collapsed(
                hintText: 'Expression'
              ),
              expands: true,
            ),
          ),
          RaisedButton(
            child: Text('Load Expression'),
            onPressed: _loadExpression
          ),
        ],
      )
    );
  }
}