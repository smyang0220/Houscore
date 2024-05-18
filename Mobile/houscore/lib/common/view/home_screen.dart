import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/model/data_list_state_model.dart';
import 'package:houscore/residence/provider/main_photo_provider.dart';
import 'package:houscore/common/component/search_residences.dart';
import 'package:houscore/common/const/color.dart';

import '../../residence/component/ai_recommendation.dart';
import '../../residence/component/residence_photo_review_card.dart';
import '../../review/model/homescreen_review_model.dart';
import '../component/main_logo_app_name.dart';
import '../../review/component/nearby_recent_reviews.dart';
import '../layout/default_layout.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final AiRecommendation aiRecommendation = AiRecommendation();

  @override
  void initState() {
    super.initState();
    ref.read(mainPhotoProvider.notifier);
  }

  void _navigateAndRemoveOverlay(BuildContext context, String route) {
    aiRecommendation.removeOverlay();
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final photo = ref.watch(mainPhotoProvider);

    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndRemoveOverlay(context, '/createReview');
        },
        backgroundColor: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Icon(Icons.create_rounded),
      ),
      child: CustomScrollView(
        slivers: [
          renderLogo(),
          renderSearchResidences(),
          renderAiRecommendation(),
          renderNearbyResidencesReview(),
          renderLabel(),
          renderPhotos(models: photo),
        ],
      ),
    );
  }

  SliverPadding renderLogo() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: MainLogoAppName(),
      ),
    );
  }

  SliverPadding renderSearchResidences() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: SearchResidences(),
      ),
    );
  }

  SliverPadding renderAiRecommendation() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: aiRecommendation,
      ),
    );
  }

  SliverPadding renderNearbyResidencesReview() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: NearbyResidencesReview(),
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '📷 백문이 불여일견! 사진 리뷰',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  SliverPadding renderPhotos({
    required DataListStateBase models,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverToBoxAdapter( // SliverList 대신 SliverToBoxAdapter 사용
        child: Container(
          height: 250.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 가로 스크롤 설정
            itemCount: models is DataListState<HomescreenReviewModel> ? models.data.length : 10, // itemCount 처리
            itemBuilder: (context, index) {
              if (models is DataListState<HomescreenReviewModel>) {
                return ResidencePhotoReviewCard.fromModel(
                  model: models.data[index],
                );
              } else if (models is DataListStateError) {
                return Text("에러입니다");
              } else {
                // 데이터가 로딩 중이거나 불러올 데이터가 없는 경우
                return  Skeleton(height: 250.0);
              }
            },
          ),
        ),
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  final double width;
  final double height;

  const Skeleton({Key? key, this.width = double.infinity, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
