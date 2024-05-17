import 'package:json_annotation/json_annotation.dart';

part 'data_list_params.g.dart';

@JsonSerializable()
class DataListParams {
  final double? lat;
  final double? lng;

  const DataListParams({
    this.lat,
    this.lng,
  });

  DataListParams copyWith({
    double? lat,
    double? lng,
  }) {
    return DataListParams(
      lat: lat,
      lng: lng,
    );
  }

  factory DataListParams.fromJson(Map<String, dynamic> json) =>
      _$DataListParamsFromJson(json);

  Map<String, dynamic> toJson() => _$DataListParamsToJson(this);
}