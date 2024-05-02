import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'create_reviewdetail.dart';
import 'package:houscore/review/component/review_rating.dart';
import 'package:houscore/review/component/dropdown.dart';

class CreateReview extends StatefulWidget {
  @override
  _CreateReviewState createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReview> {
  String? typeValue;
  String? yearValue;
  String? floorValue;
  Map<String, int> ratings = {};

  bool get isButtonEnabled => typeValue != null && yearValue != null && floorValue != null && ratings.length == categories.length && ratings.values.every((rating) => rating != 0);

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
      child: Scaffold(
        appBar: AppBar(title: Text('리뷰 작성(1/2)')),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DropdownType(
                    value: typeValue,
                    onChanged: _updateTypeValue,
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DropdownYear(
                    value: yearValue,
                    onChanged: _updateYearValue,
                  ),
                ),
                SizedBox(height: 12),
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
                      onPressed:
                      isButtonEnabled ? () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CreateReviewdetail())) : null,
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
      ),
    );
  }
}
