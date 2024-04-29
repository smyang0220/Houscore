// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'residence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidenceModel _$ResidenceModelFromJson(Map<String, dynamic> json) =>
    ResidenceModel(
      address: json['address'] as String,
      aiScore: (json['aiScore'] as num).toDouble(),
      categoryScores: CategoryScores.fromJson(
          json['categoryScores'] as Map<String, dynamic>),
      transactionPrice: (json['transactionPrice'] as num).toInt(),
      pricePerPyeong: (json['pricePerPyeong'] as num).toInt(),
      priceGapFromNearby: (json['priceGapFromNearby'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
    );

Map<String, dynamic> _$ResidenceModelToJson(ResidenceModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'aiScore': instance.aiScore,
      'categoryScores': instance.categoryScores,
      'transactionPrice': instance.transactionPrice,
      'pricePerPyeong': instance.pricePerPyeong,
      'priceGapFromNearby': instance.priceGapFromNearby,
      'reviewCount': instance.reviewCount,
    };

CategoryScores _$CategoryScoresFromJson(Map<String, dynamic> json) =>
    CategoryScores(
      transportation: (json['transportation'] as num).toDouble(),
      building: (json['building'] as num).toDouble(),
      safety: (json['safety'] as num).toDouble(),
      location: (json['location'] as num).toDouble(),
      education: (json['education'] as num).toDouble(),
    );

Map<String, dynamic> _$CategoryScoresToJson(CategoryScores instance) =>
    <String, dynamic>{
      'transportation': instance.transportation,
      'building': instance.building,
      'safety': instance.safety,
      'location': instance.location,
      'education': instance.education,
    };
