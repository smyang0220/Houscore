import 'package:flutter/material.dart';
import 'package:houscore/common/component/review_card.dart';
import 'package:houscore/common/component/review_card_with_photo.dart';
import 'package:houscore/common/const/color.dart';

class RecentReviews extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final VoidCallback onViewAll;

  const RecentReviews({
    Key? key,
    required this.reviews,
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
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    // Icon(
                    //   Icons.forum_rounded,
                    //   size: 32.0,
                    //   color: PRIMARY_COLOR,
                    // ),
                    Text(
                      '📝 최근 등록 리뷰',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: onViewAll,
                    child: Text(
                      '전체보기',
                      style: TextStyle(color: Colors.grey),
                    )),
              ],
            ),
          ),
          Container(
            height: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(reviews.length, (index) {
                final review = reviews[index];
                return ReviewCard(
                  address: review['address'],
                  userRating: review['userRating'],
                  aiRating: review['aiRating'],
                  like: review['like'],
                  dislike: review['dislike'],
                );
              }),
            )
          ),
        ],
      ),
    );
  }
}
