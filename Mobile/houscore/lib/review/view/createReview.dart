import 'package:flutter/material.dart';
import 'createReviewDetail.dart';
import 'package:houscore/review/component/reviewRating.dart';
import 'package:houscore/review/component/dropdown.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: createReview1stPage(),
  ));
}

class createReview1stPage extends StatefulWidget {
  @override
  _createReview1stPageState createState() => _createReview1stPageState();
}

class _createReview1stPageState extends State<createReview1stPage> {
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('리뷰 작성(1/2)')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 12),
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: DropdownType(
              //     value: typeValue,
              //     onChanged: _updateTypeValue,
              //   ),
              // ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownType(
                  value: typeValue,
                  onChanged: _updateTypeValue,
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownYear(
                  value: yearValue,
                  onChanged: _updateYearValue,
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownFloor(
                  value: floorValue,
                  onChanged: _updateFloorValue,
                ),
              ),
              SizedBox(height: 12),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(12.0),
                child: Text(
                  '만족도 평가',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Expanded(
                child: RatingsPage(
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
                        MaterialPageRoute(builder: (context) => createReview2ndPage())) : null,
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
