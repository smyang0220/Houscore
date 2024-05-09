// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class DataStateModel<T> {
//   final T? detail; // 실제 내용이 담김 => Provider에 따라서 제네릭으로 결정
//   final bool isLoading;
//   final String? errorMessage;
//
//   DataStateModel({this.detail, this.isLoading = false, this.errorMessage});
//
//   // 로딩
//   DataStateModel.loading()
//       : detail = null,
//         isLoading = true,
//         errorMessage = null;
//
//   // 에러
//   DataStateModel.error(this.errorMessage)
//       : detail = null,
//         isLoading = false;
//
//   // 성공
//   DataStateModel.success(this.detail)
//       : isLoading = false,
//         errorMessage = null;
// }

import 'package:json_annotation/json_annotation.dart';

part 'data_state_model.g.dart';

abstract class DataStateBase {}

class DataStateError extends DataStateBase {
  final String message;

  DataStateError({
    required this.message,
  });
}

class DataStateLoading extends DataStateBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class DataState<T> extends DataStateBase {
  final T data;

  DataState({
    required this.data,
  });

  DataState copyWith({
    T? data,
  }) {
    return DataState(
      data: data ?? this.data,
    );
  }

  factory DataState.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$DataStateFromJson(json, fromJsonT);
}

// 새로고침 할때
class DataStateRefetching<T> extends DataState<T> {
  DataStateRefetching({
    required super.data,
  });
}
