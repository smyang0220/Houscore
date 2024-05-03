import 'package:flutter/material.dart';
import 'package:houscore/building/provider/building_detatil_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/cursor_pagination_model.dart';
class ApiTestScreen extends ConsumerStatefulWidget {
  const ApiTestScreen({super.key});

  @override
  ConsumerState<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends ConsumerState<ApiTestScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

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
    final data = ref.watch(buildingProvider);

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
