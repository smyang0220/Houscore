import 'package:flutter/material.dart';
import 'package:houscore/review/component/review_card.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/review/component/review_card_with_photo.dart';

class PhotoReviews extends StatelessWidget {
  final List<Map<String, dynamic>> reviewsWithImages;
  final VoidCallback onViewAll;

  const PhotoReviews({
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
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      '📷 백문이 불여일견! 사진 리뷰',
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
          Container(
            // height: MediaQuery.of(context).size.height * 0.22,
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: reviewsWithImages.length,
              itemBuilder: (context, index) {
                final review = reviewsWithImages[index];
                return ReviewCardWithPhoto(
                  address: review['address'],
                  userRating: review['userRating'],
                  aiRating: review['aiRating'],
                  like: review['like'],
                  dislike: review['dislike'],
                  imageUrl: review['imageUrl'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

