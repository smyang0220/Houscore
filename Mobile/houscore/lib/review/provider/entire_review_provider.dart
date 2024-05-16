import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/provider/parameter_provider.dart';
import 'package:houscore/residence/model/residence_review_model.dart';
import 'package:houscore/residence/repository/residence_review_repository.dart';
import 'package:houscore/review/model/review_model.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/provider/pagination_provider.dart';
import '../repository/entire_review_repository.dart';

final entireReviewProvider = StateNotifierProvider<
    EntireReviewStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(entireReviewRepositoryProvider);
  final param = ref.watch(paginationParameterProvider);

  return EntireReviewStateNotifier(repository: repo, params: param);
});

class EntireReviewStateNotifier
    extends PaginationProvider<ResidenceReviewModel, EntireReviewRepository> {
  EntireReviewStateNotifier({
    required super.repository,
    required super.params,
  });
}