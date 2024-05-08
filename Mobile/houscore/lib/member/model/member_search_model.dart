import 'package:json_annotation/json_annotation.dart';

part 'member_search_model.g.dart';

@JsonSerializable()
class MemberSearchModel {
  final String memberEmail;
  final String memberName;
  final String profileImage;

  MemberSearchModel({
    required this.memberEmail,
    required this.memberName,
    required this.profileImage,
  });

  factory MemberSearchModel.fromJson(Map<String, dynamic> json) => _$MemberSearchModelFromJson(json);

}