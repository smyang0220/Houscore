import 'package:json_annotation/json_annotation.dart';

part 'nearby_infra_model.g.dart'; // `build_runner`가 생성할 파일

enum InfraType {
  hospital,
  park,
  school
}

class InfraTypeConverter implements JsonConverter<InfraType, String> {
  const InfraTypeConverter();

  @override
  InfraType fromJson(String json) {
    return InfraType.values.firstWhere((e) => e.toString().split('.').last == json);
  }

  @override
  String toJson(InfraType object) => object.toString().split('.').last;
}

// `Infra` 클래스 정의
@JsonSerializable()
@InfraTypeConverter()
class Infra {
  final String name;
  final int minutes;
  final double distance;
  final InfraType type;

  Infra({
    required this.name,
    required this.minutes,
    required this.distance,
    required this.type,
  });

  // JSON에서 `Infra` 객체로
  factory Infra.fromJson(Map<String, dynamic> json) => _$InfraFromJson(json);

  // `Infra` 객체에서 JSON으로
  Map<String, dynamic> toJson() => _$InfraToJson(this);
}
