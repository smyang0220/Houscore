import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/review/model/homescreen_review_model.dart';
import '../model/residence_review_model.dart';

class ResidencePhotoReviewCard extends StatelessWidget {
  final String? buildingName;
  final String address;
  final String pros;
  final String cons;
  final double reviewScore;
  final double aiScore;
  final String imageUrl;

  const ResidencePhotoReviewCard({
    this.buildingName,
    required this.address,
    required this.pros,
    required this.cons,
    required this.reviewScore,
    required this.aiScore,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  factory ResidencePhotoReviewCard.fromModel({
    required HomescreenReviewModel model,
  }) {
    return ResidencePhotoReviewCard(
        buildingName : model.buildingName,
        address : model.address,
        pros : model.pros,
        cons : model.cons,
        reviewScore : model.reviewScore,
        aiScore : model.aiScore,
        imageUrl : model.imageUrl,);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/residence/${address}');
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                width: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              )
            else
              Image.asset(
                'asset/img/logo/main_logo.png',
                width: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child:
              _buildRatingSection(reviewScore, aiScore),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                // color: Colors.black.withOpacity(0.5),
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _buildRatingSection(reviewScore, aiScore),
                    Text(
                      address,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      pros,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(
      {super.key});

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Text("사진"),
      ],
    );
  }
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
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(width: 8.0),
      // AI 점수
      // Container(
      //   // decoration: BoxDecoration(
      //   //   color: Colors.white,
      //   //   borderRadius: BorderRadius.circular(7),
      //   // ),
      //   // padding: EdgeInsets.symmetric(horizontal: 5),
      //   child: Text(
      //     "AI",
      //     overflow: TextOverflow.ellipsis, // 여기에 ellipsis를 추가했습니다.
      //     style: TextStyle(
      //       fontSize: 16.0,
      //       fontWeight: FontWeight.bold,
      //       color: PRIMARY_COLOR,
      //     ),
      //   ),
      // ),
      // SizedBox(width: 3),
      // Text(
      //   aiRating.toStringAsFixed(1),
      //   overflow: TextOverflow.ellipsis, // 여기에 ellipsis를 추가했습니다.
      //   style: TextStyle(
      //     fontSize: 16.0,
      //     color: Colors.white,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
    ],
  );
}