import 'package:json_annotation/json_annotation.dart';

import '../../common/model/model_with_id.dart';

part 'residence_review_model.g.dart';

@JsonSerializable()
class ResidenceReviewModel implements IModelWithId{
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

  ResidenceReviewModel({
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

  factory ResidenceReviewModel.fromJson(Map<String, dynamic> json) => _$ResidenceReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResidenceReviewModelToJson(this);
}

@JsonSerializable()
class StarRating {
  final double traffic;
  final double building;
  final double inside;
  final double infra;
  final double security;

  StarRating({
    required this.traffic,
    required this.building,
    required this.inside,
    required this.infra,
    required this.security,
  });

  factory StarRating.fromJson(Map<String, dynamic> json) => _$StarRatingFromJson(json);
  Map<String, dynamic> toJson() => _$StarRatingToJson(this);
}
