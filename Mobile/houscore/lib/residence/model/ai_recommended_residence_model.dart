import 'package:json_annotation/json_annotation.dart';

part 'ai_recommended_residence_model.g.dart';

// AI 추천 거주지
@JsonSerializable()
class AiRecommendedResidenceModel {
  final String address;
  final double aiScore;
  final int realPrice;
  final int pricePerPyeong;
  final double pricePerRegion;
  final int reviewCnt;

  AiRecommendedResidenceModel({
    required this.address,
    required this.aiScore,
    required this.realPrice,
    required this.pricePerPyeong,
    required this.pricePerRegion,
    required this.reviewCnt,
  });

  // JSON에서 객체로
  factory AiRecommendedResidenceModel.fromJson(Map<String, dynamic> json) => _$AiRecommendedResidenceModelFromJson(json);

  // 객체에서 JSON으로
  Map<String, dynamic> toJson() => _$AiRecommendedResidenceModelToJson(this);
}
