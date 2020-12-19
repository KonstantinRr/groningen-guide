/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:groningen_guide/kl/kl_helpers.dart';
import 'package:groningen_guide/kl/kl_question_option.dart';

/// ---- Specific Knowledge Base implementations ---- ///

/// This class represents a question in the knowledge base. It is used to gain
/// more information that the model cannot infere by itself. It contains a list
/// of conditions that must be met before the question can be asked. 
class KlQuestion extends MapObject {
  /// The question's unique name
  String name;
  /// The question's description
  String description;
  /// A path to an additional image
  String image;
  /// List of conditions that must be true before this 
  List<String> conditions;
  /// The list of options the user may choose
  List<KlQuestionOption> options;
  /// Maximum amount of answers you can choose
  int maxAnswers;

  /// Creates an empty question where all elements are null
  KlQuestion.zero();

  /// Creates a new question by supplying the member variables
  KlQuestion({this.name, this.description, this.image,
    List<KlQuestionOption> options, this.maxAnswers})
    : options = options ?? [];

  /// Creates a new question using a JSON deserialized object
  factory KlQuestion.fromJson(dynamic obj) => KlQuestion.zero()..read(obj);
  
  /// Reads the question object using a JSON deserialized object
  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    name = assertTypeGet<String>(map, 'name', allowNull: true);
    description = assertTypeGet<String>(map, 'description');
    image = assertTypeGet<String>(map, 'image', allowNull: true);
    maxAnswers = assertTypeGet<int>(map, 'maxAnswers', allowNull: true);
    conditions = assertTypeGetList<String>(map, 'conditions', converter: (e) => e as String);
    options = assertTypeGetList<KlQuestionOption>(map, 'options', converter: (e) => KlQuestionOption.fromJson(e));
  }

  /// Serializes this object as a JSON object
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'image': image,
    'maxAnswers': maxAnswers,
    'options': options?.map((e) => e.toJson())?.toList()
  };
}
