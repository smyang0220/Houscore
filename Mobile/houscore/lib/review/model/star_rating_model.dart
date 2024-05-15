import 'package:json_annotation/json_annotation.dart';

part 'star_rating_model.g.dart';

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