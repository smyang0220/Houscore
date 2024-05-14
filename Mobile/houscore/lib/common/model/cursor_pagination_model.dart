import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

class CursorPaginationLoading extends CursorPaginationBase {}

// genericArgumentFactories옵션 : 제네릭 타입을 포함하는 복잡한 객체 구조에서 타입 정보를 유지하면서 JSON 변환을 처리
@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final List<T> data;

  CursorPagination({
    required this.data,
  });

  // 객체의 불변성 유지를 위한 부분
  CursorPagination copyWith({
    List<T>? data,
  }) {
    return CursorPagination(
      data: data ?? this.data,
    );
  }

  factory CursorPagination.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

// 새로고침 할때
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.data,
  });
}

// 리스트의 맨 아래로 내려서
// 추가 데이터를 요청하는중
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.data,
  });
}
