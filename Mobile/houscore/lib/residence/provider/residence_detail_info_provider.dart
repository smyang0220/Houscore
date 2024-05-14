import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/residence/utils/place_utils.dart';
import '../../common/model/data_state_model.dart';
import '../model/location_model.dart';
import '../repository/residence_repository.dart';
import '../model/residence_detail_indicators_model.dart';

final residenceDetailInfoProvider = StateNotifierProvider.family<
    ResidenceDetailInfoNotifier, DataStateBase, Location>((ref, location) {
  final repository = ref.watch(residenceRepositoryProvider);
  return ResidenceDetailInfoNotifier(repository: repository, location: location);
});


// StateNotifier 클래스
class ResidenceDetailInfoNotifier extends StateNotifier<DataStateBase> {
  final ResidenceRepository repository;
  final Location location;

  ResidenceDetailInfoNotifier({required this.repository, required this.location}) : super(DataStateLoading()) {
    fetchResidenceDetailInfo();
  }


  Future<void> fetchResidenceDetailInfo() async {
    try {
      // print('실제 api 요청 보내는 주소는 ${PlaceUtils.mapAddressForAPI(location.address)}');
      final response = await repository.getResidenceDetailInfo(address: PlaceUtils.mapAddressForAPI(location.address), lat: location.latitude, lng: location.longitude);
      // print(' ---------------------------------- response ${response} ----------------------------------');
      state = DataState(data: response);
      // state = DataStateError(message: "에러 실험");
    } catch (e) {
      // print(' ---------------------------------- error ${e} ----------------------------------');
      state = DataStateError(message: e.toString());
    }
  }
}
