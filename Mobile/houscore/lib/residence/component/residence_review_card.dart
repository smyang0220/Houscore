import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houscore/common/utils/data_utils.dart';
import '../model/residence_review_model.dart';

class ResidenceReviewCard extends StatelessWidget {
  final int id;
  final String address;
  final String residenceType;
  final String residenceFloor;
  final StarRating starRating;
  final String pros;
  final String cons;
  final String maintenanceCost;
  final String? images;
  final String residenceYear;

  const ResidenceReviewCard({
    required this.id,
    required this.address,
    required this.residenceType,
    required this.residenceFloor,
    required this.starRating,
    required this.pros,
    required this.cons,
    required this.maintenanceCost,
    this.images,
    required this.residenceYear,
    Key? key,
  }) : super(key: key);

  factory ResidenceReviewCard.fromModel({
    required ResidenceReviewModel model,
  }) {
    return ResidenceReviewCard(
        id: model.id,
        address: model.address,
        residenceType: model.residenceType,
        residenceFloor: model.residenceFloor,
        starRating: model.starRating,
        pros: model.pros,
        cons: model.cons,
        maintenanceCost: model.maintenanceCost,
        images: model.images,
        residenceYear: model.residenceYear);
  }

  @override
  Widget build(BuildContext context) {
    int avg = (starRating.traffic +
            starRating.security +
            starRating.inside +
            starRating.infra +
            starRating.building) ~/
        5;
    return Container(
      child: Column(
        children: [
          _Header(
            residenceFloor: residenceFloor,
            residenceYear: residenceYear,
            avg: avg,
          ),
          _Body(
            title: '장점',
            content: pros,
          ),
          _Body(
            title: '단점',
            content: cons,
          ),
          _Body(
            title: '관리비',
            content: maintenanceCost,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String residenceFloor;
  final String residenceYear;
  final int avg;

  const _Header(
      {super.key,
      required this.residenceFloor,
      required this.residenceYear,
      required this.avg});

  @override
  Widget build(BuildContext context) {
    String floorText = DataUtils.floorDescription(residenceFloor);

    return Row(
      children: [
        Text("사진"),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(" ${floorText} : "),
              Text("${residenceYear}까지 거주"),
            ]),
            Row(
              children: [
                ...List.generate(
                    5,
                    (index) => Icon(
                          index < avg ? Icons.star : Icons.star_border_outlined,
                          color: Colors.yellow,
                        )),
              ],
            )
          ],
        )
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String title;
  final String content;
  const _Body({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Flexible(
              child: Text(
                content,
                softWrap: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
