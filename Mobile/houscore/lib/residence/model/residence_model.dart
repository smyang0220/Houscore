import 'package:json_annotation/json_annotation.dart';

part 'residence_model.g.dart'; // 자동 생성될 파일

// 거주지
@JsonSerializable()
class ResidenceModel {
  final String address;
  final double aiScore;
  final CategoryScores categoryScores;
  final int transactionPrice;
  final int pricePerPyeong;
  final double priceGapFromNearby;
  final int reviewCount;

  ResidenceModel({
    required this.address,
    required this.aiScore,
    required this.categoryScores,
    required this.transactionPrice,
    required this.pricePerPyeong,
    required this.priceGapFromNearby,
    required this.reviewCount,
  });

  // JSON에서 객체로
  factory ResidenceModel.fromJson(Map<String, dynamic> json) => _$ResidenceModelFromJson(json);

  // 객체에서 JSON으로
  Map<String, dynamic> toJson() => _$ResidenceModelToJson(this);
}

// 카테고리 점수
@JsonSerializable()
class CategoryScores {
  final double transportation;
  final double building;
  final double safety;
  final double location;
  final double education;

  CategoryScores({
    required this.transportation,
    required this.building,
    required this.safety,
    required this.location,
    required this.education,
  });

  // JSON에서 객체로
  factory CategoryScores.fromJson(Map<String, dynamic> json) => _$CategoryScoresFromJson(json);

  // 객체에서 JSON으로
  Map<String, dynamic> toJson() => _$CategoryScoresToJson(this);
}
