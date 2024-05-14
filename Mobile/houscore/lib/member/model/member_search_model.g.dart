// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberSearchModel _$MemberSearchModelFromJson(Map<String, dynamic> json) =>
    MemberSearchModel(
      memberEmail: json['memberEmail'] as String,
      memberName: json['memberName'] as String,
      profileImage: json['profileImage'] as String,
    );

Map<String, dynamic> _$MemberSearchModelToJson(MemberSearchModel instance) =>
    <String, dynamic>{
      'memberEmail': instance.memberEmail,
      'memberName': instance.memberName,
      'profileImage': instance.profileImage,
    };
