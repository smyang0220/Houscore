// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'residence_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidenceDetailModel _$ResidenceDetailModelFromJson(
        Map<String, dynamic> json) =>
    ResidenceDetailModel(
      id: (json['id'] as num).toInt(),
      score: (json['score'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      platPlc: json['platPlc'] as String,
      newPlatPlc: json['newPlatPlc'] as String,
      buildingInfo:
          BuildingInfo.fromJson(json['buildingInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResidenceDetailModelToJson(
        ResidenceDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'score': instance.score,
      'lat': instance.lat,
      'lng': instance.lng,
      'platPlc': instance.platPlc,
      'newPlatPlc': instance.newPlatPlc,
      'buildingInfo': instance.buildingInfo,
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
