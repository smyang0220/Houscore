import 'package:json_annotation/json_annotation.dart';

import '../../common/model/model_with_id.dart';

part 'residence_main_photo_model.g.dart';

@JsonSerializable()
class ResidenceMainPhotoModel{
  final String buildingName;
  final String address;
  final String pros;
  final String cons;
  final double reviewScore;
  final double aiScore;
  final String imageUrl;

  ResidenceMainPhotoModel({
    required this.buildingName,
    required this.address,
    required this.pros,
    required this.cons,
    required this.reviewScore,
    required this.aiScore,
    required this.imageUrl,
  });

  factory ResidenceMainPhotoModel.fromJson(Map<String, dynamic> json) =>
      _$ResidenceMainPhotoModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResidenceMainPhotoModelToJson(this);
}