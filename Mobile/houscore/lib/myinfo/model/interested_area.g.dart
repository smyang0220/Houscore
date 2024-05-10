// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interested_area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestedArea _$InterestedAreaFromJson(Map<String, dynamic> json) =>
    InterestedArea(
      areaId: (json['areaId'] as num).toInt(),
      address: json['address'] as String,
    );

Map<String, dynamic> _$InterestedAreaToJson(InterestedArea instance) =>
    <String, dynamic>{
      'areaId': instance.areaId,
      'address': instance.address,
    };
