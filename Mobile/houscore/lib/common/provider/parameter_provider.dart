import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/residence/model/pagination_params.dart';

final paginationParameterProvider = StateNotifierProvider<PaginationParamsNotifier, PaginationParams>((ref) => PaginationParamsNotifier());

class PaginationParamsNotifier extends StateNotifier<PaginationParams> {
  PaginationParamsNotifier() : super(PaginationParams(
    address: '초기 주소',
    page: 0,
    size: 5,
  ));

  void updateParams({String? address, int? page, int? size}) {
    print("updateParams 진입");
    state = PaginationParams(
      address: address ?? state.address,
      page: page ?? (state.page as int) + 1,
      size: size ?? state.size,
    );

  }
}
