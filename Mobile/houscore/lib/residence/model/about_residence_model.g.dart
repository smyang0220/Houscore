// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_residence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutResidenceModel _$AboutResidenceModelFromJson(Map<String, dynamic> json) =>
    AboutResidenceModel(
      primarySchoolDistance:
          (json['primarySchoolDistance'] as num?)?.toDouble(),
      middleSchoolDistance: (json['middleSchoolDistance'] as num?)?.toDouble(),
      safetyGrade: (json['safetyGrade'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AboutResidenceModelToJson(
        AboutResidenceModel instance) =>
    <String, dynamic>{
      'primarySchoolDistance': instance.primarySchoolDistance,
      'middleSchoolDistance': instance.middleSchoolDistance,
      'safetyGrade': instance.safetyGrade,
    };
