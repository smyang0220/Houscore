import 'package:json_annotation/json_annotation.dart';

part 'nearby_public_transportation_model.g.dart'; // `build_runner`가 생성할 파일

// `PublicTransport` 클래스 정의
@JsonSerializable()
class PublicTransport {
  final String name;
  final double distance;
  @JsonKey(name: 'busOrSubway') // JSON 키 커스터마이징
  final bool busOrSubway; // true이면 버스, false이면 지하철

  PublicTransport({
    required this.name,
    required this.distance,
    required this.busOrSubway,
  });

  // JSON에서 `PublicTransport` 객체로
  factory PublicTransport.fromJson(Map<String, dynamic> json) =>
      _$PublicTransportFromJson(json);

  // `PublicTransport` 객체에서 JSON으로
  Map<String, dynamic> toJson() => _$PublicTransportToJson(this);
}
