import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/model/data_state_model.dart';
import '../repository/review_repository.dart';

final residenceDetailIndicatorProvider = StateNotifierProvider.family<
    MyReviewsIndicatorNotifier, DataStateBase, String>((ref, mail) {
  final repository = ref.watch(reviewRepositoryProvider);
  return MyReviewsIndicatorNotifier(repository: repository, mail: mail);
});

// StateNotifier 클래스
class MyReviewsIndicatorNotifier extends StateNotifier<DataStateBase> {
  final ReviewRepository repository;
  final String mail;

  MyReviewsIndicatorNotifier({required this.repository, required this.mail}) : super(DataStateLoading()) {
    fetchDetailIndicator();
  }

  //유저 메일로 리뷰 검색
  Future<void> fetchDetailIndicator() async {
    try {
      final response = await repository.readMyReviews(mail: mail);
      print(' ---------------------------------- response ${response} ----------------------------------');
      state = DataState(data: response);
    } catch (e) {
      print(' ---------------------------------- error ${e} ----------------------------------');
      state = DataStateError(message: e.toString());
    }
  }
}
