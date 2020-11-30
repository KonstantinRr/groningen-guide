/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl


import 'package:flutter/material.dart';
import 'package:groningen_guide/widgets/widget_logo.dart';
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

    return Scaffold(
      body: Stack(
        fit: StackFit.passthrough,
        children: <Widget> [
          Center(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              const WidgetLogo(size: 250.0,),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text('Groningen Guide', style: theme.textTheme.headline3,),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 50.0, height: 50.0,
                  child: const CircularProgressIndicator()
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
    );
  }
}
