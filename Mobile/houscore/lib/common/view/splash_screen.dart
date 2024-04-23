import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/const/data.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/common/view/root_tab.dart';
import 'package:houscore/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 초기 대기 화면

// 순서
/*
1. SplashScreen 생성자
2. createState()로 SplashScreen의 상태 생성
3. initState() 상태 초기화
4. build() 로 UI 생성
=> 이 후 위젯트리 상 업데이트 시 마다 build()
ex) setState()
 */


// Q) 왜 StatefulWidget으로 만들었나? 단순 대기화면 아닌가?
/*
SplashScreen에서는 아래와 같은 것들이 가능하기 때문에 StatefulWidget으로 만드는 것이 바람직!
1) 비동기 작업 실행
  초기 설정, 데이터 로딩, 보안 절차 등을 수행할 수 있음
  ex) 사용자 로그인 상태 확인 / 메인화면에 필요한 데이터들 미리 불러오기
2) 애니메이션 처리
  애니메이션 자체도 상태값을 가지기 때문에 이를 관리하기 위해선 SplashScreen이 StatefulWidget이어야 함!
3) 사용자 인터렉션
  드물지만 SplashScreen에서 사용자 인터렉션을 통해 특정 동작을 수행하기 위한 상태값이 필요할 때가 있음!
 */
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// SplashScreen의 상태를 관리하는 클래스
class _SplashScreenState extends State<SplashScreen> {
  // 위젯 생성될 때 호출
  @override
  void initState() {
    super.initState();

    // 토큰 삭제 - 보안 강화 원하면 어플리케이션 시작 때마다 새로 인증하도록 할 수 있음!
    // deleteToken();

    // 그냥 로그인 화면으로 가게끔하는 임시용 화면
    goToLogin();

    // 토큰 생성
    // checkToken();
  }

  // 임시용
  void goToLogin() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
    });
  }


  void deleteToken() async {
    await storage.deleteAll();
  }

  void checkToken() async {
    // FlutterSecureStorage에서 토큰들 읽어옴
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    // HTTP 클라이언트 라이브러리
    final dio = Dio();

    // 토큰 유효성 확인을 거쳐 인증 // 유효하지 않을 경우 새로운 액세스 토큰을 받아옴
    try{
      final resp = await dio.post(
        'http://$ip/auth/token',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ),
      );

      // post 요청 성공한 경우
      // 새로운 AccessToken storage에 저장
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      // 새로운 화면을 Navigation Stack에 추가하고 그 외의 것들은 전부 제거
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          // 익명 함수
          builder: (_) => RootTab(),
        ),
            // 현재 route 제외 모든 route 스택에서 제거 => 이전화면이라는 게 없어짐
            (route) => false,
      );
    }
    // post요청 실패 시 로그인 페이지로 이동
    catch(e) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'asset/img/logo/main_logo_only.svg',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            Text(
              'HOUSCORE',
              style: TextStyle(
                fontFamily: 'SingleDay', // SingleDay 폰트 사용
                fontSize: 48, // 원하는 폰트 크기로 지정
                fontWeight: FontWeight.bold, // 원하는 폰트 두께로 지정
                color: Colors.white, // 원하는 폰트 색상으로 지정
              ),
            ),
            Text(
              '집에 관한 모든 것',
              style: TextStyle(
                fontFamily: 'NotoSans', // SingleDay 폰트 사용
                fontSize: 24, // 원하는 폰트 크기로 지정
                fontWeight: FontWeight.bold, // 원하는 폰트 두께로 지정
                color: Colors.white, // 원하는 폰트 색상으로 지정
              ),
            ),
            // const SizedBox(height: 16.0),
            // CircularProgressIndicator(
            //   color: Colors.white,
            // ),
          ],
        ),
      ),
    );
  }
}
