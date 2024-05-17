// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homescreen_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomescreenReviewModel _$HomescreenReviewModelFromJson(
        Map<String, dynamic> json) =>
    HomescreenReviewModel(
      buildingName: json['buildingName'] as String?,
      address: json['address'] as String,
      pros: json['pros'] as String,
      cons: json['cons'] as String,
      reviewScore: (json['reviewScore'] as num).toDouble(),
      aiScore: (json['aiScore'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$HomescreenReviewModelToJson(
        HomescreenReviewModel instance) =>
    <String, dynamic>{
      'buildingName': instance.buildingName,
      'address': instance.address,
      'pros': instance.pros,
      'cons': instance.cons,
      'reviewScore': instance.reviewScore,
      'aiScore': instance.aiScore,
      'imageUrl': instance.imageUrl,
    };
