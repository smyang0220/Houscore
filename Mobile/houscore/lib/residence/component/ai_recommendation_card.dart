import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/const/color.dart';
import '../../common/const/design.dart';
import '../model/ai_recommended_residence_model.dart';
import '../utils/place_utils.dart';
import '../view/residence_detail.dart';

class AiRecommendationCard extends StatefulWidget {
  final AiRecommendedResidenceModel model;

  AiRecommendationCard({required this.model});

  @override
  _AiRecommendationCardState createState() => _AiRecommendationCardState();
}

class _AiRecommendationCardState extends State<AiRecommendationCard>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _scoreAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    double aiScore = widget.model.aiScore.toDouble();
    if (aiScore < 0) {
      aiScore = 0;
    }

    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: aiScore,
    ).animate(CurvedAnimation(
      parent: _scoreAnimationController,
      curve: Curves.easeOut,
    ));

    _scoreAnimationController.forward();
  }

  @override
  void didUpdateWidget(covariant AiRecommendationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model.aiScore != widget.model.aiScore) {
      _scoreAnimationController.dispose();
      _initializeAnimation();
    }
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final realPrice = widget.model.realPrice;
    final pricePerPyeong = widget.model.pricePerPyeong;

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.black,
      surfaceTintColor: PRIMARY_COLOR,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ResidenceDetail(address: widget.model.address),
            ),
          );
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(widget.model.address,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Spacer()
                  ],
                ),
                SizedBox(height: 4),
                Divider(),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('AI 분석 점수',
                                style: TextStyle(
                                  fontFamily: 'NotoSans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                )),
                            SizedBox(height: 2),
                            AnimatedBuilder(
                              animation: _scoreAnimation,
                              builder: (context, child) => Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.model.aiScore < 0
                                        ? '측정 불가'
                                        : '${_scoreAnimation.value.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: widget.model.aiScore < 0
                                            ? 24 : 32,
                                        color: PRIMARY_COLOR,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (widget.model.aiScore >= 0) ...[
                                    Text(
                                      '/',
                                      style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '5',
                                      style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '(단위: 만원)',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '실거래가 :   ${realPrice == 0 ? '자료 없음' : PlaceUtils.formatPrice(realPrice)}',
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    )),
                                SizedBox(height: 4),
                                Text(
                                    '평당가격 :   ${pricePerPyeong == 0 ? '자료 없음' : PlaceUtils.formatPrice(pricePerPyeong)}',
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    )),
                                SizedBox(height: 4),
                                Text('리뷰건수 :   ${widget.model.reviewCnt ?? '0'}건',
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    if (pricePerPyeong > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          Text('지역 평당가격 대비 ',
                              style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            '${widget.model.pricePerRegion - 100.0 < 0 ? "" : "+"}${(widget.model.pricePerRegion - 100.0).toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: widget.model.pricePerRegion - 100.0 < 0
                                  ? Colors.blue
                                  : Colors.red,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
