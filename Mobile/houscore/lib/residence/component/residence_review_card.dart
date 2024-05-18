import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/utils/data_utils.dart';
import '../../common/const/design.dart';
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
  final bool isDetail;

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
    required this.isDetail,
    Key? key,
  }) : super(key: key);

  factory ResidenceReviewCard.fromModel({
    required ResidenceReviewModel model,
    required bool isDetail,
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
      residenceYear: model.residenceYear,
      isDetail: isDetail,);
  }

  @override
  Widget build(BuildContext context) {
    int avg = (starRating.traffic +
        starRating.security +
        starRating.inside +
        starRating.infra +
        starRating.building) ~/
        5;

    return GestureDetector(
      onTap: () {
        context.push('/residence/${address}');
      },
      child: Container(
        decoration: isDetail ? null : boxStyle,
        child: Padding(
          padding: isDetail ? EdgeInsets.all(0) : EdgeInsets.all(16.0),
          child: Column(
            children: [
              _Header(
                residenceFloor: residenceFloor,
                residenceYear: residenceYear,
                avg: avg,
                isDetail: isDetail,
                address: address,
              ),
              _Body(
                title: '추천해요',
                content: pros,
              ),
              _Body(
                title: '별로에요',
                content: cons,
              ),
              if(isDetail)
                _Body(
                  title: '관리비   ',
                  content: maintenanceCost,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String residenceFloor;
  final String residenceYear;
  final int avg;
  final bool isDetail;
  final String address;

  const _Header(
      {super.key,
        required this.residenceFloor,
        required this.residenceYear,
        required this.avg,
        required this.isDetail,
        required this.address});

  @override
  Widget build(BuildContext context) {
    String floorText = DataUtils.floorDescription(residenceFloor);

    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              if(isDetail)
                Text(
                  " ${floorText} : ",
                  style: myTextStyle,
                ),
              if(isDetail)
                Text(
                  "${residenceYear}까지 거주",
                  style: myTextStyle,
                ),
              if(!isDetail)
                Text(
                  "${address}",
                  style: myTextStyle,
                ),
            ]),
            Row(
              children: [
                ...List.generate(
                    5,
                        (index) => Icon(
                      index < avg ? Icons.star : Icons.star_border_outlined,
                      color: Colors.yellow,
                      size: 16,
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
            style: title == "추천해요"
                ? bodyTextColorStyle
                : (title == "별로에요"
                ? bodyTextColorStyle2
                : (title == "관리비   "
                ? bodyTextColorStyle3
                : null)),

          ),
          SizedBox(width: 5,),
          Flexible(
            child: Text(
              content,
              softWrap: true,
              style: bodyTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
