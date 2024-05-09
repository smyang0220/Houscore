import 'package:json_annotation/json_annotation.dart';

part 'residence_detail_model.g.dart';

@JsonSerializable()
class ResidenceDetailModel {
  final Id id;
  final double score;
  final double lat;
  final double lng;
  final String platPlc;
  final String newPlatPlc;
  final BuildingInfo buildingInfo;

  ResidenceDetailModel({
    required this.id,
    required this.score,
    required this.lat,
    required this.lng,
    required this.platPlc,
    required this.newPlatPlc,
    required this.buildingInfo,
  });

  factory ResidenceDetailModel.fromJson(Map<String, dynamic> json) => _$ResidenceDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResidenceDetailModelToJson(this);
}

@JsonSerializable()
class BuildingInfo {
  final double platArea;
  final double archArea;
  final double totArea;
  final double bcRat;
  final double vlRat;
  final String mainPurpsCdNm;
  final int regstrKindCd;
  final String regstrKindCdNm;
  final int hhldCnt;
  final int mainBldCnt;
  final int totPkngCnt;

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

@JsonSerializable()
class Id {
  final int timestamp;
  final String date;

  Id({
    required this.timestamp,
    required this.date,
  });

  factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);
  Map<String, dynamic> toJson() => _$IdToJson(this);
}
