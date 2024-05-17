import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final double VERTICAL_GAP = 32;

final TextStyle myTextStyle = TextStyle(
  fontFamily: 'NotoSans',
  fontSize: 12, // 글자 크기를 작게 설정합니다.
  color: Colors.grey, // 글자 색상을 회색으로 설정합니다.
  fontWeight: FontWeight.w200,
);

final TextStyle bodyTextStyle = TextStyle(

  fontFamily: 'NotoSans',
  fontSize: 12, // 글자 크기를 작게 설정합니다.
  color: Colors.black, // 글자 색상을 회색으로 설정합니다.
  fontWeight: FontWeight.w100,
);

final TextStyle bodyTextStyle2 = TextStyle(

  fontFamily: 'NotoSans',
  fontSize: 16, // 글자 크기를 작게 설정합니다.
  color: Colors.black, // 글자 색상을 회색으로 설정합니다.
  fontWeight: FontWeight.normal,
);


final TextStyle bodyTextColorStyle = TextStyle(
  fontFamily: 'NotoSans',
  fontSize: 12, // 글자 크기를 작게 설정합니다.
  color: Colors.blueAccent, // 글자 색상을 회색으로 설정합니다.
  fontWeight: FontWeight.w100,
);

final TextStyle bodyTextColorStyle2 = TextStyle(
  fontFamily: 'NotoSans',
  fontSize: 12, // 글자 크기를 작게 설정합니다.
  color: Colors.deepPurpleAccent, // 글자 색상을 회색으로 설정합니다.
  fontWeight: FontWeight.w100,
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
    color: Colors.grey, // 테두리 색상
    width: 0.5, // 테두리 두께
  ),
// 모서리 둥글기 설정
  borderRadius: BorderRadius.circular(2.0), // 모서리의 둥근 정도
);
