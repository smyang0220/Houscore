// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'star_rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StarRating _$StarRatingFromJson(Map<String, dynamic> json) => StarRating(
      building: (json['building'] as num).toDouble(),
      infra: (json['infra'] as num).toDouble(),
      inside: (json['inside'] as num).toDouble(),
      security: (json['security'] as num).toDouble(),
      traffic: (json['traffic'] as num).toDouble(),
    );

Map<String, dynamic> _$StarRatingToJson(StarRating instance) =>
    <String, dynamic>{
      'traffic': instance.traffic,
      'building': instance.building,
      'inside': instance.inside,
      'infra': instance.infra,
      'security': instance.security,
    };
