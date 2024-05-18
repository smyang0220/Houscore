import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../../common/const/color.dart';
import '../../residence/repository/naver_map_repository.dart';
import 'create_reviewdetail.dart';

class CreateReview extends StatefulWidget {
  @override
  _CreateReviewState createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReview> {
  String? selectedAddress;
  double? lat;
  double? lng;
  String? typeValue;
  String? yearValue;
  String? floorValue;
  Map<String, double> ratings = {};

  bool get isButtonEnabled =>
      selectedAddress != null &&
      lat != null &&
      lng != null &&
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

  void _updatedLatLng(double newLat, double newLng) {
    setState(() {
      lat = newLat;
      lng = newLng;
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
            padding: const EdgeInsets.all(16.0),
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
                  onChangedAdd: _updateSelectedAddress,
                  onChangedLatLng: _updatedLatLng,
                ),
                SizedBox(height: 8,),
                DropdownType(
                  value: typeValue,
                  onChanged: _updateTypeValue,
                ),
                SizedBox(height: 8,),
                DropdownYear(
                  value: yearValue,
                  onChanged: _updateYearValue,
                ),
                SizedBox(height: 8,),
                DropdownFloor(
                  value: floorValue,
                  onChanged: _updateFloorValue,
                ),
                SizedBox(height: 16,),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '항목별 평가',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                // 문제의 코드
                ReviewRating(
                  onRatingUpdated: _updateRating,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ElevatedButton(
                        child: Text('취소'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              ReviewData reviewData = ReviewData(
                                selectedAddress: selectedAddress!,
                                lat: lat!,
                                lng: lng!,
                                typeValue: typeValue!,
                                yearValue: yearValue!,
                                floorValue: floorValue!,
                                ratings: ratings,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateReviewDetail(
                                      reviewData: reviewData),
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

class ReviewData {
  String selectedAddress;
  double lat;
  double lng;
  String typeValue;
  String yearValue;
  String floorValue;
  Map<String, double> ratings;

  ReviewData({
    required this.selectedAddress,
    required this.lat,
    required this.lng,
    required this.typeValue,
    required this.yearValue,
    required this.floorValue,
    required this.ratings,
  });
}

//리뷰할 주소 검색
class SearchResidence extends ConsumerStatefulWidget {
  final String? value;
  final ValueChanged<String?> onChangedAdd;
  final Function(double, double) onChangedLatLng;

  const SearchResidence(
      {this.value, required this.onChangedAdd, required this.onChangedLatLng});

  @override
  ConsumerState<SearchResidence> createState() => _SearchResidenceState();
}

class _SearchResidenceState extends ConsumerState<SearchResidence> {
  String? selectedAddress;
  double? selectedLat;
  double? selectedLng;

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.value; // 초기 값 설정
  }

  void setAddress(String address) {
    setState(() {
      selectedAddress = address;
    });
    widget.onChangedAdd(address); // 상위 위젯의 selectedAddress 업데이트
  }

  void setLatLng(double lat, double lng) {
    setState(() {
      selectedLat = lat;
      selectedLng = lng;
    });
    widget.onChangedLatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GestureDetector(
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
        ),
      ],
    );
  }

  Future<Map<String, double>?> _fetchLatLng(
      String address, WidgetRef ref) async {
    try {
      final response = await ref
          .read(naverMapRepositoryProvider)
          .getLatLngFromAddress(address);
      if (response.data.isNotEmpty) {
        final responseData = response.data;
        if (responseData['status'] == 'OK' &&
            responseData['addresses'].isNotEmpty) {
          final addressInfo = responseData['addresses'][0];
          final latitude = double.parse(addressInfo['y']);
          final longitude = double.parse(addressInfo['x']);
          setLatLng(latitude, longitude);
          print(longitude);
        }
      }
    } catch (e) {
      print('Error fetching lat/lng: $e');
    }
    return null;
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RemediKopo()),
    );

    if (result != null && result is KopoModel) {
      setAddress('${result.address!}');
      await _fetchLatLng(result.address!, ref);
    }
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

final List<String> categories = ['교통', '건물', '내부', '인프라', '치안'];

class ReviewRating extends StatelessWidget {
  final Function(String, double) onRatingUpdated;

  ReviewRating({required this.onRatingUpdated});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: categories
            .map(
              (category) => ListTile(
                title: Center(
                  child: Text(
                    category,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                trailing: RatingWidget(
                  onRatingChanged: (rating) =>
                      onRatingUpdated(category, rating),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class RatingWidget extends StatefulWidget {
  final Function(double) onRatingChanged;

  const RatingWidget({Key? key, required this.onRatingChanged})
      : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            5,
            (index) => GestureDetector(
              child: Icon(
                index < _currentRating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: Colors.amber,
                size: MediaQuery.of(context).size.width * 0.08,
              ),
              onTap: () {
                setState(() {
                  _currentRating = index + 1;
                });
                widget.onRatingChanged(_currentRating);
              },
            ),
          ),
        ),
        SizedBox(width: 5,),
        Text(
          '${_currentRating.toStringAsFixed(0)} / 5',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
