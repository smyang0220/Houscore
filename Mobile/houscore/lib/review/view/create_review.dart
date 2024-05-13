import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../../common/const/color.dart';
import 'create_reviewdetail.dart';

class CreateReview extends StatefulWidget {
  @override
  _CreateReviewState createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReview> {
  String? selectedAddress;
  String? typeValue;
  String? yearValue;
  String? floorValue;
  Map<String, int> ratings = {};

  bool get isButtonEnabled =>
      selectedAddress != null &&
      typeValue != null &&
      yearValue != null &&
      floorValue != null &&
      ratings.length == categories.length &&
      ratings.values.every((rating) => rating != 0);

  void _updateSelectedAddress(String? newValue) {
    setState(() {
      selectedAddress = newValue;
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
              Text(
                '리뷰 작성하기 (1/2)',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SearchResidence(
                value: selectedAddress,
                onChanged: _updateSelectedAddress,
              ),
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
                onRatingUpdated: _updateRating,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            ReviewData reviewData = ReviewData(
                              selectedAddress: selectedAddress,
                              typeValue: typeValue,
                              yearValue: yearValue,
                              floorValue: floorValue,
                              ratings: ratings,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateReviewDetail(reviewData: reviewData),
                              ),
                            );
                          }
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

class ReviewData {
  String? selectedAddress;
  String? nameValue;
  String? typeValue;
  String? yearValue;
  String? floorValue;
  Map<String, int> ratings;

  ReviewData({
    this.selectedAddress,
    this.nameValue,
    this.typeValue,
    this.yearValue,
    this.floorValue,
    required this.ratings,
  });
}

//리뷰할 주소 검색
class SearchResidence extends StatefulWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const SearchResidence({this.value, required this.onChanged});

  @override
  State<SearchResidence> createState() => _SearchResidenceState();
}

class _SearchResidenceState extends State<SearchResidence> {
  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.value; // 초기 값 설정
  }

  void setAddress(String address) {
    setState(() {
      selectedAddress = address;
    });
    widget.onChanged(address); // 상위 위젯의 selectedAddress 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //TODO 위젯 크기 통일시키기
      //TODO 주소 너무 길면 잘림
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        GestureDetector(
          onTap: () {
            _navigateAndDisplaySelection(context);
          },
          child: Container(
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
                Text(selectedAddress ?? "실제 거주했던 집의 주소를 검색해주세요.",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                Icon(Icons.search, color: PRIMARY_COLOR),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    //결과를 RemediKopo 페이지에서 받아옴
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RemediKopo()),
    );

    //결과가 null인지 확인
    if (result != null && result is KopoModel) {
      setAddress('${result.address!}');
    }
  }
}

// 드롭다운

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
  final Function(String, int) onRatingUpdated;

  ReviewRating({required this.onRatingUpdated});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories
          .map((category) => ListTile(
                title: Container(
                  child: Center(
                    child: Text(category, textAlign: TextAlign.center),
                  ),
                ),
                trailing: RatingWidget(
                  onRatingChanged: (rating) =>
                      onRatingUpdated(category, rating),
                ),
              ))
          .toList(),
    );
  }
}

class RatingWidget extends StatefulWidget {
  final Function(int) onRatingChanged;

  RatingWidget({required this.onRatingChanged});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _currentRating = 0;

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
                )),
        SizedBox(width: 3),
        Text('$_currentRating / 5', style: TextStyle(fontSize: 16))
      ],
    );
  }
}
