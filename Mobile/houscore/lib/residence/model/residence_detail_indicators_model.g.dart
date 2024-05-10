// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'residence_detail_indicators_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidenceDetailIndicatorsModel _$ResidenceDetailIndicatorsModelFromJson(
        Map<String, dynamic> json) =>
    ResidenceDetailIndicatorsModel(
      infras: Infras.fromJson(json['infras'] as Map<String, dynamic>),
      publicTransport: PublicTransport.fromJson(
          json['publicTransport'] as Map<String, dynamic>),
      realCost: RealCost.fromJson(json['realCost'] as Map<String, dynamic>),
      pricePerPyeong: (json['pricePerPyeong'] as num).toInt(),
      safetyGrade: (json['safetyGrade'] as num).toInt(),
    );

Map<String, dynamic> _$ResidenceDetailIndicatorsModelToJson(
        ResidenceDetailIndicatorsModel instance) =>
    <String, dynamic>{
      'infras': instance.infras,
      'publicTransport': instance.publicTransport,
      'realCost': instance.realCost,
      'pricePerPyeong': instance.pricePerPyeong,
      'safetyGrade': instance.safetyGrade,
    };

Infras _$InfrasFromJson(Map<String, dynamic> json) => Infras(
      medicalFacilities: (json['medicalFacilities'] as List<dynamic>)
          .map((e) => Infra.fromJson(e as Map<String, dynamic>))
          .toList(),
      park: (json['park'] as List<dynamic>)
          .map((e) => Infra.fromJson(e as Map<String, dynamic>))
          .toList(),
      school: (json['school'] as List<dynamic>)
          .map((e) => Infra.fromJson(e as Map<String, dynamic>))
          .toList(),
      library: (json['library'] as List<dynamic>)
          .map((e) => Infra.fromJson(e as Map<String, dynamic>))
          .toList(),
      supermarket: (json['supermarket'] as List<dynamic>)
          .map((e) => Infra.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InfrasToJson(Infras instance) => <String, dynamic>{
      'medicalFacilities': instance.medicalFacilities,
      'park': instance.park,
      'school': instance.school,
      'library': instance.library,
      'supermarket': instance.supermarket,
    };

PublicTransport _$PublicTransportFromJson(Map<String, dynamic> json) =>
    PublicTransport(
      bus: (json['bus'] as List<dynamic>)
          .map((e) => Infra.fromJson(e as Map<String, dynamic>))
          .toList(),
      subway: (json['subway'] as List<dynamic>)
          .map((e) => Infra.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PublicTransportToJson(PublicTransport instance) =>
    <String, dynamic>{
      'bus': instance.bus,
      'subway': instance.subway,
    };

RealCost _$RealCostFromJson(Map<String, dynamic> json) => RealCost(
      buy: (json['buy'] as num?)?.toDouble(),
      longterm: (json['longterm'] as num?)?.toDouble(),
      monthly: json['monthly'] as String?,
    );

Map<String, dynamic> _$RealCostToJson(RealCost instance) => <String, dynamic>{
      'buy': instance.buy,
      'longterm': instance.longterm,
      'monthly': instance.monthly,
    };

Infra _$InfraFromJson(Map<String, dynamic> json) => Infra(
      name: json['name'] as String,
      distance: (json['distance'] as num).toDouble(),
      type: $enumDecode(_$InfraTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$InfraToJson(Infra instance) => <String, dynamic>{
      'name': instance.name,
      'distance': instance.distance,
      'type': _$InfraTypeEnumMap[instance.type]!,
    };

const _$InfraTypeEnumMap = {
  InfraType.medicalFacilities: 'medicalFacilities',
  InfraType.park: 'park',
  InfraType.school: 'school',
  InfraType.bus: 'bus',
  InfraType.subway: 'subway',
  InfraType.library: 'library',
  InfraType.supermarket: 'supermarket',
};
