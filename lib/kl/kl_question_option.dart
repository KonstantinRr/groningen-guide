
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

  /// Creates a new question option by supplying the member variables
  KlQuestionOption({this.description, this.events});
  /// Creates a new question option using a JSON deserialized object
  factory KlQuestionOption.fromJson(dynamic map) => KlQuestionOption()..read(map);

  /// Reads the question option object using a JSON deserialized object
  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    description = assertTypeGet<String>(map, 'description');
    events = assertTypeGet<List<String>>(map, 'events');
  }

  /// Serializes this object as a JSON object
  Map<String, dynamic> toJson() => {
    'description': description,
    'events': events
  };
}
