import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/review/model/review_to_update_model.dart';
import '../../common/const/data.dart';
import '../../common/dio/dio.dart';
import 'package:houscore/review/model/review_model.dart';
import 'package:retrofit/retrofit.dart';

import '../model/my_review_model.dart';
import '../model/user_validation.dart';
part 'review_repository.g.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>(
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
    //TODO return 타입 확인 필요
    @Query("id") required int id,
  });

  /*
   리뷰 수정
   */
  @PUT('')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> updateReview({
    @Body() required ReviewToUpdateModel reviewModel,
  });

  /*
   리뷰 등록
   */
  @POST('')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserValidation> createOneReview({
    @Body() required ReviewModel reviewModel,
  });
  
  /*
   리뷰 등록 테스트
   */
  @POST('')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserValidation> createTestOneReview({
    @Body() required Map<String, dynamic> testCreate,
  });

  /*
   리뷰 삭제
   */
  @DELETE('')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> deleteReview({
    @Query("id") required int id,
  });

  /*
   내가 쓴 리뷰 리스트 조회
   */
  @GET('/my-review')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<MyReviewModel>> readMyReviews();

  /*
   최근 리뷰 조회
   */
  @GET('/recent')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<MyReviewModel>> recentReviews();
}
