import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/review/view/create_review.dart';
import 'package:houscore/review/view/delete_confirmed.dart';
import 'package:blurry/blurry.dart';

class MyReviewList extends StatefulWidget {
  const MyReviewList({Key? key}) : super(key: key);

  @override
  State<MyReviewList> createState() => _MyReviewListState();
}

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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text(
                      '내가 쓴 리뷰',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Column(
                children: reviewsWithImages
                    .map(
                      (review) => MyReviewCard(
                        address: review['address'],
                        userRating: review['userRating'],
                        aiRating: review['aiRating'],
                        like: review['like'],
                        dislike: review['dislike'],
                        imageUrl: review['imageUrl'],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// my review 카드

class MyReviewCard extends StatelessWidget {
  final String address;
  final double userRating;
  final double aiRating;
  final String like;
  final String dislike;
  final String imageUrl;

  const MyReviewCard({
    Key? key,
    required this.address,
    required this.userRating,
    required this.aiRating,
    required this.like,
    required this.dislike,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    address,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                // 평점 관련 부분
                _buildRatingSection(userRating, aiRating),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Image.asset(
                  'asset/img/logo/main_logo.png',
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '추천해요 : ',
                              style:
                              TextStyle(fontSize: 13, color: Colors.blue),
                            ),
                            TextSpan(
                              text: like,
                              style:
                              TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '별로예요 : ',
                              style: TextStyle(fontSize: 13, color: Colors.red),
                            ),
                            TextSpan(
                              text: dislike,
                              style:
                              TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            Row(
              children: [
                Container(
                  child: Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateReview()),
                          //TODO update로 바꾸기
                        );
                      },
                      child: Text('수정'),
                    ),
                  ),
                ),
                VerticalDivider(),
                Container(
                  child: Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        Blurry.info(
                          title: '건물 이름 또는 주소',
                          cancelButtonText: '취소',
                          description:
                          '리뷰를 삭제하시겠습니까?',
                          confirmButtonText: '삭제',
                          onConfirmButtonPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteConfirmed()),
                            );
                          },
                        ).show(context);
                      },
                      child: Text('삭제'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(double userRating, double aiRating) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 20.0,
        ),
        Text(
          userRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 4.0),
      ],
    );
  }
}
