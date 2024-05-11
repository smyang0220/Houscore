import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:houscore/review/component/review_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../residence/repository/naver_map_repository.dart';

class NearbyResidencesReview extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> reviewsWithImages;
  final VoidCallback onViewAll; // 전체보기

  const NearbyResidencesReview({
    Key? key,
    required this.reviewsWithImages,
    required this.onViewAll,
  }) : super(key: key);

  @override
  _NearbyResidencesReviewState createState() => _NearbyResidencesReviewState();
}

class _NearbyResidencesReviewState
    extends ConsumerState<NearbyResidencesReview> {
  // 현재 위치 문자열 // 초기 값 설정
  String _currentLocation = '위치 정보를 불러오는 중...';

  @override
  void initState() {
    super.initState();
    // geolocator를 활용 위치를 불러온 후 해당 position을 가지고 현재 위치 문자열 설정하여 재렌더링
    _determinePosition();
  }

  // 위치 불러오기 (비동기)
  Future<void> _determinePosition() async {
    bool serviceEnabled; // 위치 서비스 활성화 여부
    LocationPermission permission; // 위치 권한 설정

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
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = '위치 권한이 거부되었습니다.';
      });
      return;
    }

    // 현재 위치(위,경도 값인 상태)
    Position position = await Geolocator.getCurrentPosition();

    // 현재 위치의 위,경도 값으로 도로명 주소 가져오기 by Naver api
    _fetchAddress(position);
  }

  Future<void> _fetchAddress(Position position) async {
    try {
      final response =
          await ref.read(naverMapRepositoryProvider).getAddressFromLatLng({
        'coords': '${position.longitude},${position.latitude}',
        // 'coords': '0,0',
        'sourcecrs': 'epsg:4326',
        'orders': 'roadaddr',
        'output': 'json'
      });
      var addressData =
          response.data['results'][0]['land']['addition0']['value'] as String?;
      setState(() {
        // addressData가 null이 아닐 경우 '현재 위치: [주소]', null일 경우 '상세 주소 정보를 찾을 수 없습니다.'로 설정
        _currentLocation = addressData != null
            ? "현재 위치: $addressData"
            : '상세 주소 정보를 찾을 수 없습니다.';
      });
    } catch (e) {
      // setState(() => _currentLocation = '주소 정보를 불러오는데 실패했습니다: $e');
      setState(() => _currentLocation = '현재 위치 불러오기 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                TextButton(
                    onPressed: widget.onViewAll,
                    child: Text(
                      '전체보기',
                      style: TextStyle(color: Colors.grey),
                    )),
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
          Column(
            children: widget.reviewsWithImages
                .map((review) => ReviewCard(
                      address: review['address'],
                      userRating: review['userRating'],
                      aiRating: review['aiRating'],
                      like: review['like'],
                      dislike: review['dislike'],
                      imageUrl: review['imageUrl'],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

/*
    position 객체에서 설정 가능한 값들

    const Position({
    required this.longitude, // 경도
    required this.latitude, // 위도
    required this.timestamp, // UTC 시간 of 데이터 기록 (신선도 파악)
    required this.accuracy, // 정확도
    required this.altitude, // 고도
    required this.altitudeAccuracy, // 고도 정확도
    required this.heading, // 방향
    required this.headingAccuracy, // 방향 정확도
    required this.speed, // 속도 (기기의 이동속도)
    required this.speedAccuracy, // 속도 정확도
    this.floor, // 층
    this.isMocked = false, // 모의위치이니 아닌지
  });
   */
