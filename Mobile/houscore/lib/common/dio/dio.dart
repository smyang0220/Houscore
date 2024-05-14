import 'package:houscore/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../member/provider/auth_provider.dart';
import '../secure_storage/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(storage: storage, ref: ref),
  );

  return dio;
});

// 인터셉터 클래스
class CustomInterceptor extends Interceptor {
  // 토큰 저장소
  final FlutterSecureStorage storage;
  final Ref ref;
  CustomInterceptor({
    required this.ref,
    required this.storage,
  });

  // 1) 요청을 보낼때
  // 요청이 보내질때마다
  // 만약에 요청의 Header에 accessToken: true라는 값이 있다면(요청 시 accessToken이 필요하다는 뜻!)
  // 실제 토큰을 가져와서 (storage에서) authorization: bearer $token으로
  // 헤더를 변경한다.

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 요청 방식과 url 로깅
    // print('[REQ] [${options.method}] ${options.uri}');

    // 인증 토큰 적용
    if (options.headers['accessToken'] == 'true') {
      // 실제 요청에서는 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      // print("저장된 엑세스 토큰값 : $token");
      // 실제 토큰으로 대체한 authorization 헤더 추가
      options.headers.addAll({
        'accessToken': "Bearer $token",
      });
    }

    // refresh token도 마찬가지 로직
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      // print("저장된 리프레시 토큰값 : $token");

      options.headers.addAll({
        'refreshToken': "Bearer $token",
      });
    }

    // 요청의 계속 처리를 위한 파이프라인 다음 단계로의 요청 전달
    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 응답 방식과 url 로깅
    // print(
    //     '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때 (status code) // 유효하지 않은 자격 증명
    // 토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을한다.

    // 요청 방식과 url 로깅 with ERR sign
    // print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    // print('[ERR CODE] ${err.response?.statusCode}');
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    // print("에러떴을때의 리프레시 토큰값 : $refreshToken");
    // refreshToken 아예 없으면 당연히 에러를 던진다
    if (refreshToken == null) {
      // 에러를 던질때는 handler.reject를 사용한다.
      // 여기서 handler는 에러 발생시 인터셉트 후 처리를 하는 역할
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/refresh';

    // print("에러코드 ${err.response?.statusCode}");
    if (isStatus401 && !isPathRefresh) {
      // print("401에 걸림");
      final dio = Dio();
      try {
        final resp = await dio.get(
          'http://$ip/api/member/refresh',
          options: Options(
            headers: {
              'refreshToken': refreshToken,
            },
          ),
        );
        // print("리프레시 재발급 통신 후");

        final accessToken = resp.data['accessToken'];

        // print("에러떴을때 발급받은 엑세스 토큰값 : $accessToken");
        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'accessToken': "Bearer $accessToken",
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioException catch (e) {
        ref.read(authProvider.notifier).logout();
        
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
