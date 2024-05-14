import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/residence/component/review_rating.dart';

class ScoreByReview extends StatefulWidget {
  const ScoreByReview({Key? key}) : super(key: key);

  @override
  _ScoreByReviewState createState() => _ScoreByReviewState();
}

class _ScoreByReviewState extends State<ScoreByReview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '리뷰 기반 점수',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '3.8',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: PRIMARY_COLOR),
            ),
          ],
        ),
        ReviewRating(),
      ],
    );
  }
}
