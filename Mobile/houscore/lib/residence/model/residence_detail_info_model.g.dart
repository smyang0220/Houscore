// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'residence_detail_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidenceDetailInfoModel _$ResidenceDetailInfoModelFromJson(
        Map<String, dynamic> json) =>
    ResidenceDetailInfoModel(
      id: Id.fromJson(json['id'] as Map<String, dynamic>),
      score: (json['score'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      platPlc: json['platPlc'] as String,
      newPlatPlc: json['newPlatPlc'] as String,
      buildingInfo:
          BuildingInfo.fromJson(json['buildingInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResidenceDetailInfoModelToJson(
        ResidenceDetailInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'score': instance.score,
      'lat': instance.lat,
      'lng': instance.lng,
      'platPlc': instance.platPlc,
      'newPlatPlc': instance.newPlatPlc,
      'buildingInfo': instance.buildingInfo,
    };

Id _$IdFromJson(Map<String, dynamic> json) => Id(
      timestamp: (json['timestamp'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$IdToJson(Id instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
      'date': instance.date.toIso8601String(),
    };

BuildingInfo _$BuildingInfoFromJson(Map<String, dynamic> json) => BuildingInfo(
      platArea: (json['platArea'] as num).toDouble(),
      archArea: (json['archArea'] as num).toDouble(),
      totArea: (json['totArea'] as num).toDouble(),
      bcRat: (json['bcRat'] as num).toDouble(),
      vlRat: (json['vlRat'] as num).toDouble(),
      mainPurpsCdNm: json['mainPurpsCdNm'] as String,
      regstrKindCd: (json['regstrKindCd'] as num).toInt(),
      regstrKindCdNm: json['regstrKindCdNm'] as String,
      hhldCnt: (json['hhldCnt'] as num).toInt(),
      mainBldCnt: (json['mainBldCnt'] as num).toInt(),
      totPkngCnt: (json['totPkngCnt'] as num).toInt(),
    );

Map<String, dynamic> _$BuildingInfoToJson(BuildingInfo instance) =>
    <String, dynamic>{
      'platArea': instance.platArea,
      'archArea': instance.archArea,
      'totArea': instance.totArea,
      'bcRat': instance.bcRat,
      'vlRat': instance.vlRat,
      'mainPurpsCdNm': instance.mainPurpsCdNm,
      'regstrKindCd': instance.regstrKindCd,
      'regstrKindCdNm': instance.regstrKindCdNm,
      'hhldCnt': instance.hhldCnt,
      'mainBldCnt': instance.mainBldCnt,
      'totPkngCnt': instance.totPkngCnt,
    };
