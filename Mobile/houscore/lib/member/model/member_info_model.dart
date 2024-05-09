import 'package:json_annotation/json_annotation.dart';

part 'member_info_model.g.dart';

@JsonSerializable()
class MemberInfo {
  final String email;
  final String profileImage;
  final String name;

  MemberInfo({
    required this.email,
    required this.profileImage,
    required this.name
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json)
  => _$MemberInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MemberInfoToJson(this);
}