import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../residence/view/residence_detail.dart';

class ReviewCardWithPhoto extends StatelessWidget {
  final String address;
  final double userRating;
  final double aiRating;
  final String like;
  final String dislike;
  final String imageUrl;

  const ReviewCardWithPhoto({
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
      onTap: () {
        print('${this.address} tapped!');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResidenceDetail(address: address),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            Image.asset(
              'asset/img/logo/main_logo.png',
              width: MediaQuery.of(context).size.width * 0.35,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingSection(userRating, aiRating),
                    Text(
                      address,
                      overflow: TextOverflow.ellipsis, // 여기에 ellipsis를 추가했습니다.
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      like,
                      overflow: TextOverflow.ellipsis, // 여기에 ellipsis를 추가했습니다.
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
        SizedBox(width: 4.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(7),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            "AI",
            overflow: TextOverflow.ellipsis, // 여기에 ellipsis를 추가했습니다.
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 3),
        Text(
          aiRating.toStringAsFixed(1),
          overflow: TextOverflow.ellipsis, // 여기에 ellipsis를 추가했습니다.
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
