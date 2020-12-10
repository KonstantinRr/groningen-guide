/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';

class ActionInfoDialog extends StatefulWidget {
  const ActionInfoDialog({Key key}) : super(key: key);

  @override
  ActionInfoDialogState createState() => ActionInfoDialogState();
}

class ActionInfoDialogState extends State<ActionInfoDialog> {
  int page = 0;
  
  final String info = 
    "This project is build during the course Knowledge Technology Practical at the\n"
    "UNIVERSITY OF GRONINGEN (WBAI014-05).\n\n"
    "The project was build by:\n"
    "Konstantin Rolf (S3750558) k.rolf@student.rug.nl\n"
    "Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl\n"
    "Livia Regus (S3354970): l.regus@student.rug.nl\n";

  List<Widget Function(BuildContext)> builders;
  
  @override
  void initState() {
    super.initState();
    builders = [
      (context) => Text(info),
      (context) => Container(),
      (context) => Container()
    ];
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AlertDialog(
      title: Row(
        children: <Widget> [
          Expanded(child: Text('Information')),
          FlatButton(
            child: Text('Info', style: TextStyle(color: page == 0 ? theme.accentColor : null),),
            onPressed: () => setState(() => page = 0),
          ),
          FlatButton(
            child: Text('Privacy', style: TextStyle(color: page == 1 ? theme.accentColor : null),),
            onPressed: () => setState(() => page = 1),
          ),
          FlatButton(
            child: Text('Cookies', style: TextStyle(color: page == 2 ? theme.accentColor : null),),
            onPressed: () => setState(() => page = 2)
          )
        ]
      ),
      content: SizedBox(
        width: 600.0, height: 150.0,
        child: builders[page](context),
      ),
      actions: [
        FlatButton(
          child: Text('Back'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}


class ActionInfo extends StatelessWidget {

  const ActionInfo({Key key}) : super(key: key);

  Future<void> _showInfo(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => ActionInfoDialog()
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return IconButton(
      icon: Icon(Icons.info, color: theme.accentColor,),
      onPressed: () => _showInfo(context),
    );
  }
}