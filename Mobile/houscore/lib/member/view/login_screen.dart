import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/common/view/root_tab.dart';
import 'package:houscore/member/provider/user_me_provider.dart';
import '../../common/component/custom_test_form_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../component/kakao_login_button.dart';
import '../component/non_member_button.dart';

class LoginScreen extends ConsumerWidget {
  static String get routeName => 'login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final state = ref.watch(userMeProvider);

    return DefaultLayout(
      // backgroundColor: PRIMARY_COLOR,
      backgroundColor: Colors.white,
      // 자식이 하나인 스크롤 뷰 == 전체 스크롤 가능
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        // 상태표시 줄, 노치 등 침범하지 않게 SafeArea안에 넣기
        child: SafeArea(
          // 상단만 안전영역 설정
          top: true,
          bottom: false,
          // 모든 방향 패딩 8
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            // 컴포넌트들 수직 배치
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
                    // color: Colors.white, // 원하는 폰트 색상으로 지정
                    color: PRIMARY_COLOR, // 원하는 폰트 색상으로 지정
                  ),
                ),
                Text(
                  '집에 관한 모든 것',
                  style: TextStyle(
                    fontFamily: 'NotoSans', // SingleDay 폰트 사용
                    fontSize: 24, // 원하는 폰트 크기로 지정
                    fontWeight: FontWeight.bold, // 원하는 폰트 두께로 지정
                    // color: Colors.white, // 원하는 폰트 색상으로 지정
                    color: PRIMARY_COLOR, // 원하는 폰트 색상으로 지정
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: KakaoLoginButton(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: NonMemberButton(
                        onPressed: () {
                          context.go('home');
                        },
                        text: '비회원으로 계속', // 필요한 경우 이 부분을 통해 버튼 텍스트를 변경할 수 있습니다.
                      )
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


