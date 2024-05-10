import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/member/provider/user_me_provider.dart';
import '../provider/member_info_provider.dart';

class MyPage extends ConsumerStatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  Widget build(BuildContext context) {
    final memberInfoState = ref.watch(memberInfoProvider);
    // final interestedAreaListState = ref.watch(interestedAreaListProvider);

    return DefaultLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                ref.read(userMeProvider.notifier).logout();
        }, child: Text("로그아웃"))
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