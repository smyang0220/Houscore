import 'package:flutter/material.dart';
import 'package:houscore/residence/component/real_review_list.dart';
import 'package:houscore/residence/component/score_by_ai.dart';
import 'package:houscore/residence/component/score_by_review.dart';

class ScoreAndReview extends StatefulWidget {
  const ScoreAndReview ({Key? key}) : super (key: key);

  @override
  State<StatefulWidget> createState() => _ScoreAndReviewState();
}

class _ScoreAndReviewState extends State<ScoreAndReview> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScoreByReview(),
            ScoreByAi(),
            RealReviewList(),
          ],
        ),
      ),
    );
  }
}