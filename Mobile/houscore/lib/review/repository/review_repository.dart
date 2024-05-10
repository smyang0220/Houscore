import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/const/data.dart';
import '../../common/dio/dio.dart';
import 'package:houscore/review/model/review_model.dart';
import 'package:retrofit/retrofit.dart';

part 'review_repository.g.dart';

final ReviewRepositoryProvider = Provider<ReviewRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    final repository = ReviewRepository(dio, baseUrl: 'http://$ip/api/review');

    return repository;
  },
);

//retrofit 인터페이스
//build_runner가 build 시에 이 추상 클래스의 인스턴스를 생성해줌 -> g 파일 by JsonSerializableGenerator
@RestApi()
abstract class ReviewRepository {
  factory ReviewRepository(Dio dio, {String baseUrl}) = _ReviewRepository;

  /*
   리뷰 상세 내용 조회
   */
  @GET('')
  @Headers({
    'accessToken': 'true',
  })
  Future<ReviewModel> reviewDetail({
    @Query("id") required int id,
  });

  /*
   거주지 리뷰 수정
   */
  @PUT('')
  @Headers({
    'accessToken': 'true',
  })
  Future<ReviewModel> updateReview({
    @Body() required ReviewModel reviewModel,
  });

  /*
   거주지 리뷰 등록
   */
  @POST('')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> createOneReview({
    @Body() required ReviewModel reviewModel,
  });

  /*
   리뷰 상세 내용 조회
   */
  @DELETE('')
  @Headers({
    'accessToken': 'true',
  })
  Future<ReviewModel> deleteReview({
    @Query("id") required int id,
  });
}
