import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/building/model/building_detail_model.dart';
import 'package:houscore/common/model/cursor_pagination_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';
import '../../common/dio/dio.dart';

part 'building_repository.g.dart';

final buildingRepositoryProvider = Provider<BuildingRepository>(
      (ref) {
    final dio = ref.watch(dioProvider);
    final repository =
    BuildingRepository(dio, baseUrl: 'http://$ip/api/building');

    return repository;
  },
);

@RestApi()
abstract class BuildingRepository {
  factory BuildingRepository(Dio dio, {String baseUrl}) =
  _BuildingRepository;

  @GET('/detail')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<BuildingDetailModel>> getBuildingDetail({
    @Query('address') required String address,
  });
}
