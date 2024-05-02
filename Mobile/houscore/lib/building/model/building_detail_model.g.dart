// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildingDetailModel _$BuildingDetailModelFromJson(Map<String, dynamic> json) =>
    BuildingDetailModel(
      id: (json['id'] as num).toInt(),
      score: (json['score'] as num).toDouble(),
      information: BuildingInformation.fromJson(
          json['information'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BuildingDetailModelToJson(
        BuildingDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'score': instance.score,
      'information': instance.information,
    };

BuildingInformation _$BuildingInformationFromJson(Map<String, dynamic> json) =>
    BuildingInformation(
      buildingInfo:
          BuildingInfo.fromJson(json['buildingInfo'] as Map<String, dynamic>),
      infraInfo: InfrastructureInfo.fromJson(
          json['infraInfo'] as Map<String, dynamic>),
      securityInfo:
          SecurityInfo.fromJson(json['securityInfo'] as Map<String, dynamic>),
      trafficInfo:
          TrafficInfo.fromJson(json['trafficInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BuildingInformationToJson(
        BuildingInformation instance) =>
    <String, dynamic>{
      'buildingInfo': instance.buildingInfo,
      'infraInfo': instance.infraInfo,
      'securityInfo': instance.securityInfo,
      'trafficInfo': instance.trafficInfo,
    };

BuildingInfo _$BuildingInfoFromJson(Map<String, dynamic> json) => BuildingInfo(
      mgmBldrgstPk: json['mgmBldrgstPk'] as String,
      platPlc: json['platPlc'] as String,
      newPlatPlc: json['newPlatPlc'] as String,
      etcPurps: json['etcPurps'] as String,
      mainPurpsCdNm: json['mainPurpsCdNm'] as String,
      mainAtchGbCdNm: json['mainAtchGbCdNm'] as String,
      hhldCnt: (json['hhldCnt'] as num).toInt(),
      heit: (json['heit'] as num).toDouble(),
      grndFlrCnt: (json['grndFlrCnt'] as num).toInt(),
      ugrndFlrCnt: (json['ugrndFlrCnt'] as num).toInt(),
      rideUseElvtCnt: (json['rideUseElvtCnt'] as num).toInt(),
      parkingCnt: (json['parkingCnt'] as num).toInt(),
      pmsDay: json['pmsDay'] as String,
      stcnsDay: json['stcnsDay'] as String,
      useAprDay: json['useAprDay'] as String,
      bldNm: json['bldNm'] as String,
      dongNm: json['dongNm'] as String,
      platArea: (json['platArea'] as num).toDouble(),
      archArea: (json['archArea'] as num).toDouble(),
      totArea: (json['totArea'] as num).toDouble(),
      bcRat: (json['bcRat'] as num).toDouble(),
      vlRat: (json['vlRat'] as num).toDouble(),
      strctCdNm: json['strctCdNm'] as String,
      rserthqkDsgnApplyYn: (json['rserthqkDsgnApplyYn'] as num).toInt(),
    );

Map<String, dynamic> _$BuildingInfoToJson(BuildingInfo instance) =>
    <String, dynamic>{
      'mgmBldrgstPk': instance.mgmBldrgstPk,
      'platPlc': instance.platPlc,
      'newPlatPlc': instance.newPlatPlc,
      'etcPurps': instance.etcPurps,
      'mainPurpsCdNm': instance.mainPurpsCdNm,
      'mainAtchGbCdNm': instance.mainAtchGbCdNm,
      'hhldCnt': instance.hhldCnt,
      'heit': instance.heit,
      'grndFlrCnt': instance.grndFlrCnt,
      'ugrndFlrCnt': instance.ugrndFlrCnt,
      'rideUseElvtCnt': instance.rideUseElvtCnt,
      'parkingCnt': instance.parkingCnt,
      'pmsDay': instance.pmsDay,
      'stcnsDay': instance.stcnsDay,
      'useAprDay': instance.useAprDay,
      'bldNm': instance.bldNm,
      'dongNm': instance.dongNm,
      'platArea': instance.platArea,
      'archArea': instance.archArea,
      'totArea': instance.totArea,
      'bcRat': instance.bcRat,
      'vlRat': instance.vlRat,
      'strctCdNm': instance.strctCdNm,
      'rserthqkDsgnApplyYn': instance.rserthqkDsgnApplyYn,
    };

InfrastructureInfo _$InfrastructureInfoFromJson(Map<String, dynamic> json) =>
    InfrastructureInfo(
      parkCnt: (json['parkCnt'] as num).toInt(),
    );

Map<String, dynamic> _$InfrastructureInfoToJson(InfrastructureInfo instance) =>
    <String, dynamic>{
      'parkCnt': instance.parkCnt,
    };

SecurityInfo _$SecurityInfoFromJson(Map<String, dynamic> json) => SecurityInfo(
      safetyGrade: (json['safetyGrade'] as num).toInt(),
    );

Map<String, dynamic> _$SecurityInfoToJson(SecurityInfo instance) =>
    <String, dynamic>{
      'safetyGrade': instance.safetyGrade,
    };

TrafficInfo _$TrafficInfoFromJson(Map<String, dynamic> json) => TrafficInfo(
      bus: (json['bus'] as num).toInt(),
      subway: (json['subway'] as num).toInt(),
    );

Map<String, dynamic> _$TrafficInfoToJson(TrafficInfo instance) =>
    <String, dynamic>{
      'bus': instance.bus,
      'subway': instance.subway,
    };
