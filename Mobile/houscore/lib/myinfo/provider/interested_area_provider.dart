import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/myinfo/repository/myinfo_repository.dart';
import 'package:houscore/residence/model/ai_recommended_residence_model.dart';
import '../../common/model/data_state_model.dart';
import '../model/interested_area.dart';

// 가상의 'interested areas' 데이터
List<InterestedAreaModel> createSampleInterestedAreas() {
  return [
    InterestedAreaModel(
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
        areaId: 1,
        memberId: 'member1',
        address: '서울 강남구 개포동 12'
    ),
    InterestedAreaModel(
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        updatedAt: DateTime.now().subtract(Duration(days: 2)),
        areaId: 2,
        memberId: 'member2',
        address: '서울 강동구 천호대로 1121'
    ),
    InterestedAreaModel(
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        updatedAt: DateTime.now().subtract(Duration(days: 3)),
        areaId: 3,
        memberId: 'member3',
        address: '대전 유성구 덕명동 16-1'
    ),
    InterestedAreaModel(
        createdAt: DateTime.now().subtract(Duration(days: 4)),
        updatedAt: DateTime.now().subtract(Duration(days: 4)),
        areaId: 4,
        memberId: 'member4',
        address: '부산 해운대구 좌동 좌1번지'
    ),
    InterestedAreaModel(
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now().subtract(Duration(days: 5)),
        areaId: 5,
        memberId: 'member5',
        address: '인천 남동구 구월동 123번지'
    ),
    InterestedAreaModel(
        createdAt: DateTime.now().subtract(Duration(days: 6)),
        updatedAt: DateTime.now().subtract(Duration(days: 6)),
        areaId: 6,
        memberId: 'member6',
        address: '대구 수성구 황금동 456번지'
    ),
    InterestedAreaModel(
        createdAt: DateTime.now().subtract(Duration(days: 7)),
        updatedAt: DateTime.now().subtract(Duration(days: 7)),
        areaId: 7,
        memberId: 'member7',
        address: '광주 광산구 송정동 789번지'
    ),
    InterestedAreaModel(
        createdAt: DateTime.now().subtract(Duration(days: 8)),
        updatedAt: DateTime.now().subtract(Duration(days: 8)),
        areaId: 8,
        memberId: 'member8',
        address: '울산 북구 신천동 10번지'
    ),
    InterestedAreaModel(
        createdAt: DateTime.now().subtract(Duration(days: 9)),
        updatedAt: DateTime.now().subtract(Duration(days: 9)),
        areaId: 9,
        memberId: 'member9',
        address: '세종특별자치시 조치원읍 세종로 11번지'
    ),
    InterestedAreaModel(
        createdAt: DateTime.now().subtract(Duration(days: 10)),
        updatedAt: DateTime.now().subtract(Duration(days: 10)),
        areaId: 10,
        memberId: 'member10',
        address: '경기 성남시 분당구 야탑동 12'
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
    try {
      await Future.delayed(Duration(seconds: 1));
      final response = createSampleInterestedAreas();
      print('response length ${response.length}');
      state = DataState(data: response);
    } catch (e) {
      state = DataStateError(message: e.toString());
    }

    // try {
    //   final response = await repository.getInterestedAreaList();
    //   print(' ---------------------------------- response length ${response.length} ----------------------------------');
    //   print(' ---------------------------------- response ${response} ----------------------------------');
    //   state = DataState(data: response);
    // } catch (e) {
    //   print(' ---------------------------------- error ${e} ----------------------------------');
    //   state = DataStateError(message: e.toString());
    // }
  }
}