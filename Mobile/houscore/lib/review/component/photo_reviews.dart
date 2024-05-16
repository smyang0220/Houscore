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
                    // Icon(
                    //   Icons.camera_alt_rounded,
                    //   size: 32.0,
                    //   color: PRIMARY_COLOR,
                    // ),
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
                // TextButton(
                //     onPressed: onViewAll,
                //     child: Text(
                //       '전체보기',
                //       style: TextStyle(color: Colors.grey),
                //     )),
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
                  userRating: review['reviewScore'],
                  aiRating: review['aiScore'],
                  like: review['pros'],
                  dislike: review['cons'],
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
