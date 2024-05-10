import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import '../../../common/const/data.dart';
import '../../../common/dio/dio.dart';
import '../model/interested_area.dart';


part 'myinfo_repository.g.dart';

final myinfoRepositoryProvider = Provider<MyinfoRepository>(
      (ref) {
    final dio = ref.watch(dioProvider);
    final repository =
    MyinfoRepository(dio, baseUrl: 'http://$ip/api/myinfo');

    return repository;
  },
);

@RestApi()
abstract class MyinfoRepository {
  factory MyinfoRepository(Dio dio, {String baseUrl}) =
  _MyinfoRepository;

  // [내 정보 상세 조회] ---------------------------------------
  // 요청 url
  // @GET('')
  // // 헤더 설정
  // @Headers({
  //   'accessToken': 'true',
  // })
  // // get 함수 // 비동기적 통신을 위한 Future 반환
  // Future<MyinfoModel> getMyinfo();

  // [관심지역 리스트 조회] ---------------------------------------
  // 요청 url
  @GET('/area')
  // 헤더 설정
  @Headers({
    'accessToken': 'true',
  })
  // get 함수 // 비동기적 통신을 위한 Future 반환
  Future<List<InterestedArea>> getInterestedAreaList();

  // [관심지역 등록] ---------------------------------------
  @POST('/area')
  @Headers({
    'accessToken': 'true',
  })
  Future<bool> registerInterestedArea(@Body() String memberId);

  // [관심지역 삭제] ---------------------------------------
  @DELETE('/area')
  @Headers({
    'accessToken': 'true',
  })
  Future<bool> deleteInterestedArea(@Body() int areaId);
}
