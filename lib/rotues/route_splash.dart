/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:groningen_guide/widgets/widget_logo.dart';
import 'package:groningen_guide/widgets/width_size_requirement.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteSplash extends StatefulWidget {
  final Duration delay;
  final bool skip;
  final String destination;

  const RouteSplash({
    this.destination = '/', this.skip = true, Key key,
    this.delay = const Duration(milliseconds: 700),
  }) : super(key: key);

  RouteSplashState createState() => RouteSplashState();
}

class RouteSplashState extends State<RouteSplash> {
  @override
  void initState() {
    super.initState();
    if (widget.skip)
      Future.delayed(widget.delay, () =>
        Navigator.of(context).pushReplacementNamed(widget.destination));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.bodyText1;

    return WidgetSizeRequirement(
      minHeight: 210.0,
      minWidth: 270.0,
      builder: (context, _) => Scaffold(
        body: Stack(
          fit: StackFit.passthrough,
          children: <Widget> [
            Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text('Groningen Guide', style: theme.textTheme.headline4,),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    children: <Widget> [
                      SizedBox(
                        width: 75.0, height: 75.0,
                        child: const CircularProgressIndicator()
                      ),
                      const WidgetLogo(size: 55, margin: const EdgeInsets.all(10.0)),
                    ]
                  )
                ),
              ]
            )),
            // icon attribution
            Positioned(
              bottom: 0.0, height: 50.0,
              left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                  Text('Icons made by ', style: style,),
                  InkWell(
                    child: Text('Freepik', style: style.copyWith(color: Colors.lightBlue),),
                    onTap: () => launch('https://www.flaticon.com/authors/freepik'),
                  ),
                  Text(' from ', style: style,),
                  InkWell(
                    child: Text('Flaticon', style: style.copyWith(color: Colors.lightBlue),),
                    onTap: () => launch('https://www.flaticon.com/'),
                  ),
                ]
              )
            )
          ]
        )
      ),
    );
  }
}
