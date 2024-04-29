import 'package:flutter/material.dart';
import 'package:houscore/review/component/review_card.dart';
class NearbyResidencesReview extends StatelessWidget {
  final List<Map<String, dynamic>> reviewsWithImages;
  final VoidCallback onViewAll;

  const NearbyResidencesReview({
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
                    // Icon(
                    //   Icons.explore,
                    //   size: 32.0,
                    //   color: PRIMARY_COLOR,
                    // ),
                    Text(
                      '🚩 근처 거주지 최근 리뷰',
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
                      '위치보기',
                      style: TextStyle(color: Colors.grey),
                    )),
              ],
            ),
          ),
          Column(
            children: reviewsWithImages.map((review) => ReviewCard(
              address: review['address'],
              userRating: review['userRating'],
              aiRating: review['aiRating'],
              like: review['like'],
              dislike: review['dislike'],
              imageUrl: review['imageUrl'],
            )).toList(),
          ),
        ],
      ),
    );
  }
}