import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/residence/model/ai_recommended_residence_model.dart';
import '../../common/model/data_state_model.dart';
import '../repository/residence_repository.dart';

// Dummy data list focused on Seoul Jung-gu
final List<AiRecommendedResidenceModel> dummyAiResidences = [
  AiRecommendedResidenceModel(
    address: '서울특별시 중구 명동 1가',
    aiScore: 89.7,
    realPrice: 750000000,
    pricePerPyeong: 2500000,
    pricePerRegion: 98.0,
    reviewCnt: 134,
  ),
  AiRecommendedResidenceModel(
    address: '서울특별시 중구 신당동',
    aiScore: 87.3,
    realPrice: 700000000,
    pricePerPyeong: 2400000,
    pricePerRegion: 96.5,
    reviewCnt: 102,
  ),
  AiRecommendedResidenceModel(
    address: '서울특별시 중구 을지로동',
    aiScore: 88.9,
    realPrice: 780000000,
    pricePerPyeong: 2450000,
    pricePerRegion: 97.1,
    reviewCnt: 119,
  ),
  AiRecommendedResidenceModel(
    address: '서울특별시 중구 충무로',
    aiScore: 85.5,
    realPrice: 720000000,
    pricePerPyeong: 2300000,
    pricePerRegion: 93.5,
    reviewCnt: 89,
  ),
  AiRecommendedResidenceModel(
    address: '서울특별시 중구 회현동',
    aiScore: 90.1,
    realPrice: 800000000,
    pricePerPyeong: 2550000,
    pricePerRegion: 99.3,
    reviewCnt: 150,
  )
];


final aiRecommendedResidenceProvider = StateNotifierProvider.family<
    AiRecommendedResidenceNotifier, DataStateBase, String>((ref, sigungu) {
  final repository = ref.watch(residenceRepositoryProvider);
  return AiRecommendedResidenceNotifier(repository: repository, sigungu: sigungu);
});

class AiRecommendedResidenceNotifier extends StateNotifier<DataStateBase> {
  final ResidenceRepository repository;
  final String sigungu;

  AiRecommendedResidenceNotifier({required this.repository, required this.sigungu}) : super(DataStateLoading()) {
    print('sigungu before fetching = ${sigungu} ---------------------------');
    fetchAiRecommendedResidences();
  }

  Future<void> fetchAiRecommendedResidences() async {
    print('sigungu while fetching = ${sigungu} ---------------------------');
    try {
      final response = await repository.getAiRecommendedResidences(sigungu: sigungu);
      print(' ---------------------------------- response length ${response.length} ----------------------------------');
      print(' ---------------------------------- response ${response} ----------------------------------');
      state = DataState(data: response);
    } catch (e) {
      print(' ---------------------------------- error ${e} ----------------------------------');
      state = DataStateError(message: e.toString());
    }
  }
}