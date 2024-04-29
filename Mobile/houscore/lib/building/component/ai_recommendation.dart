import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

import 'ai_recommendation_card.dart';

class AiRecommendation extends StatefulWidget {
  @override
  _AiRecommendationState createState() => _AiRecommendationState();
}

class _AiRecommendationState extends State<AiRecommendation> {
  GlobalKey _headerKey = GlobalKey();
  GlobalKey _selectionKey = GlobalKey();

  final List<String> regions = [
    '서울',
    '경기',
    '인천',
    '세종',
    '강원',
    '충북',
    '충남',
    '대전',
    '전북',
    '전남',
    '광주',
    '경북',
    '경남',
    '대구',
    '부산',
    '울산',
    '제주',
    '전국'
  ];
  final Map<String, List<String>> subRegions = {
    '서울': [
      '강남구',
      '강동구',
      '강북구',
      '강서구',
      '관악구',
      '광진구',
      '구로구',
      '금천구',
      '노원구',
      '도봉구',
      '동대문구',
      '동작구',
      '마포구',
      '서대문구',
      '서초구',
      '성동구',
      '성북구',
      '송파구',
      '양천구',
      '영등포구',
      '용산구',
      '은평구',
      '종로구',
      '중구',
      '중랑구',
      '전체'
    ],
    '경기': [
      '가평군',
      '고양시',
      '과천시',
      '광명시',
      '광주시',
      '구리시',
      '군포시',
      '김포시',
      '남양주시',
      '동두천시',
      '부천시',
      '성남시',
      '수원시',
      '시흥시',
      '안산시',
      '안성시',
      '안양시',
      '양주시',
      '양평군',
      '여주시',
      '연천군',
      '오산시',
      '용인시',
      '의왕시',
      '의정부시',
      '이천시',
      '파주시',
      '평택시',
      '포천시',
      '하남시',
      '화성시',
      '전체'
    ],
    '인천': [
      '강화군',
      '계양구',
      '남동구',
      '동구',
      '미추홀구',
      '부평구',
      '서구',
      '연수구',
      '옹진군',
      '중구',
      '전체'
    ],
    '세종': [
      '전체',
    ],
    '강원': [
      '강릉시',
      '고성군',
      '동해시',
      '삼척시',
      '속초시',
      '양구군',
      '양양군',
      '영월군',
      '원주시',
      '인제군',
      '정선군',
      '철원군',
      '춘천시',
      '태백시',
      '평창군',
      '홍천군',
      '화천군',
      '횡성군',
      '전체'
    ],
    '충북': [
      '괴산군',
      '단양군',
      '보은군',
      '영동군',
      '옥천군',
      '음성군',
      '제천시',
      '증평군',
      '진천군',
      '청주시',
      '충주시',
      '전체'
    ],
    '충남': [
      '계룡시',
      '공주시',
      '금산군',
      '논산시',
      '당진시',
      '보령시',
      '부여군',
      '서산시',
      '서천군',
      '아산시',
      '예산군',
      '천안시',
      '청양군',
      '태안군',
      '홍성군',
      '보령시',
      '전체'
    ],
    '대전': ['대덕구', '동구', '서구', '유성구', '중구', '전체'],
    '전북': [
      '고창군',
      '군산시',
      '김제시',
      '남원시',
      '무주군',
      '부안군',
      '순창군',
      '완주군',
      '익산시',
      '임실군',
      '장수군',
      '전주시',
      '정읍시',
      '진안군',
      '전체'
    ],
    '전남': [
      '강진군',
      '고흥군',
      '곡성군',
      '광양시',
      '구례군',
      '나주시',
      '담양군',
      '목포시',
      '무안군',
      '보성군',
      '순천시',
      '신안군',
      '여수시',
      '영광군',
      '영암군',
      '완도군',
      '장성군',
      '장흥군',
      '진도군',
      '함평군',
      '해남군',
      '화순군',
      '전체'
    ],
    '광주': ['광산구', '남구', '동구', '북구', '서구', '전체'],
    '경북': [
      '경산시',
      '경주시',
      '고령군',
      '구미시',
      '군위군',
      '김천시',
      '문경시',
      '봉화군',
      '상주시',
      '성주군',
      '안동시',
      '영덕군',
      '영양군',
      '영주시',
      '영천시',
      '예천군',
      '울릉군',
      '울진군',
      '의성군',
      '청도군',
      '청송군',
      '칠곡군',
      '포항시',
      '전체'
    ],
    '경남': [
      '거제시',
      '거창군',
      '고성군',
      '김해시',
      '남해군',
      '밀양시',
      '사천시',
      '산청군',
      '양산시',
      '의령군',
      '진주시',
      '창녕군',
      '창원시',
      '통영시',
      '하동군',
      '함안군',
      '함양군',
      '합천군',
      '전체'
    ],
    '대구': ['남구', '달서구', '달성군', '동구', '북구', '서구', '수성구', '중구', '전체'],
    '부산': [
      '강서구',
      '금정구',
      '기장군',
      '남구',
      '동구',
      '동래구',
      '부산진구',
      '북구',
      '사상구',
      '사하구',
      '서구',
      '수영구',
      '연제구',
      '영도구',
      '중구',
      '해운대구',
      '전체'
    ],
    '울산': ['남구', '동구', '북구', '울주군', '중구', '전체'],
    '제주': ['서귀포시', '제주시', '전체'],
    '전국': ['전체']
  };

  String? selectedRegion; // 지역
  String? selectedSubRegion; // 세부 지역

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

    final RenderBox headerBox = _headerKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox selectionBox = _selectionKey.currentContext?.findRenderObject() as RenderBox;
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
                  child: Text(
                    region,
                    style: TextStyle(color: selectedOrNot),
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
    return
      // SingleChildScrollView( child:
      Column(
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
          // AiRecommendationCard(),
        ],
      // ),
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
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
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
