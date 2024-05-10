import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/review/component/residence_name_input.dart';
import 'create_reviewdetail.dart';
import 'package:houscore/review/component/review_rating.dart';
import 'package:houscore/review/component/dropdown.dart';

class CreateReview extends StatefulWidget {
  @override
  _CreateReviewState createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReview> {
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}