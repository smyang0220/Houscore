import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

class ScoreByAi extends StatefulWidget {
  @override
  _ScoreByAiState createState() => _ScoreByAiState();
}

class _ScoreByAiState extends State<ScoreByAi> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI 기반 점수',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '공공데이터 기반 AI 점수',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            Text(
              '3.9',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: PRIMARY_COLOR),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
