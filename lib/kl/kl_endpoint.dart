/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:groningen_guide/kl/kl_helpers.dart';

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

  KlEndpoint({this.name, this.description, this.conditions});

  factory KlEndpoint.fromJson(dynamic map) => KlEndpoint()..read(map);

  @override
  void read(dynamic map) {
    assertType<Map<String, dynamic>>(map);
    name = assertTypeGet<String>(map, "name");
    description = assertTypeGet<String>(map, "description");
    conditions = assertTypeGet<List>(map, 'conditions')
      .map<String>((e) => e as String).toList();
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
