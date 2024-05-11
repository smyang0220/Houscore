import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/residence/model/ai_recommended_residence_model.dart';
import '../../common/model/data_state_model.dart';
import '../repository/residence_repository.dart';

// Dummy data list focused on Seoul Jung-gu
final List<AiRecommendedResidenceModel> dummyAiResidences = [
  AiRecommendedResidenceModel(
    address: '서울특별시 중구 명동 1가',
    aiScore: 89.7,
    realPrice: 75000,
    pricePerPyeong: 250,
    pricePerRegion: 98.0,
    reviewCnt: 134,
  ),
  AiRecommendedResidenceModel(
    address: '서울특별시 중구 신당동',
    aiScore: 87.3,
    realPrice: 70000,
    pricePerPyeong: 240,
    pricePerRegion: 96.5,
    reviewCnt: 102,
  ),
  AiRecommendedResidenceModel(
    address: '서울특별시 중구 을지로동',
    aiScore: 88.9,
    realPrice: 78000,
    pricePerPyeong: 245,
    pricePerRegion: 97.1,
    reviewCnt: 119,
  ),
  AiRecommendedResidenceModel(
    address: '서울특별시 중구 충무로',
    aiScore: 85.5,
    realPrice: 72000,
    pricePerPyeong: 230,
    pricePerRegion: 93.5,
    reviewCnt: 89,
  ),
  AiRecommendedResidenceModel(
    address: '서울특별시 중구 회현동',
    aiScore: 90.1,
    realPrice: 80000,
    pricePerPyeong: 255,
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

    // 더미데이터 이용해서 레이아웃 확인용
    try {
      await Future.delayed(Duration(seconds: 1));
      final response = dummyAiResidences;
      print('response length ${response.length}');
      state = DataState(data: response);
    } catch (e) {
      state = DataStateError(message: e.toString());
    }

    // try {
    //   final response = await repository.getAiRecommendedResidences(sigungu: sigungu);
    //   print(' ---------------------------------- response length ${response.length} ----------------------------------');
    //   print(' ---------------------------------- response ${response} ----------------------------------');
    //   state = DataState(data: response);
    // } catch (e) {
    //   print(' ---------------------------------- error ${e} ----------------------------------');
    //   state = DataStateError(message: e.toString());
    // }
  }
}