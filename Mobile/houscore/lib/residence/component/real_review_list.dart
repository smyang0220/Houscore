import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houscore/common/const/color.dart';
import 'real_review_card.dart';
import 'package:tabler_icons/tabler_icons.dart';

class RealReviewList extends StatefulWidget {
  const RealReviewList({Key? key}) : super(key: key);

  @override
  State<RealReviewList> createState() => _RealReviewListState();
}

class _RealReviewListState extends State<RealReviewList> {
  // 더비 리뷰 데이터
  final List<Map<String, dynamic>> reviews = [
    {
      'address': '서울 강남구 고급한 36-40',
      'userRating': 4.0,
      'like': '사람이 별로 없어서 조용합니다.',
      'dislike': '배달음식을 시켜먹을 곳이 별로 없습니다.'
    },
    {
      'address': '강원도 동해시 새롬뜨락 아파트',
      'userRating': 3.0,
      'like': '바다가 가까워서 좋습니다.',
      'dislike': '주변에 상점이 별로 없습니다.'
    },
  ];

  // 더미 이미지 리뷰 데이터
  final List<Map<String, dynamic>> reviewsWithImages = [
    {
      'userRating': 4.0,
      'like': '사람이 별로 없어서 조용합니다.',
      'dislike': '배달음식을 시켜먹을 곳이 별로 없습니다.',
      'imageUrl': 'https://example.com/images/review1.jpg'
    },
    {
      'userRating': 3.0,
      'like': '바다가 가까워서 좋습니다.',
      'dislike': '주변에 상점이 별로 없습니다.',
      'imageUrl': 'https://example.com/images/review2.jpg'
    },
    {
      'userRating': 4.5,
      'like': '바다 전망이 훌륭합니다.',
      'dislike': '여름철에 관광객이 많습니다.',
      'imageUrl': 'https://example.com/images/review3.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '실거주 리뷰',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text('filtering',style: TextStyle(color: Color(0xff8298E3)),),
                  Icon(TablerIcons.arrows_sort, color: Color(0xff8298E3),),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 15),
        Column(
          children: reviewsWithImages
              .map(
                (review) => RealReviewCard(
                  userRating: review['userRating'],
                  like: review['like'],
                  dislike: review['dislike'],
                  imageUrl: review['imageUrl'],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
