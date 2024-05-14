import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/view/home_screen.dart';
import 'package:houscore/member/provider/user_me_provider.dart';
import '../../common/view/root_tab.dart';
import '../../common/view/splash_screen.dart';
import '../../member/model/member_search_model.dart';
import '../../member/view/login_screen.dart';
import '../../residence/view/residence_detail.dart';
import '../../review/view/my_review_list.dart';
// push
final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: RootTab.routeName,
      builder: (_, __) => RootTab(),
      routes: [
        GoRoute(
          path: 'myReviews',
          builder: (context, state) => MyReviewList(),
        ),
      ],
    ),
    GoRoute(
      path: '/residence/:address',
      builder: (context, state) {
        final address = state.pathParameters['address']!;
        return ResidenceDetail(address: address);
      },
    ),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen(),
    ),
  ];

  void logout(){
    ref.read(userMeProvider.notifier).logout();
  }

  // SplashScreen
  // 앱을 처음 시작했을때
  // 토큰이 존재하는지 확인하고
  // 로그인 스크린으로 보내줄지
  // 홈 스크린으로 보내줄지 확인하는 과정이 필요하다.
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logginIn = state.location == '/login';

    // 유저 정보가 없는데
    // 로그인중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      print("user==null");
      return logginIn ? null : '/login';
    }

    // 여기서부턴 user가 null이 아님

    // UserModel
    // 사용자 정보가 있는 상태면
    // 로그인 중이거나 현재 위치가 SplashScreen이면
    // 홈으로 이동
    if (user is MemberSearchModel) {
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    // UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return '/login';
  }
}