import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemChrome을 사용하기 위해 필요
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'common/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 바인딩 초기화

  KakaoSdk.init(
    nativeAppKey: '9be0dbc80cce4d34bd4dae40010dacb6',
    javaScriptAppKey: '6291268ed3dc5224d56ed06634b9942c',
  );

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
    // MaterialApp의 경우
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false, // 우측 상단 Beta 지우기
      home: SplashScreen(), // 우선 SplashScreen으로 시작
    );
  }
}
/*
routes와 initialRoute를 활용해서 구성할 수도 있음
 */
