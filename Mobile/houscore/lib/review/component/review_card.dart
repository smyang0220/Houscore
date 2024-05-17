import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/const/color.dart';
import '../../residence/view/residence_detail.dart';

class ReviewCard extends StatelessWidget {
  final String address;
  final double userRating;
  final double aiRating;
  final String like;
  final String dislike;
  final String imageUrl;

  const ReviewCard({
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
      onTap: () {
        context.push('/residence/${address}');
      },
      // 카드간 패딩
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          // 카드 내부 패딩
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      address,
                      style: TextStyle(fontSize: 22, fontFamily: 'NotoSans', fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 평점 관련 부분
                  _buildRatingSection(userRating, aiRating),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  imageUrl == ""
                      ? Image.asset(
                    'assets/img/logo/main_logo.png',
                    width: MediaQuery.of(context).size.width * 0.28,
                    height: MediaQuery.of(context).size.width * 0.28,
                  )
                      : Image.network(
                    imageUrl,
                    width: MediaQuery.of(context).size.width * 0.28,
                    height: MediaQuery.of(context).size.width * 0.28,
                  ),

                  SizedBox(width: 15),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("장점" , style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 12, // 글자 크기를 작게 설정합니다.
                              color: PRIMARY_COLOR, // 글자 색상을 회색으로 설정합니다.
                              fontWeight: FontWeight.w700,
                            ),),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(like, style:
                                TextStyle(
                                    fontFamily: 'NotoSans',fontSize: 12, color: Colors.black),
                                  maxLines: 2, overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text("단점",style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 12, // 글자 크기를 작게 설정합니다.
                              color: Colors.purpleAccent, // 글자 색상을 회색으로 설정합니다.
                              fontWeight: FontWeight.w700,
                            )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(dislike, style:
                              TextStyle(
                                  fontFamily: 'NotoSans',fontSize: 12, color: Colors.black),
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                              ), )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          size: 16.0,
        ),
        Text(
          userRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 16.0),
        Text(
          "AI",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: PRIMARY_COLOR,
          ),
        ),
        SizedBox(width: 3),
        Text(
          aiRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}