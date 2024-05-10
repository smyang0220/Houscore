import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/review/component/residence_name_input.dart';
import 'package:houscore/review/view/my_review_list.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../../common/const/color.dart';
import 'create_reviewdetail.dart';
import 'package:houscore/review/component/review_rating.dart';
import 'package:houscore/review/component/dropdown.dart';

class CreateReview extends StatefulWidget {
  @override
  _CreateReviewState createState() => _CreateReviewState();
}
class _CreateReviewState extends State<CreateReview> {
  String addressJSON = '';
  String? nameValue;
  String? typeValue;
  String? yearValue;
  String? floorValue;
  Map<String, int> ratings = {};
  bool get isButtonEnabled =>
      nameValue != null &&
          typeValue != null &&
          yearValue != null &&
          floorValue != null &&
          ratings.length == categories.length &&
          ratings.values.every((rating) => rating != 0);
  void _updateNameValue(String? newValue) {
    setState(() {
      nameValue = newValue;
    });
  }
  void _updateTypeValue(String? newValue) {
    setState(() {
      typeValue = newValue;
    });
  }
  void _updateYearValue(String? newValue) {
    setState(() {
      yearValue = newValue;
    });
  }
  void _updateFloorValue(String? newValue) {
    setState(() {
      floorValue = newValue;
    });
  }
  void _updateRating(String category, int newRating) {
    setState(() {
      ratings[category] = newRating;
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child:
                Text(
                  '리뷰 작성하기 (1/2)',
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SearchResidence(),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: ResidenceNameInput(
                  value: nameValue,
                  onChanged: _updateNameValue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: DropdownType(
                  value: typeValue,
                  onChanged: _updateTypeValue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: DropdownYear(
                  value: yearValue,
                  onChanged: _updateYearValue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: DropdownFloor(
                  value: floorValue,
                  onChanged: _updateFloorValue,
                ),
              ),
              SizedBox(height: 12),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(6.0),
                child: Text(
                  '만족도 평가',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                child: ReviewRating(
                  onRatingUpdated: _updateRating,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateReviewDetail()))
                        : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled))
                            return Colors.grey;
                          return Colors.blue; // Default enabled color
                        },
                      ),
                      foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text('다음'),
                  ),
                  // TODO 임시, api 조회 test
                  ElevatedButton(
                      child: Text('MyReviewList'),
                      onPressed: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyReviewList()));}
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResidence extends StatefulWidget {

  final String? address;

  const SearchResidence({Key? key, this.address}) :  super(key : key);

  @override
  State<SearchResidence> createState() => _SearchResidenceState();
}

class _SearchResidenceState extends State<SearchResidence> {

  String? selectedAddress = '실제 거주했던 집의 주소를 검색해주세요.';

  void setAddress(String address) {
    setState(() {
      selectedAddress = address;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '💯 내가 살 곳의 점수는?',
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RemediKopo()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: PRIMARY_COLOR, width: 2.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedAddress!,
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Icon(Icons.search, color: PRIMARY_COLOR),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
