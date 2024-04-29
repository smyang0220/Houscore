// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_public_transportation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicTransport _$PublicTransportFromJson(Map<String, dynamic> json) =>
    PublicTransport(
      name: json['name'] as String,
      distance: (json['distance'] as num).toDouble(),
      busOrSubway: json['busOrSubway'] as bool,
    );

Map<String, dynamic> _$PublicTransportToJson(PublicTransport instance) =>
    <String, dynamic>{
      'name': instance.name,
      'distance': instance.distance,
      'busOrSubway': instance.busOrSubway,
    };
