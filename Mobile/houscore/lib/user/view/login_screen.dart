import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/common/view/root_tab.dart';
import '../../common/component/custom_test_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child:
    SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Title(),
              const SizedBox(height: 16.0,),
              _SubTitle(),
              Image.asset('asset/img/misc/logo.png', width: MediaQuery.of(context).size.width / 3 * 2,),
              CustomTextFormField(hintText: '이메일을 입력해주세요.', onChanged: (String value) {  },),
              const SizedBox(height: 16.0,),
              CustomTextFormField(hintText: '비밀번호를 입력해주세요.', onChanged: (String value) {  },obscureText: true,),
              const SizedBox(height: 16.0,),
              ElevatedButton(
                  onPressed: (){

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RootTab())
                    );

                  },
                  style: ElevatedButton.styleFrom(
                backgroundColor: PRIMARY_COLOR,
              ),
                  child: Text(
                      '로그인'
                  )
              ),
              TextButton(onPressed: (){},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black
                  ),
                  child: Text('회원가입'))
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('환영합니다',
    style: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w500,
      color: Colors.black
    ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('이메일과 비밀번호를 입력해서 로그인 해주세요! \n 하라면 하라고 이쨧;ㄱ아',
      style: TextStyle(
          fontSize: 16,
          color: BODY_TEXT_COLOR,
      ),
    );
  }
}