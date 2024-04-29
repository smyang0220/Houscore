// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_infra_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Infra _$InfraFromJson(Map<String, dynamic> json) => Infra(
      name: json['name'] as String,
      minutes: (json['minutes'] as num).toInt(),
      distance: (json['distance'] as num).toDouble(),
      hospitalOrPark: json['hospitalOrPark'] as bool,
    );

Map<String, dynamic> _$InfraToJson(Infra instance) => <String, dynamic>{
      'name': instance.name,
      'minutes': instance.minutes,
      'distance': instance.distance,
      'hospitalOrPark': instance.hospitalOrPark,
    };
