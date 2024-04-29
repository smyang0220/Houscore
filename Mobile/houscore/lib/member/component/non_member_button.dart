import 'package:flutter/material.dart';

// nonMemberButton 커스텀 위젯 정의
class NonMemberButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const NonMemberButton({
    Key? key,
    required this.onPressed,
    this.text = '버튼', // 기본 텍스트, 필요시 변경 가능
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.grey), // 글자 색상
        textStyle: MaterialStateProperty.all(
          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min, // 버튼 안의 내용에 맞게 너비를 설정
        children: [
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
