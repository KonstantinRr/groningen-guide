

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetIconRef extends StatelessWidget {
  final String name, linkName;
  const WidgetIconRef({Key key, @required this.name, this.linkName}) :
    assert(name != null, 'Name must not be null.'),
    assert(linkName != null, 'LinkName must not be null.'),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.bodyText1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        Text('Icon made by ', style: style,),
        InkWell(
          child: Text(name, style: style.copyWith(color: Colors.lightBlue),),
          onTap: () => launch('https://www.flaticon.com/authors/$linkName'),
        ),
        Text(' from ', style: style,),
        InkWell(
          child: Text('Flaticon', style: style.copyWith(color: Colors.lightBlue),),
          onTap: () => launch('https://www.flaticon.com/'),
        ),
      ]
    );
  }
}