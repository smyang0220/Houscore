import 'package:json_annotation/json_annotation.dart';

part 'user_validation.g.dart';

@JsonSerializable()
class UserValidation {
  final String message;

  UserValidation({required this.message});

  // JSON에서 UserValidation 객체로 변환하는 공장 생성자
  factory UserValidation.fromJson(Map<String, dynamic> json) => _$UserValidationFromJson(json);

  // UserValidation 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$UserValidationToJson(this);
}
