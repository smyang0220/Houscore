import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/building/repository/building_repository.dart';

import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';

/*
   StateNotifierProvider는
   다른 Provider(여기서는 'buildingRepositoryProvider')가 가져오는 데이터
   를 기반으로 상태를 관리하는 Provider

   그래서 buildingRepositoryProvider로부터의 값인 repository와
   BuildingStateNotifier를 생성 및 초기화 후 반환
*/
final buildingProvider =
StateNotifierProvider<BuildingStateNotifier, CursorPaginationBase>(
      (ref) {
    final repository = ref.watch(buildingRepositoryProvider);

    final notifier = BuildingStateNotifier(repository: repository);

    return notifier;
  },
);


class BuildingStateNotifier extends StateNotifier<CursorPaginationBase> {
  // 실제 데이터를 받아오는 retrofit 객체
  // API 호출 및 JsonSerializable를 활용한 모델 연동까지 자동화 + 오류처리
  final BuildingRepository repository;

  // repository객체를 필수적으로 요구하며 이는 buildingRepositoryProvider로부터 주입 받음
  // 이 때, 초기 상태로 CursorPaginationLoading()을 설정함
  // 그 후, 생성되면 데이터를 실제로 가져오고 상태를 업데이트하는 아래 paginate함수를 호출하게 됨!
  BuildingStateNotifier({required this.repository}) : super(CursorPaginationLoading()) {
    paginate();
  }

  void paginate({
    // 한 번에 가져오는 양
    int fetchCount = 20,

    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴 // false - 새로고침 (현재 상태를 덮어 씌움)
    bool fetchMore = false,

    // 강제로 다시 로딩하기 (캐시값이 있어도)
    // true - CursorPaginationLoading() // false - 캐시값이 있으면 새로 데이터 로드 X
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

      // [현재 데이터 로딩 상태 확인용 3가지]
      // 데이터 로딩 시작 but 미완료 상태 // 어플리케이션에의 첫 접속 또는 페이지 첫 접속
      final isLoading = state is CursorPaginationLoading;
      // 데이터 일부 로딩 완료 but 요청에 의한 새로운 업데이트 필요 상황 // 이미 로딩된 데이터를 새로 고침하려고 할 때
      final isRefetching = state is CursorPaginationRefetching;
      // 무한 스크롤 등에서 쓰이는 추가적인 데이터 로딩 필요 상황
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      // 사용자가 추가로 데이터를 요청했지만
      // 이미 loading / refetching / fetchMore 상태인 경우
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // fetchMore
      // 데이터를 추가로 더 가져와는 요청이 들어온 상황
      if (fetchMore) {
        // 현재의 state 객체를 CursorPagination 타입으로 타입-캐스팅
        // 이미 로딩이 완료된 상태일때만 추가로 요청하기 위함
        final pState = state as CursorPagination;

        // 기존의 데이터를 유지한채로 상태만 변경!
        state = CursorPaginationFetchingMore(
          data: pState.data,
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 데이터가 이미 있고, 캐시가 있어도 강제로 리페칭 해오는 상태가 아니라면
        // 기존 데이터를 보존한채로 Fetch (API 요청)를 진행하기 위한 설정
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state = CursorPaginationRefetching(
            data: pState.data,
          );
        }
        // 나머지 상황 // 데이터가 없는 상황 => 초기 상황 => isLoading
        else {
          state = CursorPaginationLoading();
        }
      }

      print("스토리지 키값");
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      print(token);
      print("통신전");
      // 받아올 데이터
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
