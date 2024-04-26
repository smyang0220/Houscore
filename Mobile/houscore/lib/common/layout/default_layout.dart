import 'package:flutter/material.dart';

// 모든 페이지에 일괄적으로 디자인을 적용하고
// stateful로 바꾸면 모든 페이지를 열때 특정 api요청을 하고 싶다.
class DefaultLayout extends StatelessWidget {
  final String? title; // AppBar의 제목으로 null이면 AppBar 표시 X
  final Widget child;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  const DefaultLayout({super.key, required this.child, this.title, this.backgroundColor, this.bottomNavigationBar, this.floatingActionButton});

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
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500
          ),
        ),
      );
    }
  }

}

