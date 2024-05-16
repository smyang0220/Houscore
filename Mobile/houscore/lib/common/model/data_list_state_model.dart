import 'package:json_annotation/json_annotation.dart';

part 'data_list_state_model.g.dart';

abstract class DataListStateBase {}

// 에러 발생
class DataListStateError extends DataListStateBase {
  final String message;

  DataListStateError({
    required this.message,
  });
}

// 로딩 중
class DataListStateLoading extends DataListStateBase {}

// 성공한 경우
@JsonSerializable(
  genericArgumentFactories: true,
)
class DataListState<T> extends DataListStateBase {
  final List<T> data;

  DataListState({
    required this.data,
  });

  DataListState copyWith({
    List<T> ? data,
  }) {
    return DataListState<T>(
      data: data ?? this.data,
    );
  }

  factory DataListState.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$DataListStateFromJson(json, fromJsonT);
}
