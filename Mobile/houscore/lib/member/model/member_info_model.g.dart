// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberInfo _$MemberInfoFromJson(Map<String, dynamic> json) => MemberInfo(
      email: json['email'] as String,
      profileImage: json['profileImage'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$MemberInfoToJson(MemberInfo instance) =>
    <String, dynamic>{
      'email': instance.email,
      'profileImage': instance.profileImage,
      'name': instance.name,
    };
