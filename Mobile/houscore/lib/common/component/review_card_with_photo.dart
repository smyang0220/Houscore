import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houscore/common/const/color.dart';

class ReviewCardWithPhoto extends StatelessWidget {
  final String address;
  final double userRating;
  final double aiRating;
  final String like;
  final String dislike;
  final String imageUrl;
  // 사진 파일들 관련 변수

  const ReviewCardWithPhoto({
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
        // 리뷰 상세 페이지 이동 로직
        print('${this.address} tapped!');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.8,
        // height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'asset/img/logo/main_logo.png',
                width: MediaQuery.of(context).size.width * 0.33,
              ),
              SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(
                      like,
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                    // Text(
                    //   dislike,
                    //   style: TextStyle(fontSize: 12, color: Colors.red),
                    // ),
                    SizedBox(height: 20),
                    Row(
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
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue, // PRIMARY_COLOR 대신 사용
                                    borderRadius: BorderRadius.circular(7), // 모서리 둥글기
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 5), // 좌우 여백// PRIMARY_COLOR 대신 사용
                                  child: Text(
                                    "AI",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 3),
                        Text(
                          aiRating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Image.network(
              //   imageUrl,
              //   width: 10,
              //   height: 10,
              //   fit: BoxFit.cover,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
