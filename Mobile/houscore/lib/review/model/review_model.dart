import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final String createdAt;
  final String updatedAt;
  final int id;
  final String memberId;
  final int buildingId;
  final String address;
  final int year;
  final String residenceFloor;
  final StarRating starRating;
  final String pros;
  final String cons;
  final String maintenanceCost;
  final String images;

  ReviewModel({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.memberId,
    required this.buildingId,
    required this.address,
    required this.year,
    required this.residenceFloor,
    required this.starRating,
    required this.pros,
    required this.cons,
    required this.maintenanceCost,
    required this.images,
});

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

@JsonSerializable()
class StarRating {
  final double traffic;
  final double building;
  final double inside;
  final double infra;
  final double security;

  StarRating({
   required this.building,
   required this.infra,
   required this.inside,
   required this.security,
   required this.traffic,
});

  factory StarRating.fromJson(Map<String, dynamic> json) => _$StarRatingFromJson(json);

  Map<String, dynamic> toJson() => _$StarRatingToJson(this);
}
