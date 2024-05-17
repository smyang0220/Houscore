import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final double VERTICAL_GAP = 32;

final TextStyle myTextStyle = TextStyle(
  fontFamily: 'NotoSans',
  fontSize: 12,
  color: Colors.grey,
  fontWeight: FontWeight.w500,
);

final TextStyle bodyTextStyle = TextStyle(

  fontFamily: 'NotoSans',
  fontSize: 12,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

final TextStyle bodyTextColorStyle = TextStyle(
  fontFamily: 'NotoSans',
  fontSize: 12,
  color: Colors.blueAccent,
  fontWeight: FontWeight.w500,
);

final TextStyle bodyTextColorStyle2 = TextStyle(
  fontFamily: 'NotoSans',
  fontSize: 12,
  color: Colors.deepPurpleAccent,
  fontWeight: FontWeight.w500,
);

final TextStyle bodyTextColorStyle3 = TextStyle(
  fontFamily: 'NotoSans',
  fontSize: 12, // 글자 크기를 작게 설정합니다.
  color: Colors.grey, // 글자 색상을 녹색으로 설정합니다.
  fontWeight: FontWeight.w100,
);



final BoxDecoration boxStyle = BoxDecoration(
// 테두리 설정
  border: Border.all(
    color: Colors.grey,
    width: 0.5, // 테두리 두께
  ),
// 모서리 둥글기 설정
  borderRadius: BorderRadius.circular(2.0),
);
