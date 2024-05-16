import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/residence/model/residence_main_photo_model.dart';
import 'package:houscore/review/component/photo_reviews.dart';
import 'package:houscore/common/component/search_residences.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/const/design.dart';

import '../../residence/component/ai_recommendation.dart';
import '../../residence/component/residence_photo_review_card.dart';
import '../../residence/component/residence_review_card.dart';
import '../../residence/repository/residence_repository.dart';
import '../component/main_logo_app_name.dart';
import '../../review/component/nearby_recent_reviews.dart';
import '../layout/default_layout.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

// 더미 최근 검색 거주지
class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<String> residenceNames = [
    '잠실 레이크팰리스',
    '잠실 트리지움 아파트',
    '잠실 더클래스원 오피스텔',
    '잠실 주공아파트',
    '잠실 엘스',
  ];

  // 더비 리뷰 데이터
  final List<Map<String, dynamic>> reviews = [
    {
      'address': '서울 강남구 개포동 12',
      'userRating': 4.0,
      'aiRating': 2.8,
      'like': '사람이 별로 없어서 조용합니다.',
      'dislike': '배달음식을 시켜먹을 곳이 별로 없습니다.'
    },
    {
      'address': '서울 강동구 길동 454-1',
      'userRating': 3.0,
      'aiRating': 3.5,
      'like': '회사촌이 가까워서 좋습니다.',
      'dislike': '주변에 맛집이 별로 없습니다.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Icon(Icons.create_rounded),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 메인 로고와 어플 이름
              MainLogoAppName(),
              // 한 줄 소개
              SizedBox(height: 30),
              // 검색창
              // SearchResidences(title: null),
              SearchResidences(),
              SizedBox(height: VERTICAL_GAP),
              AiRecommendation(),
              SizedBox(height: VERTICAL_GAP),
              // 근처 거주지 리뷰
              // 최근 등록 리뷰
              SizedBox(height: VERTICAL_GAP),

            FutureBuilder<List<ResidenceMainPhotoModel>>(
              future: ref.read(residenceRepositoryProvider).getResidenceMainPhoto(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  print("출력");
                  print(snapshot.data);
                  return _PhotoReview(models: snapshot.data!);
                } else {
                  return Center(child: Text('데이터가 없습니다.'));
                }
              },
            ),
            ],
          ),
        ),
      ),
    );
  }
}


class _PhotoReview extends StatelessWidget {
  final List<ResidenceMainPhotoModel> models;

  const _PhotoReview({super.key, required this.models});

  @override
  Widget build(BuildContext context) {
    print("포토리뷰위젯생성");
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Flexible(
        child: CustomScrollView(
          slivers: [
            renderLabel(),
            renderPhotos(models: models),
          ],
        ),
      ),
    );
  }
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
  required List<ResidenceMainPhotoModel> models,
}) {
  final int itemCount = models.length;

  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
            (_, index) {
          // 리스트의 마지막 아이템인 경우 로딩 인디케이터를 렌더링
              if (index >= models.length) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                print("된건데말야..");
                print(itemCount);
                return
                  ResidencePhotoReviewCard.fromModel(
                    model: models[index],
                  );
              }

              // 그 외의 경우에는 ResidenceReviewCard를 렌더링
        },
        childCount: itemCount,
      ),
    ),
  );
}