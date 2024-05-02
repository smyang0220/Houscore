import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/building/repository/building_repository.dart';

import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';

final buildingProvider =
StateNotifierProvider<BuildingStateNotifier, CursorPaginationBase>(
      (ref) {
    final repository = ref.watch(buildingRepositoryProvider);

    final notifier = BuildingStateNotifier(repository: repository);

    return notifier;
  },
);

class BuildingStateNotifier extends StateNotifier<CursorPaginationBase> {
  final BuildingRepository repository;

  BuildingStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  void paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try{
      print('페이지네이션');
      // 5가지 가능성
      // State의 상태
      // [상태가]
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을때

      // 바로 반환하는 상황
      // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // 2) 로딩중 - fetchMore: true
      //    fetchMore가 아닐때 - 새로고침의 의도가 있을 수 있다.

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // fetchMore
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          data: pState.data,
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이털르 보존한채로 Fetch (API 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state = CursorPaginationRefetching(
            data: pState.data,
          );
        }
        // 나미저 상황
        else {
          state = CursorPaginationLoading();
        }
      }

      print("스토리지 키값");
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      print(token);
      print("통신전");
      final resp = await repository.getBuildingDetail(address: '서울특별시 강동구 천호대로 1121');
      print("통신후");
      state = resp;
    }catch(e){
      print("에러잡기");
      print(e);
      state = CursorPaginationError(message: e.toString());
    }
  }
}
