import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houscore/common/utils/data_utils.dart';
import 'package:houscore/residence/model/residence_main_photo_model.dart';
import '../model/residence_review_model.dart';

class ResidencePhotoReviewCard extends StatelessWidget {
  final String buildingName;
  final String address;
  final String pros;
  final String cons;
  final double reviewScore;
  final double aiScore;
  final String imageUrl;

  const ResidencePhotoReviewCard({
    required this.buildingName,
    required this.address,
    required this.pros,
    required this.cons,
    required this.reviewScore,
    required this.aiScore,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  factory ResidencePhotoReviewCard.fromModel({
    required ResidenceMainPhotoModel model,
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
    return Container(
      child: Column(
        children: [
          Text("사진들어가요"),
          Text(buildingName),
          Text(pros),
          Text(cons),
        ],
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
