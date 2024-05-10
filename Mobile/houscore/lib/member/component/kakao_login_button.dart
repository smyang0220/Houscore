import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/view/root_tab.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../common/const/data.dart';
import '../../common/secure_storage/secure_storage.dart';
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
            if (await isKakaoTalkInstalled()) {
              // 카카오가 설치됐을때
              try {
                print(await KakaoSdk.origin);
                OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
                print('로그인 성공');
                print("엑세스토큰 ${token.accessToken}");
                print("리프레시토큰 ${token.refreshToken}");
                final refreshToken = token.accessToken;
                final accessToken = token.refreshToken;
                final storage = ref.read(secureStorageProvider);
                await storage.write(
                    key: REFRESH_TOKEN_KEY, value: refreshToken);
                await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RootTab(),
                  ),
                );
              } catch (error) {
                print('로그인 실패 $error');
                if (error is PlatformException && error.code == 'CANCELED') {
                  return;
                }
                try {
                  print(await KakaoSdk.origin);
                  OAuthToken token =
                  await UserApi.instance.loginWithKakaoAccount();
                  print('로그인 성공 ${token.accessToken}');
                } catch (error) {
                  throw Error();
                }
              }
            } else {
              // 카카오가 설치 안됐을때
              try {
                print(await KakaoSdk.origin);
                OAuthToken token =
                await UserApi.instance.loginWithKakaoAccount();
                print('로그인 성공 ${token.accessToken}');
              } catch (error) {
                throw Error();
              }
            }
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
Future<void> signInWithKakao(Ref ref) async {
  if (await isKakaoTalkInstalled()) {
    // 카카오가 설치됐을때
    try {
      print(await KakaoSdk.origin);
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('로그인 성공');
      print("엑세스토큰 ${token.accessToken}");
      print("리프레시토큰 ${token.refreshToken}");
      final refreshToken = token.accessToken;
      final accessToken = token.refreshToken;
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
    } catch (error) {
      print('로그인 실패 $error');
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      try {
        print(await KakaoSdk.origin);
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('로그인 성공 ${token.accessToken}');
      } catch (error) {
        throw Error();
      }
    }
  } else {
    // 카카오가 설치 안됐을때
    try {
      print(await KakaoSdk.origin);
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('로그인 성공 ${token.accessToken}');
    } catch (error) {
      throw Error();
    }
  }
}