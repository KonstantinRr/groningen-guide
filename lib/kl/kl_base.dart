import 'package:groningen_guide/kl/kl_endpoint.dart';
/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

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
  /// Stores the list of potential endpoints
  List<KlEndpoint> endpoints;

  /// Creates a zero initalized knowledge base. All members are null
  KlBase.zero();

  /// Creates a new knowledge base by supplying the member variables
  KlBase({List<KlVariable> values, List<KlRule> rules,
    List<KlQuestion> questions, List<KlEndpoint> endpoints}) :
    values = values ?? [],
    rules = rules ?? [],
    questions = questions ?? [],
    endpoints = endpoints ?? [];
  
  /// Creates a new question option using a JSON deserialized object
  factory KlBase.fromJson(dynamic map) => KlBase.zero()..read(map);

  /// Reads the knowledge base object using a JSON deserialized object
  @override
  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    values = assertTypeGetList<KlVariable>(map, 'values', converter: (e) => KlVariable.fromJson(map));
    rules = assertTypeGetList<KlRule>(map, 'rules', converter: (e) => KlRule.fromJson(e));
    questions = assertTypeGetList<KlQuestion>(map, 'questions', converter: (e) => KlQuestion.fromJson(e));
    endpoints = assertTypeGetList<KlEndpoint>(map, 'endpoints', converter: (e) => KlEndpoint.fromJson(e));
  }

  /// Serializes this knowledge base to a map object
  @override
  Map<String, dynamic> toJson() => {
    'values': values?.map((e) => e?.toJson())?.toList(),
    'rules': rules?.map((e) => e?.toJson())?.toList(),
    'questions': questions?.map((e) => e?.toJson())?.toList(),
    'endpoints': endpoints?.map((e) => e?.toJson())?.toList()
  };

  @override
  String toString() => 'KlBase['
    'values:${values?.length},rules:${rules?.length},'
    'questions:${questions?.length},endpoint:${endpoints?.length}]';
}