/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:groningen_guide/kl/kl_helpers.dart';

/// ---- Specific Knowledge Base implementations ---- ///

/// The general definition of a value in the knowledge base.
/// These are the default values that are initialized during the start
/// of the infering process. Values that are not defined are interpreted
/// as null. Rules can never return a true value as long as it contains
/// undefined variables (null vars).
class KlVariable extends MapObject {
  /// The variable's unique identifier
  String name;
  /// The variable's numerical value
  int value;

  /// Creates a new variable by supplying the member variables
  KlVariable({this.name, this.value});
  /// Creates a new variable using a JSON deserialized object
  factory KlVariable.fromJson(dynamic map) => KlVariable()..read(map);

  /// Reads the variable object using a JSON deserialized object
  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    name = assertTypeGet<String>(map, 'name');
    value = assertTypeGet<int>(map, 'value');
  }

  /// Serializes this object as a JSON object
  Map<String, dynamic> toJson() => {
    'name': name, 'value': value
  };
}
