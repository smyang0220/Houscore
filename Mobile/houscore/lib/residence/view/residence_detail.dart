import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/residence/view/nearyby_indicators.dart';
import 'package:houscore/residence/view/score_and_review.dart';

class ResidenceDetail extends StatefulWidget {
  final String address;

  const ResidenceDetail({Key? key, required this.address}) : super(key: key);

  @override
  State<ResidenceDetail> createState() => _ResidenceDetailState();
}



class _ResidenceDetailState extends State<ResidenceDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (mounted) {
      setState(() {
        // 탭이 변경될 때마다 상태를 업데이트
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: widget.address,
      titleStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
      floatingActionButton: _tabController.index == 1 ? FloatingActionButton(
        onPressed: () {},
        backgroundColor: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Icon(Icons.create_rounded),
      ) : null,
      child: Column(
        children: [
          // 지표와 리뷰 탭바
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.3),
              //     spreadRadius: 1,
              //     blurRadius: 5,
              //     offset: const Offset(0, 5), // 그림자 시작 위치
              //   ),
              // ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: PRIMARY_COLOR,
              indicatorColor: PRIMARY_COLOR,
              labelStyle: TextStyle(
                fontSize: 16.0, // 선택된 탭의 글자 크기
                fontWeight: FontWeight.bold, // 선택된 탭의 글자 굵기
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.0, // 선택되지 않은 탭의 글자 크기
              ),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: '주변 지표'),
                Tab(text: '점수/리뷰'),
              ],
            ),
          ),
          // 탭에 따라 보여질 view
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(), // 스크롤 하다가 가로로 스크롤 되서 탭 바뀌는 거 방지!
              children: [
                // 첫 번째 탭 '상세 정보'의 내용
                NearbyIndicators(address: widget.address),
                // 두 번째 탭 '주변 시설'의 내용
                ScoreAndReview(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
