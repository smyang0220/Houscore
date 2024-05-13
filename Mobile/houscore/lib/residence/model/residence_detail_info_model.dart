import 'package:json_annotation/json_annotation.dart';

part 'residence_detail_info_model.g.dart';  // JSON serialization을 위한 부분

@JsonSerializable()
class ResidenceDetailInfoModel {
  final Id id;
  final double score; // ai평가 점수
  final double lat; // 위도
  final double lng; // 경도
  final String platPlc; // 지번
  final String newPlatPlc; // 도로명
  final BuildingInfo buildingInfo; // 상세건물지표

  ResidenceDetailInfoModel({
    required this.id,
    required this.score,
    required this.lat,
    required this.lng,
    required this.platPlc,
    required this.newPlatPlc,
    required this.buildingInfo,
  });

  // JSON에서 ResidenceDetailInfoModel 객체로 변환
  factory ResidenceDetailInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ResidenceDetailInfoModelFromJson(json);

  // ResidenceDetailInfoModel 객체를 JSON으로 변환
  Map<String, dynamic> toJson() => _$ResidenceDetailInfoModelToJson(this);
}

// Id 클래스를 위한 JsonSerializable
@JsonSerializable()
class Id {
  final int timestamp;  // 타임스탬프
  final DateTime date;  // 생성 날짜 및 시간

  Id({required this.timestamp, required this.date});

  factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);
  Map<String, dynamic> toJson() => _$IdToJson(this);
}

@JsonSerializable()
class BuildingInfo {
  final double platArea; // 대지 면적 (평방미터)
  final double archArea; // 건축 면적 (평방미터)
  final double totArea; // 총 면적 (평방미터)
  final double bcRat; // 건폐율 (%)
  final double vlRat; // 용적률 (%)
  final String mainPurpsCdNm; // 주요 용도 코드명
  final int regstrKindCd; // 등기 종류 코드, 건물 등기의 법적 분류를 나타냄
  final String regstrKindCdNm; // 등기 종류 코드명
  final int hhldCnt; // 세대 수
  final int mainBldCnt; // 주 건물 수
  final int totPkngCnt; // 총 주차 공간 수


  BuildingInfo({
    required this.platArea,
    required this.archArea,
    required this.totArea,
    required this.bcRat,
    required this.vlRat,
    required this.mainPurpsCdNm,
    required this.regstrKindCd,
    required this.regstrKindCdNm,
    required this.hhldCnt,
    required this.mainBldCnt,
    required this.totPkngCnt,
  });

  factory BuildingInfo.fromJson(Map<String, dynamic> json) => _$BuildingInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingInfoToJson(this);
}
