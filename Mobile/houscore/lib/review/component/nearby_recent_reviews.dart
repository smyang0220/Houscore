import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:houscore/common/model/data_state_model.dart';
import 'package:houscore/review/component/review_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../residence/model/location_model.dart';
import '../../residence/repository/naver_map_repository.dart';
import '../model/homescreen_review_model.dart';
import '../provider/nearby_recent_reviews_provider.dart';

class NearbyResidencesReview extends ConsumerStatefulWidget {
  final VoidCallback onViewAll; // 전체보기

  const NearbyResidencesReview({
    Key? key,
    required this.onViewAll,
  }) : super(key: key);

  @override
  _NearbyResidencesReviewState createState() => _NearbyResidencesReviewState();
}

class _NearbyResidencesReviewState extends ConsumerState<NearbyResidencesReview> {
  double? _latitude;
  double? _longitude;
  String _currentLocation = '위치 정보를 불러오는 중...';
  bool _hasFetchedReviews = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = '위치 서비스를 활성화해주세요.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = '위치 권한이 거부되었습니다.';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    if (_latitude != position.latitude || _longitude != position.longitude) {
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _hasFetchedReviews = false;
      });
      _fetchAddress(position);
      _fetchReviews();
    }
  }

  Future<void> _fetchAddress(Position position) async {
    try {
      final response = await ref.read(naverMapRepositoryProvider).getAddressFromLatLng({
        'coords': '${position.longitude},${position.latitude}',
        'sourcecrs': 'epsg:4326',
        'orders': 'roadaddr',
        'output': 'json'
      });
      var addressData = response.data['results'][0]['land']['addition0']['value'] as String?;
      setState(() {
        _currentLocation = addressData != null ? "현재 위치: $addressData" : '상세 주소 정보를 찾을 수 없습니다.';
      });
    } catch (e) {
      setState(() => _currentLocation = '현재 위치 불러오기 실패');
    }
  }

  void _fetchReviews() {
    if (_latitude != null && _longitude != null && !_hasFetchedReviews) {
      final initNotifier = ref.read(nearbyRecentReviewsProvider(LatLng(latitude: _latitude!, longitude: _longitude!)).notifier);
      initNotifier.fetchNearbyRecentReviews();
      setState(() {
        _hasFetchedReviews = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(nearbyRecentReviewsProvider(LatLng(latitude: _latitude ?? 0, longitude: _longitude ?? 0)));

    Widget _buildReviewContent(DataStateBase reviewState) {
      if (reviewState is DataStateLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (reviewState is DataStateError) {
        return Center(child: Text('리뷰를 불러오는데 실패했습니다: ${reviewState.message}'));
      } else if (reviewState is DataState) {
        final reviews = reviewState.data as List<HomescreenReviewModel>;
        if (reviews.isEmpty) {
          return Center(child: Text('근처에 리뷰가 없습니다.'));
        }
        return Column(
          children: reviews.map((review) {
            return ReviewCard(
              address: review.address,
              userRating: review.reviewScore,
              aiRating: review.aiScore,
              like: review.pros,
              dislike: review.cons,
              imageUrl: review.imageUrl,
            );
          }).toList(),
        );
      } else if (reviewState is DataStateRefetching) {
        final reviews = reviewState.data as List<HomescreenReviewModel>;
        return Column(
          children: reviews.map((review) {
            return ReviewCard(
              address: review.address,
              userRating: review.reviewScore,
              aiRating: review.aiScore,
              like: review.pros,
              dislike: review.cons,
              imageUrl: review.imageUrl,
            );
          }).toList(),
        );
      } else {
        return Container();
      }
    }

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
                // TextButton(
                //     onPressed: widget.onViewAll,
                //     child: Text(
                //       '전체보기',
                //       style: TextStyle(color: Colors.grey),
                //     )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
            child: Row(
              children: [
                Text(_currentLocation,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          _buildReviewContent(reviewState),
        ],
      ),
    );
  }
}
