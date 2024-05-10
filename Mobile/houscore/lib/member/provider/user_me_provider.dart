
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../common/const/data.dart';
import '../../common/secure_storage/secure_storage.dart';
import '../../common/utils/data_utils.dart';
import '../model/member_search_model.dart';
import '../repository/auth_repository.dart';
import '../repository/member_repository.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>(
      (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final memberRepository = ref.watch(memberRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);

    return UserMeStateNotifier(
      authRepository: authRepository,
      repository: memberRepository,
      storage: storage,
    );
  },
);

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final MemberRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    // 내 정보 가져오기
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      return;
    }

    final resp = await repository.searchMember("smyang0220@naver.com");

    state = resp[0];
  }

  Future<UserModelBase> login({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
          accessToken: accessToken ,
          refreshToken: refreshToken
      );

      final payload = DataUtils.parseJwtPayload(resp.accessToken);

      await Future.wait([
        storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken),
        storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken),
        storage.write(key: USER_EMAIL_KEY, value: payload['sub']),
        storage.write(key: USER_NAME_KEY, value: payload['userName']),
      ]);


      final userResp = await repository.searchMember("smyang0220@naver.com");

      state = userResp[0];

      return userResp[0];
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait(
      [
        storage.delete(key: REFRESH_TOKEN_KEY),
        storage.delete(key: ACCESS_TOKEN_KEY),
      ],
    );
  }
}
