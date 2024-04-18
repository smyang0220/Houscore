import 'package:flutter/material.dart';

// 모든 페이지에 일괄적으로 디자인을 적용하고
// stateful로 바꾸면 모든 페이지를 열때 특정 api요청을 하고 싶다.
class DefaultLayout extends StatelessWidget {
  final String? title;
  final Widget child;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  const DefaultLayout({super.key, required this.child, this.title, this.backgroundColor, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar : renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar(){
    if(title == null){
      return null;
    }else{
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

