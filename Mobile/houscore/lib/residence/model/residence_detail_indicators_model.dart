import 'package:json_annotation/json_annotation.dart';

part 'residence_detail_indicators_model.g.dart';

enum InfraType {
  // nearby_infra에서 활용할 병원 / 공원 / 학교
  medicalFacilities,
  park,
  school,
  // nearby_public_transportation에서 활용할 버스 / 지하철
  bus,
  subway,
  // nearby_living_facilities에서 활용할 도서관 / 대형마트
  library,
  supermarket
}

@JsonSerializable()
class ResidenceDetailIndicatorsModel {
  final Infras infras;
  final PublicTransport publicTransport;
  final RealCost realCost;
  final int pricePerPyeong;
  final int safetyGrade;

  ResidenceDetailIndicatorsModel({
    required this.infras,
    required this.publicTransport,
    required this.realCost,
    required this.pricePerPyeong,
    required this.safetyGrade,
  });

  factory ResidenceDetailIndicatorsModel.fromJson(Map<String, dynamic> json) =>
      _$ResidenceDetailIndicatorsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResidenceDetailIndicatorsModelToJson(this);
}

@JsonSerializable()
class Infras {
  List<Infra> medicalFacilities;
  List<Infra> park;
  List<Infra> school;
  List<Infra> library;
  List<Infra> supermarket;

  Infras({
    required this.medicalFacilities,
    required this.park,
    required this.school,
    required this.library,
    required this.supermarket,
  });

  factory Infras.fromJson(Map<String, dynamic> json) {
    return Infras(
      medicalFacilities: (json['medicalFacilities'] as List).map((e) => Infra.fromJson(e..['type'] = 'medicalFacilities')).toList(),
      park: (json['park'] as List).map((e) => Infra.fromJson(e..['type'] = 'park')).toList(),
      school: (json['school'] as List).map((e) => Infra.fromJson(e..['type'] = 'school')).toList(),
      library: (json['library'] as List).map((e) => Infra.fromJson(e..['type'] = 'library')).toList(),
      supermarket: (json['supermarket'] as List).map((e) => Infra.fromJson(e..['type'] = 'supermarket')).toList(),
    );
  }

  Map<String, dynamic> toJson() => _$InfrasToJson(this);
}

@JsonSerializable()
class PublicTransport {
  List<Infra> bus;
  List<Infra> subway;

  PublicTransport({
    required this.bus,
    required this.subway,
  });

  factory PublicTransport.fromJson(Map<String, dynamic> json) {
    return PublicTransport(
      bus: (json['bus'] as List).map((e) => Infra.fromJson(e..['type'] = 'bus')).toList(),
      subway: (json['subways'] as List).map((e) => Infra.fromJson(e..['type'] = 'subway')).toList(),
    );
  }

  Map<String, dynamic> toJson() => _$PublicTransportToJson(this);
}

@JsonSerializable()
class RealCost {
  final double? buy;
  final double? longterm;
  final String? monthly;

  RealCost({
    this.buy,
    this.longterm,
    this.monthly,
  });

  factory RealCost.fromJson(Map<String, dynamic> json) =>
      _$RealCostFromJson(json);

  Map<String, dynamic> toJson() => _$RealCostToJson(this);
}

@JsonSerializable()
class Infra {
  final String name;
  final double distance;
  final InfraType type;

  Infra({
    required this.name,
    required this.distance,
    required this.type,
  });

  factory Infra.fromJson(Map<String, dynamic> json) =>
      _$InfraFromJson(json);

  Map<String, dynamic> toJson() => _$InfraToJson(this);
}
