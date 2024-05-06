import 'package:dio/dio.dart' hide Headers;
// 다른 라이브러리나 모듈에서 이름 충돌 방지!
// 이 경우에는 Retrofit과의 충돌 방지!
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/residence_detail_indicators_model.dart';
import 'package:houscore/common/model/cursor_pagination_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';
import '../../common/dio/dio.dart';

part 'residence_detail_indicators_repository.g.dart';

// 통신을 위한 객체를 제공함
final residenceDetailIndicatorsRepositoryProvider = Provider<ResidenceDetailIndicatorsRepository>(
      (ref) {
    final dio = ref.watch(dioProvider);
    final repository =
    ResidenceDetailIndicatorsRepository(dio, baseUrl: 'http://$ip/api/residence');

    return repository;
  },
);

// Retrofit 인터페이스
// build_runner가 build 시에 이 추상 클래스의 인스턴스를 생성해줌 as g 파일 by JsonSerializableGenerator
@RestApi()
abstract class ResidenceDetailIndicatorsRepository {
  factory ResidenceDetailIndicatorsRepository(Dio dio, {String baseUrl}) =
  _ResidenceDetailIndicatorsRepository;

  // 요청 url
  @GET('/detail/indicator')
  // 헤더 설정
  @Headers({
    'accessToken': 'true',
  })
  // get 함수 // 비동기적 통신을 위한 Future 반환
  Future<ResidenceDetailIndicatorsModel> getResidenceDetailIndicator({
    // request로 address가 필요!
    @Query('address') required String address,
  });
}
