import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

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
      hint: '거주 유형을 선택해주세요',
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
      hint: '거주 년도를 선택해주세요',
      items: ['2024년', '2023년', '2022년', '2021년', '2020년', '2019년', '2018년', '2017년', '2016년', '2015년', '2014년 이전'],
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
      hint: '거주 층수를 선택해주세요',
      items: ['1층', '2~5층', '5~15층', '16층 이상',],
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
              borderSide: BorderSide(color: INPUT_BORDER_COLOR), // 포커스 받았을 때의 색상
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