import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/residence_review_model.dart';


class ResidenceReviewCard extends StatelessWidget{
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
    int avg = (starRating.traffic + starRating.security + starRating.inside + starRating.infra + starRating.building) ~/ 5;
    return Container(
      child: Column(
children: [
  Row(
    children: [
      Text("사진위치"),
      Column(
        children: [
          Row(
            children: [

              Text("익명"),
              // Text("리뷰아이디 $id}"),
              Text(avg.toString()),
              ...List.generate(5, (index) => Icon(
                index < avg ? Icons.star : Icons.star_border_outlined,
                color: Colors.yellow,
              )),
              Text(avg.toString())
      ]
          ),
          Text("${residenceYear}까지 거주")
        ],
    )
    ],
  ),


  Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("장점", style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),),
      Text(pros),
  Text(id.toString()),
      Text("단점", style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),),
      Text(cons),

      Text("관리비", style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),),
      Text(maintenanceCost),
    ],
  ),


],
      ),
    );
  }
}