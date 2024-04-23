import 'package:flutter/material.dart';

class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFFFEE500)), // 카카오 색상
        foregroundColor: MaterialStateProperty.all(Colors.black), // 글자 색상
        textStyle: MaterialStateProperty.all(
          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
      onPressed: () => _loginWithKakao(context), // context를 전달
      child: Row(
        mainAxisSize: MainAxisSize.min, // 버튼 안의 내용에 맞게 너비를 설정
        children: [
          Image.asset('asset/img/logo/kakao_logo.png', height: 20), // 카카오 로고 이미지
          SizedBox(width: 8),
          Text('카카오톡으로 로그인'), // 고정된 텍스트
        ],
      ),
    );
  }

  void _loginWithKakao(BuildContext context) { // context를 매개변수로 받음
    // 소셜 로그인 코드 작성해야 함

    // 임시 알림
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('준비중입니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 대화상자를 닫습니다.
              },
            ),
          ],
        );
      },
    );
  }
}
