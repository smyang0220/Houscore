import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houscore/review/component/photo_reviews.dart';
import 'package:houscore/common/component/search_residences.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/const/design.dart';

import '../../residence/component/ai_recommendation.dart';
import '../component/main_logo_app_name.dart';
import '../../review/component/nearby_recent_reviews.dart';
import '../layout/default_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// 더미 최근 검색 거주지
class _HomeScreenState extends State<HomeScreen> {
  final List<String> residenceNames = [
    '잠실 레이크팰리스',
    '잠실 트리지움 아파트',
    '잠실 더클래스원 오피스텔',
    '잠실 주공아파트',
    '잠실 엘스',
  ];

  // 더비 리뷰 데이터
  final List<Map<String, dynamic>> reviews = [
    {
      'address': '서울특별시 강남구 개포동 12번지',
      'userRating': 4.0,
      'aiRating': 2.8,
      'like': '사람이 별로 없어서 조용합니다.',
      'dislike': '배달음식을 시켜먹을 곳이 별로 없습니다.'
    },
    {
      'address': '서울특별시 강동구 천호대로 1121',
      'userRating': 3.0,
      'aiRating': 3.5,
      'like': '바다가 가까워서 좋습니다.',
      'dislike': '주변에 상점이 별로 없습니다.'
    },
  ];

  // 더미 이미지 리뷰 데이터
  final List<Map<String, dynamic>> reviewsWithImages = [
    {
      'address': '서울특별시 강남구 개포동 12번지',
      'userRating': 4.0,
      'aiRating': 2.8,
      'like': '사람이 별로 없어서 조용합니다.',
      'dislike': '배달음식을 시켜먹을 곳이 별로 없습니다.',
      'imageUrl': 'https://example.com/images/review1.jpg'
    },
    {
      'address': '서울특별시 강동구 천호대로 1121',
      'userRating': 3.0,
      'aiRating': 3.5,
      'like': '바다가 가까워서 좋습니다.',
      'dislike': '주변에 상점이 별로 없습니다.',
      'imageUrl': 'https://example.com/images/review2.jpg'
    },
    {
      'address': '부산 해운대구 마린시티',
      'userRating': 4.5,
      'aiRating': 4.2,
      'like': '바다 전망이 훌륭합니다.',
      'dislike': '여름철에 관광객이 많습니다.',
      'imageUrl': 'https://example.com/images/review3.jpg'
    },
    // {
    //   'address': '경기도 성남시 분당구 판교역 로데오',
    //   'userRating': 3.5,
    //   'aiRating': 3.0,
    //   'like': '기술 회사들이 많아 접근성이 좋습니다.',
    //   'dislike': '출퇴근 시간대에 교통이 혼잡합니다.',
    //   'imageUrl': 'https://example.com/images/review4.jpg'
    // },
    // {
    //   'address': '제주도 서귀포시 중문관광단지',
    //   'userRating': 5.0,
    //   'aiRating': 4.8,
    //   'like': '자연 경관이 아름답고 평화롭습니다.',
    //   'dislike': '겨울철에는 날씨가 다소 쌀쌀합니다.',
    //   'imageUrl': 'https://example.com/images/review5.jpg'
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Icon(Icons.create_rounded),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 메인 로고와 어플 이름
              MainLogoAppName(),
              // 한 줄 소개
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '당신의 집, 이제 점수로 만나보세요!',
                      style: TextStyle(
                        fontFamily: 'NotoSans', // SingleDay 폰트 사용
                        fontSize: 18, // 원하는 폰트 크기로 지정
                        fontWeight: FontWeight.bold, // 원하는 폰트 두께로 지정
                        color: Colors.black, // 원하는 폰트 색상으로 지정
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // 검색창
              // SearchResidences(title: null),
              SearchResidences(),
              SizedBox(height: VERTICAL_GAP),
              AiRecommendation(),
              SizedBox(height: VERTICAL_GAP),
              // 근처 거주지 리뷰
              NearbyResidencesReview(
                reviewsWithImages: reviewsWithImages,
                onViewAll: () {
                  // 전체 보기 시 다른 화면
                },
              ),
              // 최근 등록 리뷰
              SizedBox(height: VERTICAL_GAP),
              PhotoReviews(
                  reviewsWithImages: reviewsWithImages,
                  onViewAll: () {
                    // 전체 보기 시 다른 화면
                  })
            ],
          ),
        ),
      ),
    );
  }
}
