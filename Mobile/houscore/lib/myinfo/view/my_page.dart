import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/component/list_section.dart';
import 'package:houscore/common/const/design.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/member/provider/user_me_provider.dart';
import '../../common/model/data_state_model.dart';
import '../component/my_info.dart';
import '../model/interested_area.dart';
import '../provider/interested_area_provider.dart';

class MyPage extends ConsumerStatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = ref.watch(interestedAreaListProvider.notifier);
    notifier.fetchInterestedAreaList();
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
                      context.push('/residence/${item.name}')),
              SizedBox(height: VERTICAL_GAP,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      context.go('/myReviews');
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

/*
              DynamicListWidget(
                title: '내 관심지역',
                initialItemCount : 3
                onAddPressed: () {
                  print('관심 지역 추가 기능 구현 필요');
                },
                showMoreText: "${interestedAreaListState.detail!.length - 3}개 보기",
                showLessText: "접기",
                showMoreIcon: Icon(Icons.expand_more),
                showLessIcon: Icon(Icons.expand_less),
                itemListProvider: interestedAreaListProvider,
              ),
 */
