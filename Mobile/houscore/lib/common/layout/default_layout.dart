import 'package:flutter/material.dart';

// 모든 페이지에 일괄적으로 디자인을 적용하고
// stateful로 바꾸면 모든 페이지를 열때 특정 api요청을 하고 싶다.
class DefaultLayout extends StatelessWidget {
  final String? title; // AppBar의 제목으로 null이면 AppBar 표시 X
  final TextStyle? titleStyle;
  final Widget child;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  const DefaultLayout({super.key, required this.child, this.title, this.titleStyle, this.backgroundColor, this.bottomNavigationBar, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar : renderAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: CustomFloatingButtonLocation(
        FloatingActionButtonLocation.endFloat, // 기본 위치
        -30, // X축으로 -20 픽셀 (왼쪽으로 이동)
        -30, // Y축 변경 없음
      ),
    );
  }

  // title 의 null 여부에 따라서 존재하는 AppBar의 유무에 따라 렌더링 여부 결정
  AppBar? renderAppBar(){
    if (title == null) {
      return null;
    }
    else{
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title!, // Text는 무조건 값이 있어야하는데 null처리를 했기 떄문애 ! 처리,
          style: titleStyle ?? TextStyle(
            fontSize: 16.0, // 기본값
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

}

class CustomFloatingButtonLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation location;
  final double offsetX; // X축의 오프셋 조정 값
  final double offsetY; // Y축의 오프셋 조정 값

  CustomFloatingButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}