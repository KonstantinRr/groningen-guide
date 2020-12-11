import 'package:auto_size_text/auto_size_text.dart';
/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/main.dart';
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

  Widget _buildQuestion(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        AutoSizeText(widget.question.item1.name, style: theme.textTheme.headline5,
          textAlign: TextAlign.center, maxLines: 1,),
        AutoSizeText(widget.question.item1.description, style: theme.textTheme.bodyText2,
          textAlign: TextAlign.center, maxLines: 2,),
        const SizedBox(height: 15),
        if (widget.question.item1.image != null)
          Builder(
            builder: (context) {
              if (err)
                return Container(
                  padding: const EdgeInsets.all(15.0),
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
                height: 70.0, width: 70.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _provider
                  )
                ),
              );
            }
          ),
      ],
    );
  }

  Widget _buildOptions(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: enumerate(widget.question.item1.options).map((e) =>
        FlatButton(
          onPressed: () => widget.change(e.item1),
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: widget.question.item2[e.item1] ? theme.primaryColor : Colors.grey[300]
            ),
            height: 50.0,
            alignment: Alignment.center,
            child: Text(e.item2.description)
          ),
        )
      ).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (context, constraints) => ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget> [
            Container(
              height: 180.0,
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget> [
                  Positioned(
                    width: constraints.maxWidth * 2 / 3, right: 0.0,
                    top: 0.0,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: _buildQuestion(context)
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0, height: 100.0,
                    left: 0.0, width: constraints.maxWidth * 1.0 / 3.0,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/images/turtle.png')
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            _buildOptions(context),
          ],
        ),
      ),
    );
  }
}
