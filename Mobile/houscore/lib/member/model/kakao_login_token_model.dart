import 'package:json_annotation/json_annotation.dart';

part 'kakao_login_token_model.g.dart';

@JsonSerializable()
class KakaoLoginTokenModel {
  final String accessToken;
  final String refreshToken;

  KakaoLoginTokenModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory KakaoLoginTokenModel.fromJson(Map<String, dynamic> json) => _$KakaoLoginTokenModelFromJson(json);
}