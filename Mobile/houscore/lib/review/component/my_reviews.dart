import 'package:flutter/material.dart';
import 'package:houscore/review/component/my_review_card.dart';
import 'package:houscore/review/component/review_card.dart';

class MyReview extends StatelessWidget {
  final List<Map<String, dynamic>> reviewsWithImages;
  final VoidCallback onViewAll;

  const MyReview({
    Key? key,
    required this.reviewsWithImages,
    required this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
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
              ],
            ),
          ),
          Column(
            children: reviewsWithImages
                .map((review) => MyReviewCard(
                      address: review['address'],
                      userRating: review['userRating'],
                      aiRating: review['aiRating'],
                      like: review['like'],
                      dislike: review['dislike'],
                      imageUrl: review['imageUrl'],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
