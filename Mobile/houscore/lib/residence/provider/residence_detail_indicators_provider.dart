import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/residence/utils/place_utils.dart';
import '../../common/model/data_state_model.dart';
import '../repository/residence_repository.dart';
import '../model/residence_detail_indicators_model.dart';

final residenceDetailIndicatorProvider = StateNotifierProvider.family<
    ResidenceDetailIndicatorNotifier, DataStateBase, String>((ref, address) {
  final repository = ref.watch(residenceRepositoryProvider);
  return ResidenceDetailIndicatorNotifier(repository: repository, address: address);
});

// StateNotifier 클래스
class ResidenceDetailIndicatorNotifier extends StateNotifier<DataStateBase> {
  final ResidenceRepository repository;
  final String address;

  ResidenceDetailIndicatorNotifier({required this.repository, required this.address}) : super(DataStateLoading()) {
    fetchDetailIndicator();
  }

  Future<void> fetchDetailIndicator() async {
    try {
      // print('실제 api 요청 보내는 주소는 ${PlaceUtils.mapAddressForAPI(address)}');
      final response = await repository.getResidenceDetailIndicator(address: PlaceUtils.mapAddressForAPI(address));
      // print(' ---------------------------------- response ${response} ----------------------------------');
      state = DataState(data: response);
    } catch (e) {
      // print(' ---------------------------------- error ${e} ----------------------------------');
      state = DataStateError(message: e.toString());
    }
  }
}
