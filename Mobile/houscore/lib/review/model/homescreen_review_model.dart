import 'package:json_annotation/json_annotation.dart';

part 'homescreen_review_model.g.dart';

@JsonSerializable()
class HomescreenReviewModel {
  final String? buildingName;
  final String address;
  final String pros;
  final String cons;
  final double reviewScore;
  final double aiScore;
  final String imageUrl;


  HomescreenReviewModel(
      {
        this.buildingName,
      required this.address,
      required this.pros,
      required this.cons,
      required this.reviewScore,
      required this.aiScore,
      required this.imageUrl});

  factory HomescreenReviewModel.fromJson(Map<String, dynamic> json)
  => _$HomescreenReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomescreenReviewModelToJson(this);
}
