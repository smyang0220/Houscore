import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/review/component/my_reviews.dart';
import 'package:houscore/review/component/photo_reviews.dart';
import 'package:houscore/common/component/search_residences.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/const/design.dart';

import '../../residence/component/ai_recommendation.dart';
import '../../review/component/nearby_recent_reviews.dart';
import '../../review/component/recent_reviews.dart';

class MyReviewList extends StatefulWidget {
  const MyReviewList({Key? key}) : super(key: key);

  @override
  State<MyReviewList> createState() => _MyReviewListState();
}

// 더미 최근 검색 거주지
class _MyReviewListState extends State<MyReviewList> {

  // 더비 리뷰 데이터
  final List<Map<String, dynamic>> reviews = [
    {
      'address': '서울 강남구 고급한 36-40',
      'userRating': 4.0,
      'aiRating': 2.8,
      'like': '사람이 별로 없어서 조용합니다.',
      'dislike': '배달음식을 시켜먹을 곳이 별로 없습니다.'
    },
    {
      'address': '강원도 동해시 새롬뜨락 아파트',
      'userRating': 3.0,
      'aiRating': 3.5,
      'like': '바다가 가까워서 좋습니다.',
      'dislike': '주변에 상점이 별로 없습니다.'
    },
  ];

  // 더미 이미지 리뷰 데이터
  final List<Map<String, dynamic>> reviewsWithImages = [
    {
      'address': '서울 강남구 고급한 36-40',
      'userRating': 4.0,
      'aiRating': 2.8,
      'like': '사람이 별로 없어서 조용합니다.',
      'dislike': '배달음식을 시켜먹을 곳이 별로 없습니다.',
      'imageUrl': 'https://example.com/images/review1.jpg'
    },
    {
      'address': '강원도 동해시 새롬뜨락 아파트',
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
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: VERTICAL_GAP),
              MyReview(
                reviewsWithImages: reviewsWithImages,
                onViewAll: () {
                  // 전체 보기 시 다른 화면
                },
              ),
              // 최근 등록 리뷰
            ],
          ),
        ),
      ),
    );
  }
}
