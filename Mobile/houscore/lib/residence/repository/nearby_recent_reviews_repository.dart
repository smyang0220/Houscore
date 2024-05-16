import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/model/data_list_params.dart';
import 'package:houscore/common/repository/base_data_list_repository.dart';
import 'package:houscore/review/model/homescreen_review_model.dart';
import 'package:retrofit/retrofit.dart';
import '../../common/const/data.dart';
import '../../common/dio/dio.dart';

part 'nearby_recent_reviews_repository.g.dart';

// 통신을 위한 객체를 제공함
final nearbyRecentReviewsRepositoryProvider = Provider<NearbyRecentReviewsRepository>(
      (ref) {
    final dio = ref.watch(dioProvider);
    final repository =
    NearbyRecentReviewsRepository(dio, baseUrl: 'http://$ip/api/residence');

    return repository;
  },
);

// Retrofit 인터페이스
// build_runner가 build 시에 이 추상 클래스의 인스턴스를 생성해줌 as g 파일 by JsonSerializableGenerator
@RestApi()
abstract class NearbyRecentReviewsRepository implements IBaseDataListRepository<HomescreenReviewModel> {
  factory NearbyRecentReviewsRepository(Dio dio, {String baseUrl}) =
  _NearbyRecentReviewsRepository;

  @GET('/main/nearby')
  // 헤더 설정
  @Headers({
    'accessToken': 'true',
  })
  Future<List<HomescreenReviewModel>> fetchDataList({
    @Queries() DataListParams? dataListParams = const DataListParams()
  });

}
