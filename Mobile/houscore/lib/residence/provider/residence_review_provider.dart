import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/provider/parameter_provider.dart';
import 'package:houscore/residence/model/residence_review_model.dart';
import 'package:houscore/residence/repository/residence_review_repository.dart';
import 'package:houscore/review/model/review_model.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/provider/pagination_provider.dart';

final residenceReviewProvider = StateNotifierProvider<
    ResidenceReviewStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(residenceReviewRepositoryProvider);
  final param = ref.watch(paginationParameterProvider);

  return ResidenceReviewStateNotifier(repository: repo, params: param);
});

class ResidenceReviewStateNotifier
    extends PaginationProvider<ResidenceReviewModel, ResidenceReviewRepository> {
  ResidenceReviewStateNotifier({
    required super.repository,
    required super.params,
  });
}