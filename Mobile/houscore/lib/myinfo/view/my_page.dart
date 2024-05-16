import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/component/list_section.dart';
import 'package:houscore/common/const/design.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/member/provider/user_me_provider.dart';
import 'package:houscore/residence/utils/place_utils.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../../common/model/data_state_model.dart';
import '../../review/view/my_review_list.dart';
import '../component/my_info.dart';
import '../model/interested_area.dart';
import '../provider/interested_area_provider.dart';
import '../repository/myinfo_repository.dart';
import 'package:dio/dio.dart'; // Dio 패키지 추가

class MyPage extends ConsumerStatefulWidget {
  static String get routeName => 'myPage';
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {

  @override
  void initState() {
    super.initState();
    ref.read(interestedAreaListProvider.notifier);
  }

  Future<void> _deleteInterestedArea(InterestedAreaModel area) async {
    final repository = ref.watch(myinfoRepositoryProvider);
    try {
      await repository.deleteInterestedArea(areaId: area.id!);
      final notifier = ref.watch(interestedAreaListProvider.notifier);
      notifier.fetchInterestedAreaList();
    } catch (e) {
      if (e is DioError) {
        // print('DioError: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        // print('Error deleting interested area: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(interestedAreaListProvider);

    // 데이터 로딩 상태와 에러 상태를 처리
    List<InterestedAreaModel>? listToShow = [];
    if (data is DataState<List<InterestedAreaModel>>) {
      listToShow = data.data;
    }

    return DefaultLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyInfo(),
              SizedBox(height: VERTICAL_GAP,),
              ListSection(
                title: '내 관심지역',
                list: listToShow,
                onItemTap: (item) =>
                    context.push('/residence/${item.name}'),
                onAddTap: () async {
                  KopoModel model = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RemediKopo(),
                    ),
                  );
                  // 검색된 주소 정보를 바탕으로
                  // 새로운 관심 지역을 등록하는 API 호출
                  if (model != null && model.jibunAddress != null) {
                    // print('Selected Address: ${PlaceUtils.mapAddressForAPI(model.jibunAddress!)}');

                    // 관심 지역 등록 API 호출
                    final repository = ref.watch(myinfoRepositoryProvider);

                    try {
                      repository.registerInterestedArea({
                        'address': model.jibunAddress!,
                      });

                      // print('등록은 무사히 마쳤습니다!!');
                      // print('리스트를 다시 불러와볼까요?');

                      final notifier = ref.watch(interestedAreaListProvider.notifier);
                      notifier.fetchInterestedAreaList();

                      // print('리스트 다시 불러오기도 성공했네요!! 축하합니다!!');
                    } catch (e) {
                      // print('등록 실패: $e');
                    }
                  } else {
                    // print('[[[[없는 주소입니다.]]]]');
                  }
                }, onDelete: (item) => _deleteInterestedArea(item),
              ),
              SizedBox(height: VERTICAL_GAP,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      // context.go('/myReviews');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => MyReviewList()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text(
                        '내 리뷰 관리',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      ref.read(userMeProvider.notifier).logout();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text(
                        '로그아웃',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 2,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     InkWell(
              //       onTap: () {},
              //       child: Container(
              //         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              //         child: Text(
              //           '회원탈퇴',
              //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Divider(thickness: 2,),
            ],
          ),
        ),
      ),
    );
  }
}
