import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

class MainLogoAppName extends StatelessWidget {
  const MainLogoAppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'asset/img/logo/main_logo.png',
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Text(
          ' HOUSCORE',
          style: TextStyle(
            fontFamily: 'SingleDay',
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}
