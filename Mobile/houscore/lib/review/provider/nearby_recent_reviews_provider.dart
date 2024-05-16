
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/data_state_model.dart';
import '../../residence/model/location_model.dart';
import '../../residence/repository/residence_repository.dart';
import '../model/homescreen_review_model.dart';

final nearbyRecentReviewsProvider = StateNotifierProvider.family<
    NearbyRecentReviewsProviderNotifier, DataStateBase, LatLng>((ref, latLng) {
  final repository = ref.watch(residenceRepositoryProvider);
  return NearbyRecentReviewsProviderNotifier(repository: repository, latitude: latLng.latitude, longitude: latLng.longitude);
});

class NearbyRecentReviewsProviderNotifier extends StateNotifier<DataStateBase> {
  final ResidenceRepository repository;
  final double latitude;
  final double longitude;

  NearbyRecentReviewsProviderNotifier({required this.repository, required this.latitude, required this.longitude}) : super(DataStateLoading()) {
    fetchNearbyRecentReviews();
  }

  Future<void> fetchNearbyRecentReviews() async {
    try {
      print('위경도 값 : ( ${latitude} , ${longitude} )');
      final response = await repository.getNearbyRecentReviews(lat: latitude, lng: longitude);
      print(' ---------------------------------- response ${response} ----------------------------------');
      state = DataState(data: response);
    } catch (e) {
      // print(' ---------------------------------- error ${e} ----------------------------------');
      state = DataStateError(message: e.toString());
    }
  }
}