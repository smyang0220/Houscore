import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/const/color.dart';
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
    _scoreAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1300),
    );

    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: widget.model.aiScore.toDouble(),
    ).animate(CurvedAnimation(
      parent: _scoreAnimationController,
      curve: Curves.easeOut,
    ));

    _scoreAnimationController.forward();
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.black,
      surfaceTintColor: PRIMARY_COLOR,
      child: GestureDetector(
        onTap: () {
          // print('${widget.model.address} tapped!');
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
          // height: 200,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.model.address,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            AnimatedBuilder(
                              animation: _scoreAnimation,
                              builder: (context, child) => Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${_scoreAnimation.value.toStringAsFixed(1)}',
                                    style: TextStyle(
                                        fontSize: 32,
                                        color: PRIMARY_COLOR,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('/', style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.grey,
                                      // color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  ),
                                  Text('5', style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey,
                                      // color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '실거래가: ${PlaceUtils.formatPrice(widget.model.realPrice)}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text(
                                '평당가격: ${PlaceUtils.formatPrice(widget.model.pricePerPyeong)}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text('리뷰건수: ${widget.model.reviewCnt ?? '0'}건',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(width: 15,),
                        Text('지역 평당가격 대비 ', style: TextStyle(fontWeight: FontWeight.w600),),
                        SizedBox(width: 15,),
                        Text(
                          '${widget.model.pricePerRegion - 100.0 < 0 ? "" : "+"}${(widget.model.pricePerRegion - 100.0).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: widget.model.pricePerRegion - 100.0 < 0 ? Colors.blue : Colors.red,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
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
