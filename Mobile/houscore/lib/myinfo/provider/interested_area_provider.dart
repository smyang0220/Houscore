import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/myinfo/repository/myinfo_repository.dart';
import 'package:houscore/residence/model/ai_recommended_residence_model.dart';
import '../../common/model/data_state_model.dart';
import '../model/interested_area.dart';

// 가상의 'interested areas' 데이터
List<InterestedAreaModel> createSampleInterestedAreas() {
  return [
    InterestedAreaModel(
        areaId: 1,
        address: '서울 강남구 개포동 12'
    ),
    InterestedAreaModel(
        areaId: 2,
        address: '서울 강동구 강동구 길동 454-1'
    ),
    InterestedAreaModel(
        areaId: 3,
        address: '대전 유성구 덕명동 522-1'
    ),
    InterestedAreaModel(
        areaId: 4,
        address: '부산 해운대구 좌동 1348'
    ),
    InterestedAreaModel(
        areaId: 5,
        address: '인천 남동구 구월동 620-13'
    ),
    InterestedAreaModel(
        areaId: 6,
        address: '대구 수성구 황금동 847-2'
    ),
    InterestedAreaModel(
        areaId: 7,
        address: '충북 청주시 흥덕구 송정동 140-41'
    ),
    InterestedAreaModel(
        areaId: 8,
        address: '서울 송파구 신천동 7-17'
    ),
    InterestedAreaModel(
        areaId: 9,
        address: '세종특별자치시 조치원읍 교리 12-9'
    ),
    InterestedAreaModel(
        areaId: 10,
        address: '경기 성남시 분당구 야탑동 13-1'
    ),
  ];
}


final interestedAreaListProvider = StateNotifierProvider<InterestedAreaListNotifier, DataStateBase>((ref) {
  final repository = ref.watch(myinfoRepositoryProvider);
  return InterestedAreaListNotifier(repository: repository);
});

class InterestedAreaListNotifier extends StateNotifier<DataStateBase> {
  final MyinfoRepository repository;

  InterestedAreaListNotifier({required this.repository}) : super(DataStateLoading()) {
    fetchInterestedAreaList();
  }

  Future<void> fetchInterestedAreaList() async {

    // 더미데이터 이용해서 레이아웃 확인용
    // try {
    //   await Future.delayed(Duration(seconds: 1));
    //   final response = createSampleInterestedAreas();
    //   print('response length ${response.length}');
    //   state = DataState(data: response);
    // } catch (e) {
    //   state = DataStateError(message: e.toString());
    // }

    try {
      final response = await repository.getInterestedAreaList();
      print(' @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ response length ${response.length} ----------------------------------');
      print(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% response ${response} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
      state = DataState(data: response);
    } catch (e) {
      print(' ############################## error ${e} ############################## error ');
      state = DataStateError(message: e.toString());
    }
  }
}