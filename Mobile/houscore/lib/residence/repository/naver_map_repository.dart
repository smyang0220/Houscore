import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../env.dart';

part 'naver_map_repository.g.dart';

final naverMapRepositoryProvider = Provider<NaverMapRepository>((ref) {
  final dio = Dio(); // Instance of Dio
  // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true)); // 로그 인터셉터 // 개발시에만 활성화!
  dio.options.headers['X-NCP-APIGW-API-KEY-ID'] = Env.API_KEY_ID;
  dio.options.headers['X-NCP-APIGW-API-KEY'] = Env.API_KEY;
  return NaverMapRepository(dio,
      baseUrl: 'https://naveropenapi.apigw.ntruss.com');
});

@RestApi()
abstract class NaverMapRepository {
  factory NaverMapRepository(Dio dio, {String baseUrl}) = _NaverMapRepository;

  @GET("/map-reversegeocode/v2/gc")
  Future<HttpResponse> getAddressFromLatLng(
    @Queries() Map<String, dynamic> queries,
  );
  
  @GET("/map-geocode/v2/geocode")
  Future<HttpResponse> getLatLngFromAddress(
      @Query("query") String address,
  );
}
