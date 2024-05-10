import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/building/model/building_detail_model.dart';
import 'package:houscore/common/model/cursor_pagination_model.dart';
import 'package:retrofit/retrofit.dart';
import '../../common/const/data.dart';
import '../../common/dio/dio.dart';
import '../../common/model/login_response.dart';
import '../model/member_search_model.dart';

part 'member_repository.g.dart';

final memberRepositoryProvider = Provider<MemberRepository>(
      (ref) {
    final dio = ref.watch(dioProvider);
    final repository =
    MemberRepository(dio, baseUrl: 'http://$ip/api/member');

    return repository;
  },
);

@RestApi()
abstract class MemberRepository {
  factory MemberRepository(Dio dio, {String baseUrl}) =
  _MemberRepository;

  @POST("/login/kakao")
  @Headers({
    'accessToken': 'false',
  })
  Future<LoginResponse> loginKakao({
    @Body() required Map<String, dynamic> data,
  });

  @GET("/refresh")
  @Headers({
    'refreshToken': 'true',
  })
  Future<void> refreshKakao();

  @GET("/search")
  @Headers({
    'accessToken': 'true',
  })
  Future<List<MemberSearchModel>> searchMember(
  @Query("memberEmail") String memberEmail,
  );

}
