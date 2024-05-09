import 'package:dio/dio.dart' hide Headers;
// 다른 라이브러리나 모듈에서 이름 충돌 방지!
// 이 경우에는 Retrofit과의 충돌 방지!
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/member/model/interested_area.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';
import '../../common/dio/dio.dart';
import '../model/member_info_model.dart';

part 'member_repository.g.dart';

// 통신을 위한 객체를 제공함
final memberRepositoryProvider = Provider<MemberRepository>(
      (ref) {
    final dio = ref.watch(dioProvider);
    final repository =
    MemberRepository(dio, baseUrl: 'http://$ip/api/myinfo');

    return repository;
  },
);

// Retrofit 인터페이스
// build_runner가 build 시에 이 추상 클래스의 인스턴스를 생성해줌 as g 파일 by JsonSerializableGenerator
@RestApi()
abstract class MemberRepository {
  factory MemberRepository(Dio dio, {String baseUrl}) =
  _MemberRepository;

  // [내 정보 상세 조회] ---------------------------------------
  // 요청 url
  @GET('')
  // 헤더 설정
  @Headers({
    'accessToken': 'true',
  })
  // get 함수 // 비동기적 통신을 위한 Future 반환
  Future<MemberInfo> getMemberInfo();

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
