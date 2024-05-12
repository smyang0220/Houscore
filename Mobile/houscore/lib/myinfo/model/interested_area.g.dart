// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interested_area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestedAreaModel _$InterestedAreaModelFromJson(Map<String, dynamic> json) =>
    InterestedAreaModel(
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      areaId: (json['areaId'] as num).toInt(),
      memberId: json['memberId'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$InterestedAreaModelToJson(
        InterestedAreaModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'areaId': instance.areaId,
      'memberId': instance.memberId,
      'address': instance.address,
    };
