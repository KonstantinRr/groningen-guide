/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/widgets/widget_iconref.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static const String dependencies = 
    "This project uses a list of dependencies and third party assets. See the following list"
    "for more information about them and their licenses";

  static const List<Tuple4<String, String, String, String>> dep = [
    Tuple4('cupertino_icons', 'https://pub.dev/packages/cupertino_icons', '^1.0.0', 'MIT'),
    Tuple4('url_launcher', 'https://pub.dev/packages/url_launcher', '^5.7.10', 'BSD'),
    Tuple4('provider', 'https://pub.dev/packages/provider', '^4.3.2+2', 'MIT'),
    Tuple4('tuple', 'https://pub.dev/packages/tuple/', '^1.0.3', 'BSD'),
    Tuple4('logging', 'https://pub.dev/packages/logging', '^0.11.4', 'BSD'),
    Tuple4('auto_size_text', 'https://pub.dev/packages/auto_size_text', '^2.1.0', 'MIT')
  ];

  List<Widget Function(BuildContext)> builders;

  @override
  void initState() {
    super.initState();
    builders = [
      (context) => const Text(info),
      (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget> [
          const Text(privacy),
          const Text(privacyBold, style: TextStyle(fontWeight: FontWeight.bold),)
        ]
      ),
      (context) => const Text(cookies),
      (context) {
        var theme = Theme.of(context);
        return Column(
          children: [
            const Text(dependencies),
            Padding(
              child: Text('Icon dependencies', style: theme.textTheme.headline6,),
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            ),
            Row(
              children: [
                Image.asset('assets/images/turtle.png', width: 64.0, height: 64.0,),
                Expanded(child: Center(child: WidgetIconRef(name: 'Freepik', linkName: 'freepik',)))
              ],
            ),
            Row(
              children: [
                Image.asset('assets/images/logo.png', width: 64.0, height: 64.0),
                Expanded(child: Center(child: WidgetIconRef(name: 'Freepik', linkName: 'freepik',)),)
              ],
            ),
            Padding(
              child: Text('Package dependencies', style: theme.textTheme.headline6,),
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            ),
            Table(
              border: TableBorder.all(color: Colors.grey[500]),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: dep.map((e) => TableRow(
                children: <Widget> [
                  FlatButton(
                    child: Text(e.item1),
                    onPressed: () => launch(e.item2),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 30.0,
                    child: Text(e.item3),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 30.0,
                    child: Text(e.item4)
                  ),
                ]
              )).toList()
            )
          ],
        );
      }
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
              ),
              FlatButton(
                child: Text('Thirdparty', style: TextStyle(color: page == 3 ? theme.accentColor : null)),
                onPressed: () => setState(() => page = 3),
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