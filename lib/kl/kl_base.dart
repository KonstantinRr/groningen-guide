


import 'package:groningen_guide/kl/kl_helpers.dart';
import 'package:groningen_guide/kl/kl_question.dart';
import 'package:groningen_guide/kl/kl_rule.dart';
import 'package:groningen_guide/kl/kl_variable.dart';

/// Specific Knowledge Base implementations ///

/// This class contains the combined knowledge base. A knowledge base
/// consists of a set of initial variables, questions to gain information
/// and rules
class KlBase extends MapObject {
  /// Stores the list of initial variables
  List<KlVariable> values;
  /// Stores the list of rules to infere values
  List<KlRule> rules;
  /// Stores the list of questions to gain information
  List<KlQuestion> questions;

  /// Creates a new knowledge base by supplying the member variables
  KlBase({this.values, this.rules, this.questions});
  /// Creates a new question option using a JSON deserialized object
  factory KlBase.fromJson(dynamic map) => KlBase()..read(map);

  /// Reads the knowledge base object using a JSON deserialized object
  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    values = assertTypeGet<List>(map, 'values').map((e) => KlVariable.fromJson(e)).toList();
    rules = assertTypeGet<List>(map, 'rules').map((e) => KlRule.fromJson(e)).toList();
    questions = assertTypeGet<List>(map, 'rules').map((e) => KlQuestion.fromJson(e)).toList();
  }

  /// Serializes this knowledge base to a map object
  Map<String, dynamic> toJson() => {
    'values': values.map((e) => e.toJson()).toList(),
    'rules': rules.map((e) => e.toJson()).toList(),
    'questions': questions.map((e) => e.toJson()).toList()
  };
}