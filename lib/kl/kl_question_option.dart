/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:groningen_guide/kl/kl_helpers.dart';

/// ---- Specific Knowledge Base implementations ---- ///

/// This class represents an option in a question that is asked
/// to the user during the inference process. It contains a [description]
/// member giving a brief summary of its events. The [condition]
/// member gives a list of expressions that must be true before this
/// question may be asked.
class KlQuestionOption extends MapObject {
  /// Gives a brief description of this option
  String description;
  /// List of events that happen if this option is selected
  List<String> events;
  /// List of conditions that need to be fullfilled 
  List<String> conditions;
  /// Whether this question option is exclusive
  bool exclusive;

  /// Creates a question option where all members are null.
  KlQuestionOption.zero();

  /// Creates a new question option by supplying the member variables
  KlQuestionOption({this.description, List<String> events, List<String> conditions}) :
    events = events ?? [], conditions = conditions ?? [];
  /// Creates a new question option using a JSON deserialized object
  factory KlQuestionOption.fromJson(dynamic map) => KlQuestionOption.zero()..read(map);

  /// Reads the question option object using a JSON deserialized object
  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    description = assertTypeGet<String>(map, 'description');
    exclusive = map['exclusive'] ?? false;
    events = assertTypeGetList<String>(map, 'events', converter: (e) => e as String);
    conditions = assertTypeGetList<String>(map, 'conditions', allowNull: true, def: [],
      converter: (e) => e as String);
  }

  /// Serializes this object as a JSON object
  Map<String, dynamic> toJson() => {
    'description': description,
    'events': events,
    'conditions': conditions,
    'exclusive': exclusive
  };
}
