import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({super.key, this.hintText, this.errorText,
    this.obscureText = false, this.autofocus = false, required this.onChanged});

  @override
  Widget build(BuildContext context) {
     // 기본 TextFormField 디자인 UnderlineInputBorder
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),

    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      // 비밀번호 입력할 때
      obscureText: obscureText,
      autofocus: autofocus, // 눌러야지 focus되게 함, true면 자동으로 focus됨
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),  // hintText 스타일 지정
        fillColor: INPUT_BG_COLOR, // 배경색상
          //false - 배경색 없음
          // true - 배경색 있음
        filled: true,
        // 모든 Input 상태의 기본 스타일 세팅
        border: baseBorder,
        // 선택해서 사용할 수 있는 상태의 Border 스타일
        enabledBorder: baseBorder,
        // 눌렸을때의 Border
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ), // 눌렸을때
      ),
    );
  }
}
