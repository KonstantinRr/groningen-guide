/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:groningen_guide/kl/kl_helpers.dart';

/// ---- Specific Knowledge Base implementations ---- ///

/// This class represents an endpoint in the knowledge base.
class KlEndpoint extends MapObject {
  /// The endpoint's unique name
  String name;
  /// The endpoint's description
  String description;
  /// The conditions needed to trigger this endpoint
  List<String> conditions;
  /// The optional endpoint's image
  String image;

  /// Creates an empty endpoint where all members are null.
  KlEndpoint.zero();

  /// Creates an endpoint using the supplied parameters
  KlEndpoint({String name, String description,
    String image, List<String> conditions}) :
    conditions = conditions ?? [];

  /// Creates an endpoint by parsing the data from a JSON file
  factory KlEndpoint.fromJson(dynamic map) => KlEndpoint.zero()..read(map);

  @override
  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    name = assertTypeGet<String>(map, 'name', allowNull: true);
    description = assertTypeGet<String>(map, 'description', allowNull: true);
    conditions = assertTypeGetList<String>(map, 'conditions', converter: (e) => e as String);
    image = assertTypeGet<String>(map, 'image', allowNull: true);
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'conditions': conditions,
    'image': image,
  };
}
