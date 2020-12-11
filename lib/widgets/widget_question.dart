/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/widgets/widget_debugger.dart';
import 'package:tuple/tuple.dart';

class QuestionWidget extends StatefulWidget {
  final Tuple2<KlQuestion, List<bool>> question;
  final void Function(int) change;
  QuestionWidget({@required this.question,
    @required this.change, Key key}) : super(key: key);

  QuestionWidgetState createState() => QuestionWidgetState();
}
class QuestionWidgetState extends State<QuestionWidget> {
  ImageProvider _provider;
  bool err = false;
  @override
  void initState() {
    super.initState();
    _loadImage()
      .then((value) => setState(() => _provider = value))
      .catchError((err) => setState(() => err = true));
  }
  Future<ImageProvider> _loadImage() async {
    var image = widget.question.item1.image;
    if (image.startsWith('http://') || image.startsWith('https://'))
      return NetworkImage(image);

    // load as asset
    try {
      var bytes = await rootBundle.load(widget.question.item1.image);
      return MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {
      print('Could not load bytes');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.question.item1.name, style: theme.textTheme.headline5),
          Text(widget.question.item1.description, style: theme.textTheme.bodyText2,),
          const SizedBox(height: 15),
          if (widget.question.item1.image != null)
            Builder(
              builder: (context) {
                if (err)
                  return Container(
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.center,
                    child: Text('Could not load Image at ${widget.question.item1.image}')
                  );
                if (_provider == null) {
                  return Container(
                    width: 60.0, height: 60.0,
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _provider
                    )
                  ),
                );
              }
            ),
          const SizedBox(height: 15,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: enumerate(widget.question.item1.options).map((e) =>
              FlatButton(
                onPressed: () => widget.change(e.item1),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: widget.question.item2[e.item1] ? Colors.lightBlue : Colors.grey[300]
                  ),
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Text(e.item2.description)
                ),
              )
            ).toList()
          ),
        ],
      ),
    );
  }
}
