import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:houscore/common/const/color.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../../residence/view/residence_detail.dart';

class SearchResidences extends StatefulWidget {
  @override
  _SearchResidencesState createState() => _SearchResidencesState();
}

class _SearchResidencesState extends State<SearchResidences> {
  String addressJSON = ''; // 선택된 주소를 문자열 형태로 저장

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
            onTap: () async {
              // KopoModel을 받아서 주소 추출
              KopoModel model = await Navigator.push(
                context,
                // 주소 검색 창으로 이동
                CupertinoPageRoute(
                  builder: (context) => RemediKopo(),
                ),
              );

              print("model.jibunAddress : ${model.jibunAddress}");
              print("model.autoJibunAddress : ${model.autoJibunAddress}");

              // 받은 결과로 이동
              if (model != null && model.jibunAddress != null && model.jibunAddress != "") {
                context.push('/residence/${model.jibunAddress}');
              }
              else if (model != null && model.autoJibunAddress != null && model.autoJibunAddress != "") {
                context.push('/residence/${model.autoJibunAddress}');
              }
              else if (model != null) {
                // 경고창을 띄우고 전 화면으로 돌아가는 로직
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('거주지 검색 실패'),
                      content: Text('해당 주소의 거주지를 찾을 수 없습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text('확인'),
                        ),
                      ],
                    );
                  },
                );
              }
              // print('model.toJson() == ${model.toJson()}');
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
                  Text(' 주소를 검색해주세요.',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
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

