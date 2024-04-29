import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:houscore/common/const/color.dart';
import 'dart:math';

import '../model/residence_model.dart';


class AiRecommendationCard extends StatefulWidget {
  final String address;
  final double aiScore;
  final int? transactionPrice;
  final int? pricePerPyeong;
  final int? reviewCount;
  final CategoryScores categoryScores;  // 추가된 카테고리 점수

  AiRecommendationCard({
    required this.address,
    required this.aiScore,
    this.transactionPrice,
    this.pricePerPyeong,
    this.reviewCount,
    required this.categoryScores, // 필수 인자로 변경
  });

  @override
  _AiRecommendationCardState createState() => _AiRecommendationCardState();
}

class _AiRecommendationCardState extends State<AiRecommendationCard> with TickerProviderStateMixin {
  late AnimationController _chartAnimationController;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    _chartAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _chartAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _chartAnimationController, curve: Curves.linear));
    _chartAnimationController.forward();
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    super.dispose();
  }

  String formatPrice(int? price) {
    if (price == null) return '정보 없음';
    return '${price ~/ 10000}만원';
  }

  @override
  Widget build(BuildContext context) {
    List<double> scores = [
      widget.categoryScores.transportation,
      widget.categoryScores.building,
      widget.categoryScores.safety,
      widget.categoryScores.location,
      widget.categoryScores.education
    ];

    double maxScore = scores.reduce(max);
    double minScore = scores.reduce(min);

    List<RadarEntry> radarEntries = scores.map((score) => RadarEntry(value: (score - minScore) / (maxScore - minScore) * 5)).toList();

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 215,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.address, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI 분석 점수', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('${widget.aiScore.toStringAsFixed(1)}점', style: TextStyle(fontSize: 15, color: PRIMARY_COLOR, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('실거래가: ${formatPrice(widget.transactionPrice)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('평당가격: ${formatPrice(widget.pricePerPyeong)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('리뷰건수: ${widget.reviewCount ?? '정보 없음'}건', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  AnimatedBuilder(
                    animation: _chartAnimationController,
                    builder: (context, child) {
                      return SizedBox(
                        height: 150,
                        width: 150,
                        child: RadarChart(
                          RadarChartData(
                            getTitle: (index, angle) {
                              switch (index) {
                                case 0: return RadarChartTitle(text: '교통', positionPercentageOffset: 0.2);
                                case 1: return RadarChartTitle(text: '건물', positionPercentageOffset: 0.2);
                                case 2: return RadarChartTitle(text: '치안', positionPercentageOffset: 0.2);
                                case 3: return RadarChartTitle(text: '입지', positionPercentageOffset: 0.2);
                                case 4: return RadarChartTitle(text: '학군', positionPercentageOffset: 0.2);
                                default: return RadarChartTitle(text: '');
                              }
                            },
                            radarBackgroundColor: Colors.transparent,
                            borderData: FlBorderData(show: false),
                            titleTextStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            tickCount: 4,
                            tickBorderData: BorderSide(color: Colors.grey, width: 1),
                            ticksTextStyle: TextStyle(color: Colors.transparent, fontSize: 0),
                            radarBorderData: BorderSide(color: Colors.black, width: 3),
                            gridBorderData: BorderSide(color: Colors.grey, width: 1),
                            radarShape: RadarShape.polygon,
                            dataSets: [RadarDataSet(borderColor: PRIMARY_COLOR, fillColor: PRIMARY_COLOR.withOpacity(0.4), dataEntries: radarEntries)],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
