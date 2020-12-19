/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:auto_size_text/auto_size_text.dart';

import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl_engine.dart';
import 'package:groningen_guide/main.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

/// This [Widget] displays a question as well as the selected answer
/// options. The default constructor takes a [Tuple2] consisting of
/// the question and a [List] of booleans determining whether the
/// answer options is selected.
class QuestionWidget extends StatefulWidget {
  
  final KlQuestion question;
  final List<bool> answers;
  final void Function(int) change;

  QuestionWidget({
    Tuple2<KlQuestion, List<bool>> data,
    @required this.change,
  Key key}) :
    assert(data != null, 'Question must not be null'),
    assert(change != null, 'Change must not be null'),
    question = data.item1,
    answers = data.item2,
    super(key: key);

  /// Creates the [QuestionWidgetState]
  QuestionWidgetState createState() => QuestionWidgetState();
}

/// The [State] associated with [QuestionWidget]
class QuestionWidgetState extends State<QuestionWidget> {
  static Logger logger = Logger('QuestionWidgetState');

  ImageProvider _provider;
  bool err = false;

  @override
  void initState() {
    super.initState();
    _loadImage()
      .then((value) => setState(() => _provider = value))
      .catchError((err) => setState(() => err = true));
  }

  /// Loads the asset image specified by the question.
  /// The image may be loaded as [NetworkImage] if the link starts
  /// with http:// or https://.
  Future<ImageProvider> _loadImage() async {
    var image = widget.question.image;
    if (image.startsWith('http://') || image.startsWith('https://'))
      return NetworkImage(image);

    try {
      var bytes = await rootBundle.load(widget.question.image);
      return MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {
      logger.warning('Could not load bytes from $image');
      rethrow;
    }
  }

  /// Builds the question [Widget]
  Widget _buildQuestion(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        AutoSizeText(widget.question.name, style: theme.textTheme.headline5,
          textAlign: TextAlign.center, maxLines: 1,),
        AutoSizeText(widget.question.description, style: theme.textTheme.bodyText2,
          textAlign: TextAlign.center, maxLines: 2,),
        const SizedBox(height: 15),
        if (widget.question.image != null)
          Builder(
            builder: (context) {
              if (err)
                return Container(
                  padding: const EdgeInsets.all(15.0),
                  alignment: Alignment.center,
                  child: Text('Could not load Image at ${widget.question.image}')
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

  /// Builds the question option [Widget]
  Widget _buildOptions(BuildContext context) {
    var theme = Theme.of(context);
    return Center(child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 700.0),
      child: Consumer<KlEngine>(
        builder: (context, engine, child) =>
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: enumerate(widget.question.options)
              .where((e) => engine.evaluateConditionList(e.item2.conditions))
              .map((e) =>
                FlatButton(
                  onPressed: () => widget.change(e.item1),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: widget.answers[e.item1] ? theme.primaryColor : Colors.grey[300]
                    ),
                    height: 50.0,
                    alignment: Alignment.center,
                    child: Text(e.item2.description)
                  ),
                )
              ).toList()
          )
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                    elevation: 5.0,
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
    );
  }
}
