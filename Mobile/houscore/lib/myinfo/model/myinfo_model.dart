import 'package:json_annotation/json_annotation.dart';

part 'myinfo_model.g.dart';

@JsonSerializable()
class MyinfoModel {
  final String email;
  final String name;

  MyinfoModel({
    required this.email,
    required this.name
  });

  factory MyinfoModel.fromJson(Map<String, dynamic> json)
  => _$MyinfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyinfoModelToJson(this);
}