// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_recommended_residence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiRecommendedResidenceModel _$AiRecommendedResidenceModelFromJson(
        Map<String, dynamic> json) =>
    AiRecommendedResidenceModel(
      address: json['address'] as String,
      aiScore: (json['aiScore'] as num).toDouble(),
      realPrice: (json['realPrice'] as num).toInt(),
      pricePerPyeong: (json['pricePerPyeong'] as num).toInt(),
      pricePerRegion: (json['pricePerRegion'] as num).toDouble(),
      reviewCnt: (json['reviewCnt'] as num).toInt(),
    );

Map<String, dynamic> _$AiRecommendedResidenceModelToJson(
        AiRecommendedResidenceModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'aiScore': instance.aiScore,
      'realPrice': instance.realPrice,
      'pricePerPyeong': instance.pricePerPyeong,
      'pricePerRegion': instance.pricePerRegion,
      'reviewCnt': instance.reviewCnt,
    };
