import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemChrome을 사용하기 위해 필요
import 'common/view/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 바인딩 초기화
  SystemChrome.setPreferredOrientations([ // 화면 방향 설정
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const _App()); // 모든 초기화 후 앱 실행
  });
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
