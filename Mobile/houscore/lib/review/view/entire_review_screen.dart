import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/common/model/cursor_pagination_model.dart';
import 'package:houscore/residence/component/residence_review_card.dart';
import 'package:houscore/residence/model/residence_review_model.dart';
import 'package:houscore/residence/utils/place_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletons/skeletons.dart';

import '../../common/provider/number_provider.dart';
import '../../common/provider/parameter_provider.dart';
import '../../common/utils/pagination_utils.dart';
import '../../residence/provider/residence_review_provider.dart';
import '../provider/entire_review_provider.dart';

class EntireReviewScreen extends ConsumerStatefulWidget {

  const EntireReviewScreen ({
    Key? key}) : super (key: key);

  @override
  ConsumerState<EntireReviewScreen> createState() => _ScoreAndReviewState();
}

class _ScoreAndReviewState extends ConsumerState<EntireReviewScreen> {
  // final ScrollController controller = ScrollController();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(numberProvider.notifier).state = 0;
      ref.read(paginationParameterProvider.notifier).updateParams(page: 0);
    });

    ref.read(entireReviewProvider.notifier);

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(entireReviewProvider.notifier),
      numberprovider: ref.read(numberProvider.notifier),
    );
  }


  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(entireReviewProvider);

    if (reviewState is CursorPaginationLoading) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if(reviewState is CursorPaginationError){
      return Container(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: Lottie.asset('asset/img/logo/error_lottie_animation_cat.json'),
                // child: Lottie.asset('asset/img/logo/error_lottie_animation_slime.json'),
              ),
              Text('리뷰를 찾지 못했습니다. 인터넷 연결을 확인해주세요.', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 150,),
            ],
          ));
    }

    final cp = reviewState as CursorPagination<ResidenceReviewModel>;

    return DefaultLayout(
      title: "전체리뷰보기",
      child: CustomScrollView(
        controller: controller,
        slivers:
        [
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: CircularProgressIndicator(),
              ),
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
              model: models.data[index], isDetail: false,
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