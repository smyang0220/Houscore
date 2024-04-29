import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

import '../../residence/view/search_screen.dart';

class SearchResidences extends StatelessWidget {
  final String? title;

  const SearchResidences({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '💯 내가 살 곳의 점수는?',
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: PRIMARY_COLOR, width: 2.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(' 주소를 검색해주세요.', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Icon(Icons.search, color: PRIMARY_COLOR),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
