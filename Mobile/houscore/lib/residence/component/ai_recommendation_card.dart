import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:houscore/common/const/color.dart';
import 'dart:math';

import '../model/ai_recommended_residence_model.dart';

class AiRecommendationCard extends StatefulWidget {
  final AiRecommendedResidenceModel model;

  AiRecommendationCard({required this.model});

  @override
  _AiRecommendationCardState createState() => _AiRecommendationCardState();
}

class _AiRecommendationCardState extends State<AiRecommendationCard> with TickerProviderStateMixin {
  late AnimationController _chartAnimationController;

  @override
  void initState() {
    super.initState();
    _chartAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
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
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.model.address, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI 분석 점수', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('${widget.model.aiScore.toStringAsFixed(1)}점', style: TextStyle(fontSize: 15, color: PRIMARY_COLOR, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('실거래가: ${formatPrice(widget.model.realPrice)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('평당가격: ${formatPrice(widget.model.pricePerPyeong)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('리뷰건수: ${widget.model.reviewCnt ?? '0'}건', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
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
