// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      id: (json['id'] as num).toInt(),
      memberId: json['memberId'] as String,
      buildingId: (json['buildingId'] as num).toInt(),
      address: json['address'] as String,
      year: (json['year'] as num).toInt(),
      residenceFloor: json['residenceFloor'] as String,
      starRating:
          StarRating.fromJson(json['starRating'] as Map<String, dynamic>),
      pros: json['pros'] as String,
      cons: json['cons'] as String,
      maintenanceCost: json['maintenanceCost'] as String,
      images: json['images'] as String,
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'id': instance.id,
      'memberId': instance.memberId,
      'buildingId': instance.buildingId,
      'address': instance.address,
      'year': instance.year,
      'residenceFloor': instance.residenceFloor,
      'starRating': instance.starRating,
      'pros': instance.pros,
      'cons': instance.cons,
      'maintenanceCost': instance.maintenanceCost,
      'images': instance.images,
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
