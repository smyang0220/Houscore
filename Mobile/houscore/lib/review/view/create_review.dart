import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../../common/const/color.dart';
import 'create_reviewdetail.dart';
import 'package:houscore/review/component/dropdown.dart';

class CreateReview extends StatefulWidget {
  @override
  _CreateReviewState createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReview> {
  // String selectedAddress = '';
  //TODO selectedAddress 필수 처리
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
              Text(
                  '리뷰 작성하기 (1/2)',
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: SearchResidence(),
              ),
              ResidenceNameInput(
                value: nameValue,
                onChanged: _updateNameValue,
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

//리뷰할 주소 검색

class SearchResidence extends StatefulWidget {
  final String? address;

  const SearchResidence({Key? key, this.address}) : super(key: key);

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
      //TODO 크기 다른 위젯들과 맞추기
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
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
                  Text(selectedAddress!,
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Icon(Icons.search, color: PRIMARY_COLOR),
                ],
              ),
            ),
          ),
        ],
      ),
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

//건물 이름 입력

class ResidenceNameInput extends StatefulWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  ResidenceNameInput({this.value, required this.onChanged});

  @override
  _ResidenceNameInputState createState() => _ResidenceNameInputState();
}

class _ResidenceNameInputState extends State<ResidenceNameInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _controller.text = widget.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '건물 이름',
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
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: INPUT_BORDER_COLOR,
              hintText: '건물 이름을 입력해주세요',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: INPUT_BORDER_COLOR),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: INPUT_BORDER_COLOR),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: INPUT_BORDER_COLOR),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
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
