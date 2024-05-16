import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/model/data_list_params.dart';
import 'package:houscore/residence/model/pagination_params.dart';

final dataListParameterProvider = StateNotifierProvider<DataListParamsNotifier, DataListParams>(
        (ref) => DataListParamsNotifier()
);


class DataListParamsNotifier extends StateNotifier<DataListParams> {
  DataListParamsNotifier() : super(DataListParams(
    lng: 127.075215,
    lat: 37.4941833
  ));

  void updateParams({double? lat, double? lng}) {
    print("updateDataListParams 진입");
    state = DataListParams(
      lng: lng ?? state.lng,
      lat: lat ?? state.lat,
    );

  }
}
