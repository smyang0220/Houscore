// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyReviewModel _$MyReviewModelFromJson(Map<String, dynamic> json) =>
    MyReviewModel(
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      id: (json['id'] as num).toInt(),
      memberId: json['memberId'] as String,
      address: json['address'] as String,
      residenceType: json['residenceType'] as String,
      year: json['year'] as String,
      residenceFloor: json['residenceFloor'] as String,
      starRating:
          StarRating.fromJson(json['starRating'] as Map<String, dynamic>),
      pros: json['pros'] as String,
      cons: json['cons'] as String,
      maintenanceCost: json['maintenanceCost'] as String,
      images: json['images'] as String?,
      starRatingAverage: (json['starRatingAverage'] as num).toDouble(),
    );

Map<String, dynamic> _$MyReviewModelToJson(MyReviewModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'id': instance.id,
      'memberId': instance.memberId,
      'address': instance.address,
      'residenceType': instance.residenceType,
      'year': instance.year,
      'residenceFloor': instance.residenceFloor,
      'starRating': instance.starRating,
      'pros': instance.pros,
      'cons': instance.cons,
      'maintenanceCost': instance.maintenanceCost,
      'images': instance.images,
      'starRatingAverage': instance.starRatingAverage,
    };
