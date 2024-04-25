import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  bool get isButtonEnabled => typeValue != null && yearValue != null && floorValue != null;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('리뷰 작성(1/2)')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownType(
                  value: typeValue,
                  onChanged: _updateTypeValue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownYear(
                  value: yearValue,
                  onChanged: _updateYearValue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownFloor(
                  value: floorValue,
                  onChanged: _updateFloorValue,
                ),
              ),Expanded(
                child: RatingsPage(
                ),
              ),
              ElevatedButton(
                onPressed:
                isButtonEnabled ? () => print('제출 버튼이 눌렸습니다.') : null,
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
                child: Text('완료'),
              ),
            ],
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
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        labelText: '거주 유형',
        labelStyle: TextStyle(fontSize: 30, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: DropdownButton<String>(
        value: widget.value,
        hint: Text("거주 유형을 선택해주세요"),
        onChanged: widget.onChanged,
        items: <String>['원룸/빌라', '오피스텔', '아파트'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
        underline: SizedBox(),
      ),
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
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        labelText: '거주 년도',
        labelStyle: TextStyle(fontSize: 30, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: DropdownButton<String>(
        value: widget.value,
        hint: Text("거주 년도를 선택해주세요"),
        onChanged: widget.onChanged,
        items: <String>['2024', '2023', '2022', '2021', '2020', '2019', '2018', '2017', '2016', '2015', '2014', '2014년 이전'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
        underline: SizedBox(),
      ),
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
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        labelText: '거주 층수',
        labelStyle: TextStyle(fontSize: 30, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: DropdownButton<String>(
        value: widget.value,
        hint: Text("거주 층수를 선택해주세요"),
        onChanged: widget.onChanged,
        items: <String>['1층', '2~5층', '5~20층', '20층 이상'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
        underline: SizedBox(),
      ),
    );
  }
}

class RatingsPage extends StatelessWidget {
  final List<String> categories = ['교통', '건물', '내부', '인프라', '치안'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(categories[index]),
          trailing: RatingWidget(),
        );
      },
    );
  }
}

class RatingWidget extends StatefulWidget {
  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _currentRating = 0;

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= _currentRating ? Icons.star : Icons.star_border,
        color: index <= _currentRating ? Colors.amber : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _currentRating = index;
        });
      },
      iconSize: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) => _buildStar(index + 1)),
    );
  }
}
