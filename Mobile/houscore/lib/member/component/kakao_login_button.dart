import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/utils/data_utils.dart';
import 'package:houscore/common/view/root_tab.dart';
import 'package:houscore/common/model/login_response.dart';
import 'package:houscore/member/provider/user_me_provider.dart';
import 'package:houscore/member/repository/member_repository.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../common/const/data.dart';
import '../../common/secure_storage/secure_storage.dart';
import '../../residence/repository/residence_repository.dart';

class KakaoLoginButton extends ConsumerStatefulWidget {
  const KakaoLoginButton({Key? key}) : super(key: key);

  @override
  ConsumerState<KakaoLoginButton> createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends ConsumerState<KakaoLoginButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            OAuthToken token;
            LoginResponse resp;
            if (await isKakaoTalkInstalled()) {
              // 카카오가 설치됐을때
              try {
                token = await UserApi.instance.loginWithKakaoTalk();
              } catch (error) {
                print('로그인 실패 $error');
                if (error is PlatformException && error.code == 'CANCELED') {
                  return;
                }
                try {
                  token = await UserApi.instance.loginWithKakaoAccount();
                } catch (error) {
                  throw Error();
                }
              }
            } else {
              // 카카오가 설치 안됐을때
              try {
                token = await UserApi.instance.loginWithKakaoAccount();
              } catch (error) {
                throw Error();
              }
            }
            try {
              final repository = ref.watch(memberRepositoryProvider);

              // 카카오토큰 백엔드로 전송
              ref.read(userMeProvider.notifier).login(
                  refreshToken: '${token.refreshToken}',
                  accessToken: '${token.accessToken}'
              );

              // 엑세스토큰이 제대로된 값인지 만든 임시 로직
              // print("건물 검색 도과자");
              // final repository2 = ref.watch(residenceRepositoryProvider);
              // print("레포지토리 선언 완료");
              // final result2 = await repository2.getResidenceDetail(address: "서울특별시 강남구 개포동 12번지", lat: 37.49456430167525, lng: 127.07536876387186);
              // print("건물 검색 완료");
              // print(result2.newPlatPlc);
              // final result =
              //     await repository.searchMember("cnhug3@naver.com");
              // print("검색완료");
              // print(result[0].memberName);
            } catch (e) {
              print("카카오 로그인 실패 $e");
            }
            // print("리프레시 보내기 전");
            // final repository = ref.watch(kakaoLoginRepositoryProvider);
            // final resp = repository.refreshKakao();
            // print("리프레시 보낸 후");
            // print(resp['header']);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RootTab(),
              ),
            );
          },
//thing to do

          child: Card(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            elevation: 2,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(7),
              ), // BoxDecoration
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(
                  'asset/img/logo/kakao_login_medium_wide.png',
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ]), // Row
            ), //
          ),
        ),
      ],
    );
  }
}
