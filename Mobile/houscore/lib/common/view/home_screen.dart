import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/model/data_list_state_model.dart';
import 'package:houscore/residence/model/residence_main_photo_model.dart';
import 'package:houscore/residence/provider/main_photo_provider.dart';
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
  
  @override
  void initState() {
    super.initState();
    ref.read(mainPhotoProvider.notifier);
  }
  
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
      'reviewScore': 4.0,
      'aiScore': 2.8,
      'pros': '사람이 별로 없어서 조용합니다.',
      'cons': '배달음식을 시켜먹을 곳이 별로 없습니다.'
    },
    {
      'address': '서울 강동구 길동 454-1',
      'reviewScore': 3.0,
      'aiScore': 3.5,
      'pros': '회사촌이 가까워서 좋습니다.',
      'cons': '주변에 맛집이 별로 없습니다.'
    },
  ];

  // 더미 이미지 리뷰 데이터
  final List<Map<String, dynamic>> reviewsWithImages = [
    {
      'address': '서울 강남구 개포동 12',
      'reviewScore': 4.0,
      'aiScore': 2.8,
      'pros': '사람이 별로 없어서 조용합니다.',
      'cons': '배달음식을 시켜먹을 곳이 별로 없습니다.',
      'imageUrl': 'https://example.com/images/review1.jpg'
    },
    {
      'address': '서울 강동구 길동 454-1',
      'reviewScore': 3.0,
      'aiScore': 3.5,
      'pros': '회사촌이 가까워서 좋습니다.',
      'cons': '주변에 맛집이 별로 없습니다.',
      'imageUrl': 'https://example.com/images/review2.jpg'
    },
    {
      'address': '대전 유성구 덕명동 522-1',
      'reviewScore': 4.5,
      'aiScore': 4.2,
      'pros': '온오프 피자가 훌륭합니다.',
      'cons': '방학시즌에 썰렁합니다.',
      'imageUrl': 'https://example.com/images/review3.jpg'
    },
    // {
    //   'address': '경기도 성남시 분당구 판교역 로데오',
    //   'reviewScore': 3.5,
    //   'aiScore': 3.0,
    //   'pros': '기술 회사들이 많아 접근성이 좋습니다.',
    //   'cons': '출퇴근 시간대에 교통이 혼잡합니다.',
    //   'imageUrl': 'https://example.com/images/review4.jpg'
    // },
    // {
    //   'address': '제주도 서귀포시 중문관광단지',
    //   'reviewScore': 5.0,
    //   'aiScore': 4.8,
    //   'pros': '자연 경관이 아름답고 평화롭습니다.',
    //   'cons': '겨울철에는 날씨가 다소 쌀쌀합니다.',
    //   'imageUrl': 'https://example.com/images/review5.jpg'
    // },
  ];

  @override
  Widget build(BuildContext context) {
    final photo = ref.watch(mainPhotoProvider);
    
    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Icon(Icons.create_rounded),
      ),
      child:SafeArea(
        child: CustomScrollView(
          slivers: [
            renderLogo(),
            renderSearchResidences(),
            renderAiRecommendation(),
            renderNearbyResidencesReview(),
            renderLabel(),
            renderPhotos(models : photo),
          ],
        ),
      )

    );
  }
}


class _PhotoReview extends ConsumerStatefulWidget {

  const _PhotoReview({super.key});

  @override
  ConsumerState<_PhotoReview> createState() => _PhotoReviewState();
}

class _PhotoReviewState extends ConsumerState<_PhotoReview> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(mainPhotoProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final photo = ref.watch(mainPhotoProvider);

    print("포토리뷰위젯생성");
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
        child: CustomScrollView(
          slivers: [
            renderLabel(),
            renderPhotos(models: photo),
          ],
        ),
    );
    return Text("야발");
  }
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
      child: AiRecommendation(),
    ),
  );
}

SliverPadding renderNearbyResidencesReview() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: NearbyResidencesReview(
        onViewAll: () {
          // 전체 보기 시 다른 화면
        },
      ),
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
        height: 200.0, // 적절한 높이 설정
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // 가로 스크롤 설정
          itemCount: models is DataListState<ResidenceMainPhotoModel> ? models.data.length : 10, // itemCount 처리
          itemBuilder: (context, index) {
            if (models is DataListState<ResidenceMainPhotoModel>) {
              return ResidencePhotoReviewCard.fromModel(
                model: models.data[index],
              );
            } else if (models is DataListStateError) {
              return Text("에러입니다");
            } else {
              // 데이터가 로딩 중이거나 불러올 데이터가 없는 경우
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    ),
  );
}
