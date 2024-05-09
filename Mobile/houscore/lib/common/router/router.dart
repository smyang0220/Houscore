import 'package:go_router/go_router.dart';
import 'package:houscore/common/view/splash_screen.dart';
import 'package:houscore/member/view/login_screen.dart';

final router = GoRouter(
  routes : [
    GoRoute(
        path : '/', // 홈
        builder : (context, state) {
          // 이동할 페이지 정의
          return SplashScreen();
        },
        routes:[
          GoRoute(
              path : 'login', // /basic으로 됨
              builder : (context, state) {
                return LoginScreen();
              }
          )
        ]
    )
  ],
);