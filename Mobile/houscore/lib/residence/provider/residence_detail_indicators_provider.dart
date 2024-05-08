import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/residence_repository.dart';
import '../model/residence_detail_indicators_model.dart';

// StateNotifierProvider 설정
/*
   StateNotifierProvider는
   다른 Provider(여기서는 'residenceDetailIndicatorsRepositoryProvider')가 가져오는 데이터
   를 기반으로 상태를 관리하는 Provider

   그래서 residenceDetailIndicatorsRepositoryProvider로부터의 값인 repository와
   ResidenceDetailIndicatorNotifier를 생성 및 초기화 후 반환
*/

final residenceDetailIndicatorProvider = StateNotifierProvider<
    ResidenceDetailIndicatorNotifier, ResidenceDetailIndicatorsState>((ref) {
  final repository = ref.watch(residenceRepositoryProvider);

  final notifier = ResidenceDetailIndicatorNotifier(repository: repository);
  return notifier;
});

class ResidenceDetailIndicatorsState {
  final ResidenceDetailIndicatorsModel? detail;
  final bool isLoading;
  final String? errorMessage;

  // 기본 생성자는 모든 속성을 받으며 기본값을 설정합니다.
  ResidenceDetailIndicatorsState({
    this.detail,
    this.isLoading = false,
    this.errorMessage,
  });

  // 로딩 상태를 위한 팩토리 생성자
  ResidenceDetailIndicatorsState.loading()
      : detail = null,
        isLoading = true,
        errorMessage = null;

  // 에러 상태를 위한 팩토리 생성자
  ResidenceDetailIndicatorsState.error(this.errorMessage)
      : detail = null,
        isLoading = false;

  // 성공 상태를 위한 팩토리 생성자
  ResidenceDetailIndicatorsState.success(this.detail)
      : isLoading = false,
        errorMessage = null;
}


// StateNotifier 클래스
class ResidenceDetailIndicatorNotifier
    extends StateNotifier<ResidenceDetailIndicatorsState> {
  // 실제 데이터를 받아오는 retrofit 객체
  // API 호출 및 JsonSerializable를 활용한 모델 연동까지 자동화 + 오류처리
  final ResidenceRepository repository;

  ResidenceDetailIndicatorNotifier({required this.repository})
      : super(ResidenceDetailIndicatorsState.loading()) {
    fetchDetailIndicator();
  }

  Future<void> fetchDetailIndicator(
      {String address = 'default address'}) async {
    try {
      // 통신 결과
      final response =
          await repository.getResidenceDetailIndicator(address: address);
      print('통신 결과');
      print(response);
      state = ResidenceDetailIndicatorsState.success(response);
    } catch (e) {
      state = ResidenceDetailIndicatorsState.error(e.toString());
    }
  }
}
