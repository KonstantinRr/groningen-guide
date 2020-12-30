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

  bool assertType<Type>(dynamic obj, {bool allowNull=false}) {
    if (!(allowNull && obj == null) && !(obj is Type))
      throw Exception('Object $obj must be of type \'${Type.toString()}\'');
    return obj != null;
  }

  Type assertTypeGet<Type>(dynamic map, dynamic key, {bool allowNull=false, Type def}) {
    assertType<Map>(map);
    var result = map[key];
    assertType<Type>(result, allowNull: allowNull);
    return result == null ? def : result as Type;
  }

  List<Type> assertTypeGetList<Type>(
    dynamic map, dynamic key,
    {bool allowNull=false, List<Type> def,
    Type Function(dynamic) converter})
  {
    assertType<Map>(map);
    converter ??= (dynamic obj) {
      try {
        return obj as Type;
      } catch (e) {
        throw Exception('Could not convert $obj to ${Type.toString()}');
      }
    };

    var result = map[key];
    var isNotNull = assertType<List>(result, allowNull: allowNull);
    if (isNotNull) {
      return (result as List).map<Type>((e) => converter(e)).toList();
    } else {
      return def;
    }
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
