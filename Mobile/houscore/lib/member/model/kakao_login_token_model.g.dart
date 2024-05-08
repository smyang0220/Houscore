// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_login_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KakaoLoginTokenModel _$KakaoLoginTokenModelFromJson(
        Map<String, dynamic> json) =>
    KakaoLoginTokenModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$KakaoLoginTokenModelToJson(
        KakaoLoginTokenModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
