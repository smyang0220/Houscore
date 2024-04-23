import 'package:flutter/material.dart';
import 'common/view/splash_screen.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false, // 우측 상단 Beta 지우기
      home: SplashScreen(), // 우선 SplashScreen으로 시작
    );
  }
}
