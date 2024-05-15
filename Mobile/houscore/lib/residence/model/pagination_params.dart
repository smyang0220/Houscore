import 'package:json_annotation/json_annotation.dart';

part 'pagination_params.g.dart';

@JsonSerializable()
class PaginationParams {
  final String? address;
  final int? page;
  final int? size;

  const PaginationParams({
    this.address,
    this.page,
    this.size,
  });

  PaginationParams copyWith({
    String? address,
    int? page,
    int? size,
  }) {
    return PaginationParams(
      address: address ?? this.address,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }

  factory PaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}