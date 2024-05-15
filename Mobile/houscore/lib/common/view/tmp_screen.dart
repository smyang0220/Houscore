import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/common/model/cursor_pagination_model.dart';
import 'package:houscore/residence/component/residence_review_card.dart';
import 'package:houscore/residence/model/residence_review_model.dart';
import 'package:skeletons/skeletons.dart';

import '../../common/utils/pagination_utils.dart';
import '../../residence/provider/residence_review_provider.dart';

class tmpScreen extends ConsumerStatefulWidget {
  final String address;

  const tmpScreen ({
    required this.address,
    Key? key}) : super (key: key);

  @override
  ConsumerState<tmpScreen> createState() => _ScoreAndReviewState();
}

class _ScoreAndReviewState extends ConsumerState<tmpScreen> {
  // final ScrollController controller = ScrollController();
   final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();

    ref.read(residenceReviewProvider.notifier);

    controller.addListener(listener);
  }

  void listener() {
    // PaginationUtils.paginate(
    //     controller: controller,
    //     provider: ref.read(residenceReviewProvider.notifier),
    //     page: 1,
    // );
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

    return DefaultLayout(
      title: "제발되라",
      child: CustomScrollView(
        controller: controller,
        slivers:
        [
          // ScoreByReview(),
          // ScoreByAi(),
          renderLabel(),
          if(reviewState is CursorPaginationRefetching<ResidenceReviewModel>)
            indicatorLabel(),

          if(reviewState is CursorPagination<ResidenceReviewModel>)
            renderRatings(models: cp),

          if(reviewState is CursorPaginationFetchingMore<ResidenceReviewModel>)
            renderRatings(models: cp),



        ],
      ),
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
          // 그 외의 경우에는 ResidenceReviewCard를 렌더링
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ResidenceReviewCard.fromModel(
              model: models.data[index],
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

SliverPadding renderLabel() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: Column(
        children: [
          Text(
            '실 거주 리뷰',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
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