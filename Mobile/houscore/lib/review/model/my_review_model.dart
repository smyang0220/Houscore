import 'package:houscore/review/model/star_rating_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_review_model.g.dart';

@JsonSerializable()
class MyReviewModel {
  final String createdAt;
  final String updatedAt;
  final dynamic id;
  final String memberId;
  final String address;
  final String residenceType;
  final String year;
  final String residenceFloor;
  final StarRating starRating;
  final String pros;
  final String cons;
  final String maintenanceCost;
  final String? images;
  final double starRatingAverage;

  MyReviewModel({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.memberId,
    required this.address,
    required this.residenceType,
    required this.year,
    required this.residenceFloor,
    required this.starRating,
    required this.pros,
    required this.cons,
    required this.maintenanceCost,
    this.images,
    required this.starRatingAverage,

  });

  factory MyReviewModel.fromJson(Map<String, dynamic> json) => _$MyReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyReviewModelToJson(this);
}
