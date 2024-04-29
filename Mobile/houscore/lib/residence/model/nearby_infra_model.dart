import 'package:json_annotation/json_annotation.dart';

part 'nearby_infra_model.g.dart'; // `build_runner`가 생성할 파일

// `Infra` 클래스 정의
@JsonSerializable()
class Infra {
  final String name;
  final int minutes;
  final double distance;
  @JsonKey(name: 'hospitalOrPark') // JSON 키 커스터마이징
  final bool hospitalOrPark; // 병원/공원 구분 플래그

  Infra({
    required this.name,
    required this.minutes,
    required this.distance,
    required this.hospitalOrPark,
  });

  // JSON에서 `Infra` 객체로
  factory Infra.fromJson(Map<String, dynamic> json) => _$InfraFromJson(json);

  // `Infra` 객체에서 JSON으로
  Map<String, dynamic> toJson() => _$InfraToJson(this);
}
