import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/building/model/building_detail_model.dart';
import 'package:houscore/common/model/cursor_pagination_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';
import '../../common/dio/dio.dart';

part 'kakao_login_repository.g.dart';

final kakaoLoginRepositoryProvider = Provider<KakaoLoginRepository>(
      (ref) {
    final dio = ref.watch(dioProvider);
    final repository =
    KakaoLoginRepository(dio, baseUrl: 'http://$ip/api/member');

    return repository;
  },
);

@RestApi()
abstract class KakaoLoginRepository {
  factory KakaoLoginRepository(Dio dio, {String baseUrl}) =
  _KakaoLoginRepository;

  @POST("/login/kakao")
  @Headers({
    'accessToken': 'false',
  })
  Future<void> loginKakao({
    @Body() required Map<String, dynamic> data,
  });

  @GET("/refresh")
  @Headers({
    'refreshToken': 'true',
  })
  Future<void> refreshKakao();

}
