import 'package:flutter/material.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/review/view/update_reviewdetail.dart';
import '../../common/const/color.dart';
import '../model/review_to_update_model.dart';

class UpdateReview extends StatefulWidget {
  final ReviewToUpdateModel reviewToUpdate;

  UpdateReview({required this.reviewToUpdate});

  @override
  _UpdateReviewState createState() => _UpdateReviewState();
}

class _UpdateReviewState extends State<UpdateReview> {
  String? selectedAddress;
  String? typeValue;
  String? yearValue;
  String? floorValue;
  Map<String, double> ratings = {};

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.reviewToUpdate.address;
    typeValue = widget.reviewToUpdate.residenceType;
    yearValue = widget.reviewToUpdate.residenceYear;
    floorValue = widget.reviewToUpdate.residenceFloor;
    ratings = {
      '교통': widget.reviewToUpdate.starRating.traffic,
      '건물': widget.reviewToUpdate.starRating.building,
      '내부': widget.reviewToUpdate.starRating.inside,
      '인프라': widget.reviewToUpdate.starRating.infra,
      '치안': widget.reviewToUpdate.starRating.security,
    };
  }

  bool get isButtonEnabled =>
      selectedAddress != null &&
          typeValue != null &&
          yearValue != null &&
          floorValue != null &&
          ratings.length == categories.length &&
          ratings.values.every((rating) => rating != 0);

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

  void _updateRating(String category, double newRating) {
    setState(() {
      ratings[category] = newRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '리뷰 수정하기 (1/2)',
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '주소',
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: INPUT_BORDER_COLOR,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: INPUT_BORDER_COLOR),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedAddress ?? "실제 거주했던 집의 주소를 검색해주세요.",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                DropdownType(
                  value: typeValue,
                  onChanged: _updateTypeValue,
                ),
                DropdownYear(
                  value: yearValue,
                  onChanged: _updateYearValue,
                ),
                DropdownFloor(
                  value: floorValue,
                  onChanged: _updateFloorValue,
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
                ReviewRating(
                  ratings: ratings,
                  onRatingUpdated: _updateRating,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateReviewDetail(
                                reviewToUpdate: widget.reviewToUpdate),
                          ),
                        );
                      }
                          : null,
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
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

class DropdownType extends StatefulWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  DropdownType({this.value, required this.onChanged});

  @override
  _DropdownTypeState createState() => _DropdownTypeState();
}

class _DropdownTypeState extends State<DropdownType> {
  @override
  Widget build(BuildContext context) {
    return dropdownWidget(
      title: '거주 유형',
      value: widget.value,
      hint: '거주 유형을 선택해주세요.',
      items: ['원룸/빌라', '오피스텔', '아파트'],
      onChanged: widget.onChanged,
    );
  }
}

class DropdownYear extends StatefulWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  DropdownYear({this.value, required this.onChanged});

  @override
  _DropdownYearState createState() => _DropdownYearState();
}

class _DropdownYearState extends State<DropdownYear> {
  @override
  Widget build(BuildContext context) {
    return dropdownWidget(
      title: '거주 년도',
      value: widget.value,
      hint: '거주 년도를 선택해주세요.',
      items: [
        '2024년',
        '2023년',
        '2022년',
        '2021년',
        '2020년',
        '2019년',
        '2018년',
        '2017년',
        '2016년',
        '2015년',
        '2014년 이전'
      ],
      onChanged: widget.onChanged,
    );
  }
}

class DropdownFloor extends StatefulWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  DropdownFloor({this.value, required this.onChanged});

  @override
  _DropdownFloorState createState() => _DropdownFloorState();
}

class _DropdownFloorState extends State<DropdownFloor> {
  @override
  Widget build(BuildContext context) {
    return dropdownWidget(
      title: '거주 층수',
      value: widget.value,
      hint: '거주 층수를 선택해주세요.',
      items: [
        '1층',
        '2~5층',
        '5~15층',
        '16층 이상',
      ],
      onChanged: widget.onChanged,
    );
  }
}

Widget dropdownWidget({
  required String title,
  required String? value,
  required String hint,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        height: 60,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: INPUT_BORDER_COLOR,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: INPUT_BORDER_COLOR), // 테두리 색상
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: INPUT_BORDER_COLOR), // 테두리 색상을 유지
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: INPUT_BORDER_COLOR), // 포커스 받았을 때의 색상
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            hint: Text(hint),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            underline: SizedBox(),
          ),
        ),
      ),
    ],
  );
}

//별점 rating
final List<String> categories = ['교통', '건물', '내부', '인프라', '치안'];

class ReviewRating extends StatelessWidget {
  final Map<String, double> ratings;
  final Function(String, double) onRatingUpdated;

  ReviewRating({required this.ratings, required this.onRatingUpdated});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories
          .map(
            (category) => ListTile(
          title: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Center(
              child: Text(category, textAlign: TextAlign.center),
            ),
          ),
          trailing: RatingWidget(
            initialRating: ratings[category] ?? 0,
            onRatingChanged: (rating) => onRatingUpdated(category, rating),
          ),
        ),
      )
          .toList(),
    );
  }
}

class RatingWidget extends StatefulWidget {
  final double initialRating;
  final Function(double) onRatingChanged;

  RatingWidget({required this.initialRating, required this.onRatingChanged});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          5,
              (index) => IconButton(
            icon: Icon(
              index < _currentRating
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: index < _currentRating ? Colors.amber : Colors.amber,
            ),
            onPressed: () {
              setState(() {
                _currentRating = index + 1;
              });
              widget.onRatingChanged(_currentRating);
            },
            iconSize: 30,
          ),
        ),
        SizedBox(width: 3),
        Text('$_currentRating / 5', style: TextStyle(fontSize: 16))
      ],
    );
  }
}
