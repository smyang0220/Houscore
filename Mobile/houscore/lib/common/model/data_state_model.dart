import 'package:json_annotation/json_annotation.dart';

part 'data_state_model.g.dart';

abstract class DataStateBase {}

// 에러 발생
class DataStateError extends DataStateBase {
  final String message;

  DataStateError({
    required this.message,
  });
}

// 로딩 중
class DataStateLoading extends DataStateBase {}

// 성공한 경우
@JsonSerializable(
  genericArgumentFactories: true,
)
class DataState<T> extends DataStateBase {
  final T data;

  DataState({
    required this.data,
  });

  DataState copyWith({
    T ? data,
  }) {
    return DataState<T>(
      data: data ?? this.data,
    );
  }

  factory DataState.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$DataStateFromJson(json, fromJsonT);
}
