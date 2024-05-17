import 'package:houscore/review/model/star_rating_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_to_update_model.g.dart';

@JsonSerializable()

//리뷰 수정 시의 DTO
class ReviewToUpdateModel {
  final int id;
  final String address;
  final String residenceType;
  final String residenceFloor;
  final StarRating starRating;
  final String pros;
  final String cons;
  final String maintenanceCost;
  final String? images;
  final String residenceYear;

  ReviewToUpdateModel({
    required this.id,
    required this.address,
    required this.residenceType,
    required this.residenceFloor,
    required this.starRating,
    required this.pros,
    required this.cons,
    required this.maintenanceCost,
    this.images,
    required this.residenceYear,
});

  factory ReviewToUpdateModel.fromJson(Map<String, dynamic> json) => _$ReviewToUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToUpdateModelToJson(this);
}
