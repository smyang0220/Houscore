import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../residence/model/pagination_params.dart';
import '../model/cursor_pagination_model.dart';
import '../model/model_with_id.dart';
import '../repository/base_pagination_repository.dart';

class PaginationProvider<T extends IModelWithId,
U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final PaginationParams params;
  PaginationProvider({
    required this.repository,
    required this.params,
  }) : super(CursorPaginationLoading()){
    paginate();
  }

  Future<void> paginate({
    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
    int? page = 0
  }) async {
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (pState.meta.count <= pState.data.length) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      print("파라미터로 들어가는 page값 : $params.page");

      PaginationParams paginationParams = PaginationParams(
        address: params.address,
        size: params.size,
        page: 0,
      );

      // fetchMore
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination<T>;
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        await Future.delayed(Duration(seconds: 1));

        paginationParams = paginationParams.copyWith(
          page : page
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이털르 보존한채로 Fetch (API 요청)를 진행
        if (state is CursorPagination && forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
          await Future.delayed(Duration(seconds: 1));

        }
        // 나미저 상황
        else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      print(resp);
      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // 기존 데이터에
        // 새로운 데이터 추가
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}