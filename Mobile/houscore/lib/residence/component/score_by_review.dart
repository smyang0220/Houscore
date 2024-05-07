import 'package:flutter/material.dart';
import 'package:houscore/residence/component/review_rating.dart';

class ScoreByReview extends StatefulWidget {

  @override
  _ScoreByReviewState createState() =>
      _ScoreByReviewState();
}

class _ScoreByReviewState
    extends State<ScoreByReview> {

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '리뷰 기반 점수',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ReviewRating(),
      ],
    );
  }
}
