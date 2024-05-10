import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';
import '../../common/dio/dio.dart';
import '../../common/model/login_response.dart';
import '../../common/model/token_response.dart';
import '../../common/utils/data_utils.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(baseUrl: 'http://$ip/api/member', dio: dio);
});

class AuthRepository {
  // http://$ip/auth
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<LoginResponse> login({
    required String accessToken,
    required String refreshToken,
  }) async {
    final resp = await dio.post(
      '$baseUrl/login/kakao',
      data: {
        "accessToken": accessToken, // accessToken
        "refreshToken": refreshToken, // refreshToken
      },
      options: Options(
        headers: {
          'accessToken': 'false',
        },
      ),
    );
    if (resp.statusCode == 200) {
      return LoginResponse.fromJson(resp.data);
    } else {
      throw Exception('Failed to login with Kakao: ${resp.statusCode}');
    }
  }

  Future<TokenResponse> token() async {
    final resp = await dio.post(
      '$baseUrl/refresh',
      options: Options(
        headers: {
          'refreshToken': 'true',
        },
      ),
    );

    return TokenResponse.fromJson(resp.data);
  }
}
