import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'; // SystemChrome을 사용하기 위해 필요
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'common/view/splash_screen.dart'; // SplashScreen의 경로에 따라 수정해주세요.

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 바인딩 초기화

  KakaoSdk.init(
    nativeAppKey: 'f8e1285dd805d944e38eb1d45c5828ea',
    javaScriptAppKey: '5f2fbbc85d5b81134644be60613eae1f',
  );

  SystemChrome.setPreferredOrientations([ // 화면 방향 설정
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      ProviderScope(child: const _App()), // 모든 초기화 후 앱 실행 with ProviderScope
    );
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
      debugShowCheckedModeBanner: false, // 우측 상단 '디버그' 배지 제거
      home: SplashScreen(), // 우선 SplashScreen으로 시작합니다.
    );
  }
}
