
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/provider/data_list_param_provider.dart';

import '../../common/model/data_list_state_model.dart';
import '../../common/model/data_state_model.dart';
import '../../common/provider/data_list_provider.dart';
import '../model/location_model.dart';
import '../repository/nearby_recent_reviews_repository.dart';
import '../repository/residence_repository.dart';
import '../../review/model/homescreen_review_model.dart';

final nearbyRecentReviewsProvider = StateNotifierProvider<
    NearbyRecentReviewsStateNotifier, DataListStateBase>((ref) {

  final repo = ref.watch(nearbyRecentReviewsRepositoryProvider);
  final param = ref.watch(dataListParameterProvider);

  return NearbyRecentReviewsStateNotifier(repository: repo, params: param);
});

class NearbyRecentReviewsStateNotifier extends DataListProvider<HomescreenReviewModel, NearbyRecentReviewsRepository> {
  NearbyRecentReviewsStateNotifier({
    required super.repository,
    super.params,
  });
}