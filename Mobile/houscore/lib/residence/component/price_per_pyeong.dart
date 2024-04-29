import 'package:flutter/material.dart';
import 'dart:math' as math;

class PricePerPyeong extends StatefulWidget {
  final int finalPrice;
  final int averagePrice;

  const PricePerPyeong(
      {Key? key, required this.finalPrice, required this.averagePrice})
      : super(key: key);

  @override
  _PricePerPyeongState createState() => _PricePerPyeongState();
}

class _PricePerPyeongState extends State<PricePerPyeong>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.finalPrice.toDouble())
        .animate(
        CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        int priceDifference = widget.finalPrice - widget.averagePrice;
        Color textColor = priceDifference == 0 ? Colors.black
            : (priceDifference > 0 ? Colors.blue : Colors.red);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🏷 평당가격',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_animation.value.toStringAsFixed(0)}만원',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  children: [
                    TextSpan(
                      text: '이 지역 평균가격 대비 ',
                    ),
                    TextSpan(
                      text: '${priceDifference.abs()}만원 ',
                      style: TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: priceDifference == 0 ? "평균 가격과 같습니다"
                          : (priceDifference > 0 ? "더 비쌉니다" : "더 저렴합니다"),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
