import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/model/data_list_state_model.dart';
import '../../residence/model/pagination_params.dart';
import '../model/cursor_pagination_model.dart';
import '../model/model_with_id.dart';
import '../repository/base_data_list_repository.dart';
import '../repository/base_pagination_repository.dart';

class DataListProvider<T,
U extends IBaseDataListRepository<T>>
    extends StateNotifier<DataListStateBase> {
  final U repository;
  DataListProvider({
    required this.repository,
  }) : super(DataListStateLoading()){
    fetchDataList();
  }

  Future<void> fetchDataList() async {
    try {
      final resp = await repository.fetchDataList();
        state = DataListState<T>(data: resp);
    } catch (e, stack) {
      print(e);
      print(stack);
      state = DataListStateError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}