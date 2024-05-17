import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:houscore/common/provider/data_list_param_provider.dart';
import 'package:houscore/review/component/review_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/model/data_list_state_model.dart';
import '../../residence/repository/naver_map_repository.dart';
import '../model/homescreen_review_model.dart';
import '../../residence/provider/nearby_recent_reviews_provider.dart';

class NearbyResidencesReview extends ConsumerStatefulWidget {
  const NearbyResidencesReview({
    Key? key,
  }) : super(key: key);

  @override
  _NearbyResidencesReviewState createState() => _NearbyResidencesReviewState();
}

class _NearbyResidencesReviewState
    extends ConsumerState<NearbyResidencesReview> {
  double? lat;
  double? lng;
  String? address = '현재 위치와 근처 거주지의 리뷰를 불러오고 있습니다.';

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _determinePosition();
    ref.read(nearbyRecentReviewsProvider.notifier);
    await _fetchAddress(lat, lng);
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled; // 위치 서비스 활성화 여부
    LocationPermission permission; // 위치 권한 여부

    // 위치 서비스 활성화여부 불러오기
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // 만약 비활성화 상태이고
    if (!serviceEnabled) {
      // 현재 표시되는 부분을 위치 서비스 활성화 요청으로 설정
      setState(() {
        address = '위치 서비스를 활성화해주세요.';
      });
      return;
    }

    // 위치 권한 불러오기
    permission = await Geolocator.checkPermission();

    // 위치 권한이 거부 상태라면
    if (permission == LocationPermission.denied) {
      // 일단 요청
      permission = await Geolocator.requestPermission();
    }
    // 2번 째도 거절이라면 거절로 간주
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      setState(() {
        address = '위치 권한이 거부되었습니다.';
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();

      if (lat != position.latitude || lng != position.longitude) {
        setState(() {
          lat = position.latitude;
          lng = position.longitude;
        });

        DataListParamsNotifier notifier = await ref.read(dataListParameterProvider.notifier);
        notifier.updateParams(lng: lng, lat: lat);
      }
    } catch (e) {
      setState(() {
        address = '위치 정보를 불러오는데 실패했습니다.';
      });
    }
  }

  Future<void> _fetchAddress(double? lat, double? lng) async {
    if (lat == null || lng == null) {
      // print('lat or lng is null, skipping fetch address');
      return;
    }

    // print('Fetching address for position by lng : $lng, and lat : $lat');

    try {
      final response =
      await ref.read(naverMapRepositoryProvider).getAddressFromLatLng({
        'coords': '$lng,$lat',
        'sourcecrs': 'epsg:4326',
        'orders': 'roadaddr',
        'output': 'json'
      });

      // print('Address response: ${response.data}');

      var addressData =
      response.data['results'][0]['land']['addition0']['value'] as String?;

      setState(() {
          address = addressData != null
              ? "현재 위치: $addressData"
              : '상세 주소 정보를 찾을 수 없습니다.';
      });
    } catch (e) {
      // print('Error fetching address: $e');
      setState(() => address = '현재 위치 불러오기 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nearbyRecentReviewsProvider);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      '🚩 근처 거주지 최근 리뷰',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
            child: Row(
              children: [
                Text(
                  '$address',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (state is DataListStateLoading)
            CircularProgressIndicator(),
          if (state is DataListStateError)
            Text('데이터를 불러오지 못했습니다.'),
          if (state is DataListState<HomescreenReviewModel>)
            ...state.data.map((review) => ReviewCard(
              address: review.address,
              userRating: review.reviewScore,
              aiRating: review.aiScore,
              like: review.pros,
              dislike: review.cons,
              imageUrl: review.imageUrl,
            )).toList(),
        ],
      ),
    );
  }
}
