import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/model/data_list_params.dart';
import 'package:houscore/common/model/data_list_state_model.dart';
import '../repository/base_data_list_repository.dart';

class DataListProvider<T,
U extends IBaseDataListRepository<T>>
    extends StateNotifier<DataListStateBase> {
  final U repository;
  final DataListParams? params;


  DataListProvider({
    this.params,
    required this.repository,
  }) : super(DataListStateLoading())
  {
    // 기본적으로 생성될 때 무조건 호출되는 함수
    fetchDataList();
  }

  Future<void> fetchDataList() async {
    try {
      final resp = await repository.fetchDataList(dataListParams: params);
        state = DataListState<T>(data: resp);
        print('resp.length = ${resp.length}');
        print('resp = ${resp}');
        print('resp String = ${resp.toList().toString()}');
    } catch (e, stack) {
      print(e);
      print(stack);
      state = DataListStateError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}