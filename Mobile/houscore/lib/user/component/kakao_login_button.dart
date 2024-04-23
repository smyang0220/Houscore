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
          getKakaoLoginButton(context), // 0215 새로생김
        ],
      );
  }
}

Widget getKakaoLoginButton(BuildContext context) {
  return InkWell(
    onTap: () async {
      try{
        await signInWithKakao(); // 기존에 있던것, 그 외는 0215새로 생김
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
  print("10");
  if (await isKakaoTalkInstalled()) {
    print("설치됨");
    try {
      print(await KakaoSdk.origin);
      print('출력완료');
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공 ${token.accessToken}');
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      if (error is PlatformException && error.code == 'CANCELED') {
        print("체크1");
        return;
      }
      try {
        print(await KakaoSdk.origin);
        print('출력완료');
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        print("체크2");
        throw Error();
      }
    }
  } else {
    print("설치안됨");
    try {
      print("else");
      print(await KakaoSdk.origin);
      print('출력완료');
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공 ${token.accessToken}');
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
      print("체크3");
      throw Error();
    }
  }
}