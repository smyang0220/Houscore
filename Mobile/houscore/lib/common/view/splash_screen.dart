import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/const/data.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/common/view/root_tab.dart';
import 'package:houscore/member/view/login_screen.dart';
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
class SplashScreen extends ConsumerWidget{
  static String get routeName => 'splash';
  // 위젯 생성될 때 호출
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
