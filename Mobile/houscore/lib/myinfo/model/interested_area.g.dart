// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interested_area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestedAreaModel _$InterestedAreaModelFromJson(Map<String, dynamic> json) =>
    InterestedAreaModel(
      areaId: (json['areaId'] as num).toInt(),
      address: json['address'] as String,
    );

Map<String, dynamic> _$InterestedAreaModelToJson(
        InterestedAreaModel instance) =>
    <String, dynamic>{
      'areaId': instance.areaId,
      'address': instance.address,
    };
