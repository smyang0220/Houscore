import 'package:flutter/material.dart';
import 'package:houscore/building/provider/building_detatil_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/model/cursor_pagination_model.dart';

// 1. ConsumerStatefulWidget 을 사용하면 정의해둔 State가 변할 때 마다 자동으로 UI가 재빌드 - Riverpod과 연동된 view라는 뜻
class ApiTestScreen extends ConsumerStatefulWidget {
  const ApiTestScreen({super.key});

  @override
  ConsumerState<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends ConsumerState<ApiTestScreen> {
  // 2. 스크롤 컨트롤러 정의
  final ScrollController controller = ScrollController();

  // 3. initState 단계에서 스크롤 위치에 따라서 데이터를 로드하는 리스터 추가
  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  // 4. fetchMore 하기 위한 로직을 설정해 둘 listener
  void scrollListener() {
    // 현재 위치가
    // 최대 길이보다 조금 덜되는 위치까지 왔다면
    // 새로운 데이터를 추가요청
    // if (controller.offset > controller.position.maxScrollExtent - 300) {
    //   ref.read(buildingProvider.notifier).paginate(
    //     fetchMore: true,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    // 5. buildingProvider가 넘겨주는 데이터에 따라서 UI를 빌드
    // 여기서의 buildingProvider는 building_detatil_provider.dart에 정의되어 있음
    final data = ref.watch(buildingProvider);
    print("야호");

    // 완전 처음 로딩일때
    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final cp = data as CursorPagination;
    print('${cp.data.length} 길이');
    return Center(
      child: Text("정상통신"),
    );
  }
}
