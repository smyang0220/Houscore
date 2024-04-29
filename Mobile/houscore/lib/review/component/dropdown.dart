import 'package:flutter/material.dart';

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
    return Container(
      height: 70,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          labelText: '거주 유형',
          labelStyle: TextStyle(fontSize: 25, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: widget.value,
          hint: Text("거주 유형을 선택해주세요"),
          onChanged: widget.onChanged,
          items: <String>['원룸/빌라', '오피스텔', '아파트'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          underline: SizedBox(),
        ),
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
    return Container(
      height: 70,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          labelText: '거주 년도',
          labelStyle: TextStyle(fontSize: 25, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: widget.value,
          hint: Text("거주 년도를 선택해주세요"),
          onChanged: widget.onChanged,
          items: <String>['2024년', '2023년', '2022년'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          underline: SizedBox(),
        ),
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
    return Container(
      height: 70,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          labelText: '거주 층',
          labelStyle: TextStyle(fontSize: 25, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: widget.value,
          hint: Text("거주 층수를 선택해주세요"),
          onChanged: widget.onChanged,
          items: <String>['1층', '2층', '3층'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          underline: SizedBox(),
        ),
      ),
    );
  }
}
