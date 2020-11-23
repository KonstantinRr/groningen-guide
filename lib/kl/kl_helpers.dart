/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'dart:convert';

/// General JSON implementations ///

abstract class JsonElement {
  /// Deserializes the given object
  void read(dynamic obj);

  void assertType<Type>(dynamic obj, {bool allowNull=false}) {
    if (!(allowNull && obj == null) && !(obj is Type))
      throw Exception('Object must be of type \'${Type.toString()}\'');
  }

  Type assertTypeGet<Type>(dynamic map, dynamic key, {bool allowNull=false}) {
    assertType<Map>(map);
    var result = map[key];
    assertType<Type>(result, allowNull: allowNull);
    return result as Type;
  }
}

abstract class ListObject extends JsonElement {
  /// Serializes this object as a Json list
  List<dynamic> asList();

  @override
  String toString() => asList().toString();
}

abstract class MapObject extends JsonElement {
  /// Serializes this object as a Json object
  Map<String, dynamic> toJson();

  @override
  String toString() => json.encode(toJson());
}
