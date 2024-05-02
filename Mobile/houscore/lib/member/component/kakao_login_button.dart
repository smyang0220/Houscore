import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houscore/common/view/root_tab.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginButton extends StatefulWidget {
  const KakaoLoginButton({Key? key}) : super(key: key);

  @override
  State<KakaoLoginButton> createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<KakaoLoginButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          getKakaoLoginButton(context),
        ],
      );
  }
}

Widget getKakaoLoginButton(BuildContext context) {
  return InkWell(
    onTap: () async {
      try{
        await signInWithKakao(); // 기존에 있던것, 그 외는 0215새로 생김
/*
        String token = stringToBase64.encode(rawString);

        final resp = await dio.post(
          'http://$ip/auth/login',
          options: Options(
            headers: {
              'authorization': 'Basic $token',
            },
          ),
        );

        final refreshToken = resp.data['refreshToken'];
        final accessToken = resp.data['accessToken'];

        final storage = ref.read(secureStorageProvider);

        await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RootTab(),
          ),
        ); */


        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RootTab()));
      }catch(e){
        print("로그인 실패");
      }
    },
//thing to do

    child: Card(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      elevation: 2,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(7),
        ), // BoxDecoration
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('asset/img/logo/kakao_login_medium_wide.png', height: 30 ,width: MediaQuery.of(context).size.width * 0.7,),
        ]), // Row
      ), //
    ),
  );
}

Future<void> signInWithKakao() async {
  if (await isKakaoTalkInstalled()) {
    // 카카오가 설치됐을때
    try {
      print(await KakaoSdk.origin);
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('로그인 성공 ${token.accessToken}');
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
  } else { // 카카오가 설치 안됐을때
    try {
      print(await KakaoSdk.origin);
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('로그인 성공 ${token.accessToken}');
    } catch (error) {
      throw Error();
    }
  }
}