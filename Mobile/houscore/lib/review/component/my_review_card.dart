import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houscore/review/view/create_review.dart';
import 'package:houscore/review/view/delete_confirmed.dart';

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
                Expanded(
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
              height: 10,
            ),
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
                          //TODO upodate로 바꾸기
                        );
                      },
                      child: Text('수정'),
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteConfirmed()),
                        );
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
