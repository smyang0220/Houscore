import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/component/list_section.dart';
import 'package:houscore/common/const/design.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/member/provider/user_me_provider.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../../common/model/data_state_model.dart';
import '../../review/view/my_review_list.dart';
import '../component/my_info.dart';
import '../model/interested_area.dart';
import '../provider/interested_area_provider.dart';
import '../repository/myinfo_repository.dart';
import 'package:dio/dio.dart';

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
      print('Error deleting interested area: $e');
    }
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 사용자가 다이얼로그 바깥을 터치해서 닫을 수 없게 함
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('등록 실패'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: VERTICAL_GAP,),
                MyInfo(),
                SizedBox(height: VERTICAL_GAP,),
                ListSection(
                  title: '✨ 내 관심지역',
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
                        await repository.registerInterestedArea({
                          'address': model.jibunAddress!,
                        });

                        ref.refresh(interestedAreaListProvider);

                      } catch (e) {
                        _showErrorDialog(context, '등록 실패: $e');
                      }
                    } else {
                      _showErrorDialog(context, '주소가 유효하지 않습니다.');
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyReviewList(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(
                          '내 리뷰 관리',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 2, endIndent: 8, indent: 8,),
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 2, endIndent: 8, indent: 8,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
