import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final String address;
  final double lat;
  final double lng;
  final String residenceType;
  final String residenceFloor;
  final StarRating starRating;
  final String pros;
  final String cons;
  final String maintenanceCost;
  final String? images;
  final String residenceYear;

  ReviewModel({
    required this.address,
    required this.lat,
    required this.lng,
    required this.residenceType,
    required this.residenceFloor,
    required this.starRating,
    required this.pros,
    required this.cons,
    required this.maintenanceCost,
    this.images,
    required this.residenceYear,
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
