import 'package:json_annotation/json_annotation.dart';

part 'building_detail_model.g.dart';

@JsonSerializable()
class BuildingDetailModel {
  final int id;
  final double score;
  final BuildingInformation information;

  BuildingDetailModel({
    required this.id,
    required this.score,
    required this.information,
  });

  factory BuildingDetailModel.fromJson(Map<String, dynamic> json) => _$BuildingDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingDetailModelToJson(this);
}

@JsonSerializable()
class BuildingInformation {
  final BuildingInfo buildingInfo;
  final InfrastructureInfo infraInfo;
  final SecurityInfo securityInfo;
  final TrafficInfo trafficInfo;

  BuildingInformation({
    required this.buildingInfo,
    required this.infraInfo,
    required this.securityInfo,
    required this.trafficInfo,
  });

  factory BuildingInformation.fromJson(Map<String, dynamic> json) => _$BuildingInformationFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingInformationToJson(this);
}

@JsonSerializable()
class BuildingInfo {
  final String mgmBldrgstPk;
  final String platPlc;
  final String newPlatPlc;
  final String etcPurps;
  final String mainPurpsCdNm;
  final String mainAtchGbCdNm;
  final int hhldCnt;
  final double heit;
  final int grndFlrCnt;
  final int ugrndFlrCnt;
  final int rideUseElvtCnt;
  final int parkingCnt;
  final String pmsDay;
  final String stcnsDay;
  final String useAprDay;
  final String bldNm;
  final String dongNm;
  final double platArea;
  final double archArea;
  final double totArea;
  final double bcRat;
  final double vlRat;
  final String strctCdNm;
  final int rserthqkDsgnApplyYn;

  BuildingInfo({
    required this.mgmBldrgstPk,
    required this.platPlc,
    required this.newPlatPlc,
    required this.etcPurps,
    required this.mainPurpsCdNm,
    required this.mainAtchGbCdNm,
    required this.hhldCnt,
    required this.heit,
    required this.grndFlrCnt,
    required this.ugrndFlrCnt,
    required this.rideUseElvtCnt,
    required this.parkingCnt,
    required this.pmsDay,
    required this.stcnsDay,
    required this.useAprDay,
    required this.bldNm,
    required this.dongNm,
    required this.platArea,
    required this.archArea,
    required this.totArea,
    required this.bcRat,
    required this.vlRat,
    required this.strctCdNm,
    required this.rserthqkDsgnApplyYn,
  });

  factory BuildingInfo.fromJson(Map<String, dynamic> json) => _$BuildingInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingInfoToJson(this);
}

@JsonSerializable()
class InfrastructureInfo {
  final int parkCnt;

  InfrastructureInfo({required this.parkCnt});

  factory InfrastructureInfo.fromJson(Map<String, dynamic> json) => _$InfrastructureInfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfrastructureInfoToJson(this);
}

@JsonSerializable()
class SecurityInfo {
  final int safetyGrade;

  SecurityInfo({required this.safetyGrade});

  factory SecurityInfo.fromJson(Map<String, dynamic> json) => _$SecurityInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SecurityInfoToJson(this);
}

@JsonSerializable()
class TrafficInfo {
  final int bus;
  final int subway;

  TrafficInfo({
    required this.bus,
    required this.subway,
  });

  factory TrafficInfo.fromJson(Map<String, dynamic> json) => _$TrafficInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TrafficInfoToJson(this);
}
