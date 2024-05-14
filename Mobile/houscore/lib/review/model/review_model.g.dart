// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      residenceType: json['residenceType'] as String,
      residenceFloor: json['residenceFloor'] as String,
      starRating:
          StarRating.fromJson(json['starRating'] as Map<String, dynamic>),
      pros: json['pros'] as String,
      cons: json['cons'] as String,
      maintenanceCost: json['maintenanceCost'] as String,
      images: json['images'] as String?,
      residenceYear: json['residenceYear'] as String,
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'residenceType': instance.residenceType,
      'residenceFloor': instance.residenceFloor,
      'starRating': instance.starRating,
      'pros': instance.pros,
      'cons': instance.cons,
      'maintenanceCost': instance.maintenanceCost,
      'images': instance.images,
      'residenceYear': instance.residenceYear,
    };

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
