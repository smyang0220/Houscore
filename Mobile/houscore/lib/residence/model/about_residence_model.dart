import 'package:json_annotation/json_annotation.dart';

part 'about_residence_model.g.dart'; // 자동 생성될 파일

// 거주지 정보
@JsonSerializable()
class AboutResidenceModel {
  final double? primarySchoolDistance; // 초등학교와의 거리 (null 가능)
  final double? middleSchoolDistance; // 중학교와의 거리 (null 가능)
  final int? safetyGrade; // 안전등급 (null 가능)

  AboutResidenceModel({
    this.primarySchoolDistance,
    this.middleSchoolDistance,
    this.safetyGrade,
  });

  // JSON에서 객체로
  factory AboutResidenceModel.fromJson(Map<String, dynamic> json) => _$AboutResidenceModelFromJson(json);

  // 객체에서 JSON으로
  Map<String, dynamic> toJson() => _$AboutResidenceModelToJson(this);
}
