import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/residence/model/pagination_params.dart';

import '../provider/pagination_provider.dart';
import '../provider/parameter_provider.dart';

class PaginationUtils {
  static Future<void> paginate({
    required StateController<int> numberprovider,
    required ScrollController controller,
    required PaginationProvider provider,
  }) async {
    if (controller.offset == controller.position.maxScrollExtent) {
      int page = await numberprovider.state++;
      provider.paginate(
        fetchMore: true,
        page : page + 1
      );
    }

    if (controller.offset < -100) {
      print(
        "새로고침"
      );
      provider.paginate(
        forceRefetch : true,
      );
    }

  }
}