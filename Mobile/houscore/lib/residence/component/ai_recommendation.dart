import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/const/data.dart';
import 'package:houscore/common/model/data_state_model.dart';
import 'package:houscore/residence/model/ai_recommended_residence_model.dart';
import 'package:lottie/lottie.dart';

import '../provider/ai_recommended_residence_provider.dart';
import 'ai_recommendation_card.dart';

class AiRecommendation extends ConsumerStatefulWidget {
  @override
  _AiRecommendationState createState() => _AiRecommendationState();
}

class _AiRecommendationState extends ConsumerState<AiRecommendation> {
  final PageController _pageController = PageController(viewportFraction: 0.9); // 한 스크롤에 카드가 하나씩 보이게 하기 위한 설정용
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _selectionKey = GlobalKey();

  String getSiGunGuCode(String region, String subRegion) {
    return sigunguCode[region]?[subRegion] ?? '0000';
  }

  String? selectedRegion; // 고른 지역
  String? selectedSubRegion; // 고른 세부 지역

  OverlayEntry? _overlayEntry; // 선택창

  bool _isRegionExpanded = false; // 지역 선택창 열린지 여부
  bool _isSubRegionExpanded = false; // 세부 지역 선택창 열렸는지 여부

  void _toggleOverlay(
      BuildContext context, List<String> items, bool isSubRegion) {
    // 상태 먼저 반영
    setState(() {
      // 세부 지역을 누른거면
      if (isSubRegion) {
        _isSubRegionExpanded = !_isSubRegionExpanded; // 세부 지역 토글
        _isRegionExpanded = false; // 지역의 상태를 안눌린 것으로!
      }
      // 지역을 누른거면
      else {
        _isRegionExpanded = !_isRegionExpanded; // 지역 토글
        _isSubRegionExpanded = false; // 세부 지역의 상태를 안눌린 것으로!
      }
    });

    // 이미 선택창이 나와있다면 선택창 닫기
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    // 선택창이 닫혀있다면 새로 열기
    else {
      _overlayEntry = _createOverlayEntry(context, items, isSubRegion);
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }

  // 지역 및 세부지역 선택 오버레이 관련
  OverlayEntry _createOverlayEntry(
      BuildContext context, List<String> items, bool isSubRegion) {
    // 현재 위젯의 렌더링 상자 // 위젯의 크기 및 화면에서의 위치 파악용
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    final RenderBox headerBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox selectionBox =
        _selectionKey.currentContext?.findRenderObject() as RenderBox;
    final double offsetTop = headerBox.size.height + selectionBox.size.height;

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        // 오버레이 생기는 위치 기준
        left: offset.dx,
        top: offset.dy + offsetTop,
        width: size.width,
        child: Material(
          color: Color(0xfffafafa),
          elevation: 10, // 떠있는 정도 // 0 이상으로 둘 것!
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5, // 한 줄에 갯수
            childAspectRatio: 2, // 가로 세로 비율
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            children: items.map((String region) {
              Color selectedOrNot = (isSubRegion
                      ? selectedSubRegion == region
                      : selectedRegion == region)
                  ? PRIMARY_COLOR
                  : Colors.black;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSubRegion) {
                      selectedSubRegion = region;
                    } else {
                      selectedRegion = region;
                      selectedSubRegion = null; // 지역 선택 시 세부 지역 리셋
                    }
                  });
                  _toggleOverlay(context, [], isSubRegion);
                },
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: selectedOrNot, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      region,
                      style: TextStyle(color: selectedOrNot),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCode = selectedRegion != null && selectedSubRegion != null
        ? getSiGunGuCode(selectedRegion!, selectedSubRegion!)
        : null;

    final residenceData = selectedCode != null ? ref.watch(aiRecommendedResidenceProvider(selectedCode)) : null;

    print('residenceData = ${residenceData}');

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            key: _headerKey,
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '🤖 AI 추천 거주지',
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            key: _selectionKey,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: _isRegionExpanded || _isSubRegionExpanded
                    ? Radius.zero
                    : Radius.circular(10),
                bottomRight: _isRegionExpanded || _isSubRegionExpanded
                    ? Radius.zero
                    : Radius.circular(10),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  // 지역 선택 버튼
                  Flexible(
                    child: _buildButton(
                      text: selectedRegion ?? '지역 선택',
                      onTap: () => _toggleOverlay(context, regions, false),
                      isExpanded: _isRegionExpanded, // 지역 선택 버튼의 확장 상태
                    ),
                  ),
                  VerticalDivider(
                    width: 2,
                    indent: 8,
                    endIndent: 8,
                  ),
                  Flexible(
                    child: _buildButton(
                      text: selectedSubRegion ?? '세부 지역 선택',
                      onTap: () => _toggleOverlay(
                          context, subRegions[selectedRegion]!, true),
                      isExpanded: _isSubRegionExpanded, // 세부지역 선택 버튼의 확장 상태
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (residenceData != null) ...[
            if (residenceData is DataStateLoading) Lottie.asset('asset/img/logo/loading_lottie_animation.json'),
            if (residenceData is DataState)
              if (residenceData.data.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('해당 지역에 AI 추천 거주지가 존재하지 않습니다.'),
                )
              else
                Container(
                  height: 220, // 고정 높이
                  // child: ListView.builder(
                  //   scrollDirection: Axis.horizontal,
                  //   itemCount: residenceData.data.length,
                  //   itemBuilder: (context, index) {
                  //     return SizedBox(
                  //       width: MediaQuery.of(context).size.width * 0.9,
                  //       child: AiRecommendationCard(model: residenceData.data[index]),
                  //     );
                  //   },
                  // ),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: residenceData.data.length,
                    itemBuilder: (context, index) {
                      return AiRecommendationCard(model: residenceData.data[index]);
                    },
                  ),
                ),
            if (residenceData is DataStateError) Text('Error: ${residenceData.message}'),
          ],
        ],
      ),
    );
  }

  // 지역 및 세부지역 선택 버튼
  Widget _buildButton(
      {required String text,
      required VoidCallback onTap,
      required bool isExpanded}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down, // 상태에 따른 아이콘 방향
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
