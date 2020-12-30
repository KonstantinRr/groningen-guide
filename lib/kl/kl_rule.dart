/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:groningen_guide/kl/kl_helpers.dart';

/// ---- Specific Knowledge Base implementations ---- ///

/// An inference rule is used to gain more knowledge using static rules. Each
/// rule contains a unique name and a description about this rule. It also
/// contains a list of strings (conditions) that is evaluated during the
/// inference process. The strings are evaluated as expressions using the
/// variables of the current knowledge base. If all conditions are achieved
/// the event list will be executed. 
class KlRule extends MapObject {
  /// The rule's unqiue name
  String name;
  /// The rule's description
  String description;
  /// The conditions that must be met for this rule
  List<String> conditions;
  /// The events that are executed if this rule is infered
  List<String> events;

  /// Creates an empty rule where all members are null
  KlRule.zero();

  /// Creates a new rule by supplying the member variables
  KlRule({this.name, this.description,
    List<String> conditions, List<String> events}) :
    conditions = conditions ?? [],
    events = events ?? [];
  
  /// Creates a new rule using a JSON deserialized object
  factory KlRule.fromJson(dynamic obj) => KlRule()..read(obj);

  /// Reads the rule object using a JSON deserialized object
  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    name = assertTypeGet<String>(map, 'name', allowNull: true);
    description = assertTypeGet<String>(map, 'description', allowNull: true);
    conditions = assertTypeGetList<String>(map, 'conditions', converter: (e) => e as String);
    events = assertTypeGetList<String>(map, 'events', converter: (e) => e as String);
  }

  /// Serializes this object as a JSON object
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'conditions': conditions,
    'events': events
  };
}
