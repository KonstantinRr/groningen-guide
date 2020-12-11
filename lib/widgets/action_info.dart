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
  final ScrollController controller = ScrollController();
  int page = 0;
  
  static const String info = 
    "This project is build during the course Knowledge Technology Practical at the\n"
    "UNIVERSITY OF GRONINGEN (WBAI014-05).\n\n"
    "The project was build by:\n"
    "Konstantin Rolf (S3750558) k.rolf@student.rug.nl\n"
    "Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl\n"
    "Livia Regus (S3354970): l.regus@student.rug.nl\n";

  static const String cookies =
    "This site does not make use of any Cookies to store session and/or user data.\n"
    "All session data is deleted whenever you leave or reload the site.\n";

  static const String privacy =
    "The site collects some general information data about site usage for service\n"
    "improvements and data analytics. This means that the following connection data\n"
    "is collected and stored at servers in Europe:\n"
    " - The IP address\n"
    " - The requested resources/links\n"
    " - The browser (version) that used to view the site\n";

  static const String privacyBold =
    "We value your privacy and do not collect any additional data!\n"
    "Contact k.rolf@student.rug.nl for more information about data collection and privacy";

  List<Widget Function(BuildContext)> builders;

  @override
  void initState() {
    super.initState();
    builders = [
      (context) => const Text(info),
      (context) => 
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget> [
            const Text(privacy),
            const Text(privacyBold, style: TextStyle(fontWeight: FontWeight.bold),)
          ]
        ),
      (context) => const Text(cookies)
    ];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AlertDialog(
      title: Row(
        children: <Widget> [
          Expanded(child: Text('Information')),
          Expanded(child: Wrap(
            runAlignment: WrapAlignment.end,
            children: <Widget> [
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
          ))
        ]
      ),
      content: SizedBox(
        width: 600.0, height: 170.0,
        child: Scrollbar(
          isAlwaysShown: false,
          thickness: 8.0,
          controller: controller,
          child: SingleChildScrollView(
            controller: controller,
            child: builders[page](context),
          ),
        ),
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