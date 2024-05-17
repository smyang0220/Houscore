// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_list_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataListParams _$DataListParamsFromJson(Map<String, dynamic> json) =>
    DataListParams(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DataListParamsToJson(DataListParams instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
