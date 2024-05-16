import 'package:houscore/common/model/data_list_params.dart';
import 'package:houscore/common/model/data_list_state_model.dart';

import '../../residence/model/pagination_params.dart';

abstract class IBaseDataListRepository<T> {
  Future<List<T>> fetchDataList({DataListParams? dataListParams});
}