
import 'dart:convert';

/// General JSON implementations ///

abstract class JsonElement {
  void assertType<Type>(dynamic obj) {
    if (!(obj is Type))
      throw Exception('Object must be of type \'${Type.toString()}\'');
  }

  Type assertTypeGet<Type>(dynamic map, dynamic key) {
    assertType<Map>(map);

    var result = map[key];
    assertType<Type>(result);
    return result as Type;
  }
}

abstract class ListObject extends JsonElement {
  /// Deserializes the given object
  void read(dynamic obj);
  /// Serializes this object as a Json list
  List<dynamic> asList();

  @override
  String toString() => asList().toString();
}

abstract class MapObject extends JsonElement {
  /// Deserializes the given object
  void read(dynamic obj);
  /// Serializes this object as a Json object
  Map<String, dynamic> toJson();

  @override
  String toString() => json.encode(toJson());
}

/// Specific Knowledge Base implementations ///

class KlValue extends MapObject {
  String name;
  double value;

  KlValue({this.name, this.value});
  factory KlValue.fromJson(dynamic map) => KlValue()..read(map);

  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    name = assertTypeGet<String>(map, 'name');
    value = assertTypeGet<double>(map, 'value');
  }

  Map<String, dynamic> toJson() => {
    'name': name, 'value': value
  };
}

class KlRule extends MapObject {
  String name, description;
  List<String> conditions;
  List<String> events;

  KlRule({this.name, this.description, this.conditions, this.events});
  factory KlRule.fromJson(dynamic obj) => KlRule()..read(obj);

  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    name = assertTypeGet<String>(map, 'name');
    description = assertTypeGet<String>(map, 'description');
    conditions = assertTypeGet<List<String>>(map, 'conditions');
    events = assertTypeGet<List<String>>(map, 'events');
  }

  Map<String, dynamic> toJson() => {
    'name': name, 'description': description,
    'conditions': conditions, 'events': events
  };
}


class KlBase extends MapObject {
  List<KlValue> values;
  List<KlRule> rules;

  KlBase({this.values, this.rules});
  factory KlBase.fromJson(dynamic map) => KlBase()..read(map);

  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    values = assertTypeGet<List>(map, 'values').map((e) => KlValue.fromJson(e)).toList();
    rules = assertTypeGet<List>(map, 'rules').map((e) => KlRule.fromJson(e)).toList();
  }

  /// Serializes this knowledge base to a map object
  Map<String, dynamic> toJson() => {
    'values': values.map((e) => e.toJson()).toList(),
    'rules': rules.map((e) => e.toJson()).toList(),
  };
}