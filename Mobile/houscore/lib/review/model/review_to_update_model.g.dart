// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_to_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewToUpdateModel _$ReviewToUpdateModelFromJson(Map<String, dynamic> json) =>
    ReviewToUpdateModel(
      id: (json['id'] as num).toInt(),
      address: json['address'] as String,
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

Map<String, dynamic> _$ReviewToUpdateModelToJson(
        ReviewToUpdateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'residenceType': instance.residenceType,
      'residenceFloor': instance.residenceFloor,
      'starRating': instance.starRating,
      'pros': instance.pros,
      'cons': instance.cons,
      'maintenanceCost': instance.maintenanceCost,
      'images': instance.images,
      'residenceYear': instance.residenceYear,
    };
