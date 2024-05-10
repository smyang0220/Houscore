import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:houscore/common/const/color.dart'; // PRIMARY_COLOR 정의가 포함된 모듈

import '../model/residence_detail_indicators_model.dart';

class ResidencePriceSafety extends StatelessWidget {
  final RealCost? realCost;
  final int? pricePerPyeong;
  final int? safetyGrade;

  const ResidencePriceSafety({
    Key? key,
    this.realCost,
    this.pricePerPyeong,
    this.safetyGrade,
  }) : super(key: key);

  String formatPrice(double? value) {
    if (value == null) return '-';
    // double valueInTenThousand = value / 10000;
    final formatter = NumberFormat("#,###", "ko_KR");
    return "${formatter.format(value)}만원";
  }

  Color getSafetyColor(int? grade) {
    if (grade == null) return Colors.grey;
    switch (grade) {
      case 1:
      case 2:
        return PRIMARY_COLOR;
      case 3:
        return Colors.yellow;
      case 4:
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void showSafetyGradeInfo(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // 배경 탭시 다이얼로그 닫힘
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('안전 등급이란?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("행정안전부에서 재난, 사고, 질병관리 등 여러 분야에서의 지역의 안전 등급을 부여한 것으로 1등급일수록 안전하다는 의미입니다."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      barrierColor: Colors.black26, // 배경색 어둡게 투명 처리
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('실거래가 (매매/전세/월세)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        SizedBox(height: 5),
        Text('${formatPrice(realCost?.buy)} / ${formatPrice(realCost?.longterm)} / ${realCost?.monthly}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('평당 가격', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(height: 5),
                  Text('${formatPrice(pricePerPyeong?.toDouble())}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('안전등급', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      IconButton(
                        icon: Icon(Icons.help_outline, color: Colors.grey),
                        onPressed: () => showSafetyGradeInfo(context),
                      ),
                    ],
                  ),
                  Text('${safetyGrade ?? '-'}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: getSafetyColor(safetyGrade))),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Divider()
      ],
    );
  }
}
