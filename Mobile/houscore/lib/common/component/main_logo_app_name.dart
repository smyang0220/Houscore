import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

class MainLogoAppName extends StatelessWidget {
  const MainLogoAppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'asset/img/logo/main_logo.png',
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Text(
              ' HOUSCORE',
              style: TextStyle(
                fontFamily: 'SingleDay',
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: PRIMARY_COLOR,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '당신의 집, 이제 점수로 만나보세요!',
                style: TextStyle(
                  fontFamily: 'NotoSans', // SingleDay 폰트 사용
                  fontSize: 18, // 원하는 폰트 크기로 지정
                  fontWeight: FontWeight.bold, // 원하는 폰트 두께로 지정
                  color: Colors.black, // 원하는 폰트 색상으로 지정
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
