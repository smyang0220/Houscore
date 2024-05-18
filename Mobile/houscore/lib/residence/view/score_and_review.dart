import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/common/model/cursor_pagination_model.dart';
import 'package:houscore/residence/component/residence_review_card.dart';
import 'package:houscore/residence/model/residence_review_model.dart';
import 'package:houscore/residence/utils/place_utils.dart';
import 'package:skeletons/skeletons.dart';

import '../../common/provider/number_provider.dart';
import '../../common/provider/parameter_provider.dart';
import '../../common/utils/pagination_utils.dart';
import '../component/score_by_ai.dart';
import '../component/score_by_review.dart';
import '../model/pagination_params.dart';
import '../provider/residence_review_provider.dart';

class ScoreAndReview extends ConsumerStatefulWidget {
  final String address;
  final ScrollController controller;

  const ScoreAndReview ({
    required this.address,
    required this.controller,
    Key? key}) : super (key: key);

  @override
  ConsumerState<ScoreAndReview> createState() => _ScoreAndReviewState();
}

class _ScoreAndReviewState extends ConsumerState<ScoreAndReview> {
  // final ScrollController controller = ScrollController();
  late final ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(numberProvider.notifier).state = 0;
      String result = PlaceUtils.mapAddressForAPI(widget.address);
      ref.read(paginationParameterProvider.notifier).updateParams(address: result, page: 0);
    });


    ref.read(residenceReviewProvider.notifier);

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(residenceReviewProvider.notifier),
      numberprovider: ref.read(numberProvider.notifier),
    );
  }


  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(residenceReviewProvider);

    if (reviewState is CursorPaginationLoading) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if(reviewState is CursorPaginationError){
      return Text(reviewState.message);
    }

    final cp = reviewState as CursorPagination<ResidenceReviewModel>;

    return CustomScrollView(
        controller: controller,
        slivers:
        [
          renderScoreByReview(),
          renderScoreByAi(),
          renderLabel(models : cp),
          renderRatings(models: cp),
        ],
      );
      
  }
}

SliverPadding renderRatings({
  required CursorPagination<ResidenceReviewModel> models,
}) {
  final int itemCount = models is CursorPaginationFetchingMore ? models.data.length + 1 : models.data.length;
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
            (_, index) {
          // 리스트의 마지막 아이템인 경우 로딩 인디케이터를 렌더링
          if (models is CursorPaginationFetchingMore && index == models.data.length) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (models is CursorPaginationRefetching && index == 0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // 그 외의 경우에는 ResidenceReviewCard를 렌더링
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ResidenceReviewCard.fromModel(
              model: models.data[index], isDetail: true,
            ),
          );
        },
        childCount: itemCount,
      ),
    ),
  );
}


SliverPadding renderLoading() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 16.0,
    ),
    sliver: SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
          3,
              (index) => Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 5,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

SliverPadding renderLabel({
  required CursorPagination<ResidenceReviewModel> models,
}) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: Row(
        children: [
          Text(
            '실 거주 리뷰 (${models.data.length})',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(child: SizedBox())
        ],
      ),
    ),
  );
}

SliverPadding errorLabel() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: Text(
        '에러발생',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

SliverPadding indicatorLabel() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: CircularProgressIndicator(),
    ),
  );
}

SliverPadding renderScoreByReview() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: ScoreByReview(),
    ),
  );
}

SliverPadding renderScoreByAi() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: ScoreByAi(),
    ),
  );
}