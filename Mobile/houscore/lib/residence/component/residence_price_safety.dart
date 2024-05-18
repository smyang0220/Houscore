import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart'; // PRIMARY_COLOR 정의가 포함된 모듈

import '../model/residence_detail_indicators_model.dart';
import '../utils/place_utils.dart';

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

  Color getSafetyColor(int? grade) {
    if (grade == null) return Colors.grey;
    switch (grade) {
      case 1:
      case 2:
        return PRIMARY_COLOR;
      case 3:
        return Colors.orangeAccent;
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
    List<String>? monthlyPrices = realCost?.monthly?.split('/');
    String formattedBuy = realCost?.buy != null && realCost!.buy! > 0
        ? PlaceUtils.formatPrice(realCost!.buy)
        : '정보 없음';
    String formattedLongterm = realCost?.longterm != null && realCost!.longterm! > 0
        ? PlaceUtils.formatPrice(realCost!.longterm)
        : '정보 없음';
    String formattedMonthly = monthlyPrices != null && monthlyPrices.isNotEmpty
        ? monthlyPrices.map((price) {
      double? parsedPrice = double.tryParse(price);
      return parsedPrice != null && parsedPrice > 0
          ? PlaceUtils.formatPrice(parsedPrice)
          : '정보 없음';
    }).join(' & ')
        : '정보 없음';

    // 실거래가 값이 모두 0인 경우 "정보 없음" 한 개만 표시
    bool allValuesAreZero = (realCost?.buy == null || realCost!.buy! == 0) &&
        (realCost?.longterm == null || realCost!.longterm! == 0) &&
        (monthlyPrices == null || monthlyPrices.every((price) => price == '0'));

    String displayedRealCost = allValuesAreZero
        ? '정보 없음'
        : '${realCost?.buy != null && realCost!.buy! > 0 ? formattedBuy : '-'} / '
        '${realCost?.longterm != null && realCost!.longterm! > 0 ? formattedLongterm : '-'} / '
        '${monthlyPrices != null && monthlyPrices.isNotEmpty && monthlyPrices.any((price) => price != '0') ? formattedMonthly : '-'}';

    String formattedPricePerPyeong = pricePerPyeong != null && pricePerPyeong! > 0
        ? '${PlaceUtils.formatPrice(pricePerPyeong!.toDouble())}만원'
        : '정보 없음';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('실거래가 (매매/전세/월세)', style: TextStyle(
                  fontFamily: 'NotoSans',fontSize: 16, fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text('*단위: 만원', style: TextStyle(
                    fontFamily: 'NotoSans', fontSize: 11, fontWeight: FontWeight.w400, color: Colors.grey)),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(displayedRealCost, style: TextStyle(fontFamily: 'NotoSans', fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('평당 가격', style: TextStyle(
                        fontFamily: 'NotoSans',fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(formattedPricePerPyeong, style: TextStyle(fontFamily: 'NotoSans', fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '안전등급',
                            style: TextStyle(fontFamily: 'NotoSans', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => showSafetyGradeInfo(context),
                              child: Icon(Icons.help_outline, color: Colors.grey, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      safetyGrade != null ? '$safetyGrade등급' : '정보 없음',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: getSafetyColor(safetyGrade),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider()
        ],
      ),
    );
  }
}
