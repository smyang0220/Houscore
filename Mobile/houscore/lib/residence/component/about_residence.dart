import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:houscore/common/const/color.dart';

class AboutResidence extends StatefulWidget {
  final double? primarySchoolDistance; // 초등학교와의 거리 (null 가능)
  final double? middleSchoolDistance; // 중학교와의 거리 (null 가능)
  final int? safetyGrade; // 안전등급 (null 가능)

  const AboutResidence({
    Key? key,
    this.primarySchoolDistance,
    this.middleSchoolDistance,
    this.safetyGrade,
  }) : super(key: key);

  @override
  _AboutResidenceState createState() => _AboutResidenceState();
}

class _AboutResidenceState extends State<AboutResidence> {
  List<AnimatedText> _buildAnimatedTexts() {
    List<AnimatedText> texts = [];

    // 초등학교 정보가 있는 경우
    if (widget.primarySchoolDistance != null && widget.primarySchoolDistance! <= 1.0) {
      texts.add(
        RotateAnimatedText(
          '🏫 초품아',
          textStyle: TextStyle(color: PRIMARY_COLOR, fontSize: 25, fontWeight: FontWeight.w500),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      texts.add(
        RotateAnimatedText(
          '초등학교 없음',
          textStyle: TextStyle(color: Colors.grey, fontSize: 25, fontWeight: FontWeight.w500),
          duration: Duration(seconds: 2),
        ),
      );
    }

    // 중학교 정보가 있는 경우
    if (widget.middleSchoolDistance != null && widget.middleSchoolDistance! <= 1.0) {
      texts.add(
        RotateAnimatedText(
          '🏫 중품아',
          textStyle: TextStyle(color: PRIMARY_COLOR, fontSize: 25, fontWeight: FontWeight.w500),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      texts.add(
        RotateAnimatedText(
          '중학교 없음',
          textStyle: TextStyle(color: Colors.grey, fontSize: 25, fontWeight: FontWeight.w500),
          duration: Duration(seconds: 2),
        ),
      );
    }

    // 안전등급 정보가 있는 경우
    if (widget.safetyGrade != null) {
      Color safetyColor = Colors.grey; // 기본 색상은 회색
      if (widget.safetyGrade! <= 2) {
        safetyColor = PRIMARY_COLOR;
      } else if (widget.safetyGrade == 3) {
        safetyColor = Colors.black;
      } else if (widget.safetyGrade == 4) {
        safetyColor = Colors.orange;
      } else if (widget.safetyGrade == 5) {
        safetyColor = Colors.red;
      }

      texts.add(
        RotateAnimatedText(
          '안전등급 ${widget.safetyGrade}등급',
          textStyle: TextStyle(color: safetyColor, fontSize: 25, fontWeight: FontWeight.w500),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      texts.add(
        RotateAnimatedText(
          '안전등급 없음',
          textStyle: TextStyle(color: Colors.grey, fontSize: 25, fontWeight: FontWeight.w500),
          duration: Duration(seconds: 2),
        ),
      );
    }

    return texts;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Text(
              '그리고 여기는요...',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20.0, height: 40.0),
            Expanded(
              child: Container(
                height: 40,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontFamily: 'Jua',
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: _buildAnimatedTexts(),
                    onTap: () {
                      print("Tap Event");
                    },
                    repeatForever: true,
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
