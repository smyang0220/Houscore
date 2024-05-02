import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/residence/component/place_with_minute.dart';
import '../utils/place_utils.dart';

class NearbyLivingFacilities extends StatefulWidget {
  const NearbyLivingFacilities({Key? key});

  @override
  _NearbyLivingFacilities createState() => _NearbyLivingFacilities();
}

// 그림 그리기
class FacilitiesPainter extends CustomPainter {
  // 생활시설들 배열
  final List<NearbyLivingFacilityWithDistance> places;
  final ui.Image? backgroundImg;
  // Painter 생성자 place들을 외부에서 전달 받음
  FacilitiesPainter(this.places, this.backgroundImg);

  @override
  void paint(Canvas canvas, Size size) {
    // 기본 높이
    double baseHeight = size.height * 0.97; // 이걸 1로 하면 가장 아래 쪽부터 점선이 올라옴

    List<double> endYPositions = []; // 각 텍스트 박스의 끝 위치를 저장할 리스트

    // 색인(도보/차량) 그리기
    void drawLegend(Canvas canvas, Size size) {
      double legendTop = 0; // 레전드의 시작 위치
      double legendLeft = -5; // 캔버스 왼쪽에서의 간격

      // 레전드 배경
      Rect legendBackground = Rect.fromLTWH(legendLeft, legendTop, 170, 40);
      Paint legendBackgroundPaint = Paint()..color = Colors.white;
      // Paint legendBackgroundPaint = Paint()..color = Colors.white.withAlpha(230);
      RRect legendBackgroundRRect =
          RRect.fromRectAndRadius(legendBackground, Radius.circular(8));
      canvas.drawRRect(legendBackgroundRRect, legendBackgroundPaint);

      // 배경 테두리
      // Paint borderPaint = Paint()
      //   ..color = Colors.grey.shade400
      //   ..style = PaintingStyle.stroke
      //   ..strokeWidth = 1.5;
      // canvas.drawRRect(legendBackgroundRRect, borderPaint);

      // 도보 색상
      Paint walkPaint = Paint()..color = WALK_COLOR;
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(legendLeft + 10, legendTop + 15, 30, 10),
              Radius.circular(5)),
          walkPaint);

      // 차량 색상
      Paint carPaint = Paint()..color = CAR_COLOR;
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(legendLeft + 90, legendTop + 15, 30, 10),
              Radius.circular(5)),
          carPaint);

      // 텍스트
      TextPainter walkTextPainter = TextPainter(
        text: TextSpan(
            text: '도보', style: TextStyle(color: Colors.black, fontSize: 16)),
        textDirection: TextDirection.ltr,
      );
      walkTextPainter.layout();
      walkTextPainter.paint(canvas, Offset(legendLeft + 50, legendTop + 8));

      TextPainter carTextPainter = TextPainter(
        text: TextSpan(
            text: '차량', style: TextStyle(color: Colors.black, fontSize: 16)),
        textDirection: TextDirection.ltr,
      );
      carTextPainter.layout();
      carTextPainter.paint(canvas, Offset(legendLeft + 130, legendTop + 8));
    }

    drawLegend(canvas, size);

    // 빌딩 배경 이미지 그리기
    if (backgroundImg != null) {
      // 원본 이미지에서 사용할 부분 // 0부터 전체를 사용해야 안짤림! // 건들지 말것!
      Rect src = Rect.fromLTWH(0, 0, backgroundImg!.width.toDouble(),
          backgroundImg!.height.toDouble());
      // 이미지가 그려질 캔버스상의 위치
      Rect dst = Rect.fromLTWH(
          60, size.height / 2, size.width - 20 - 60, size.height / 2);
          // 0, size.height / 2, size.width - 20, size.height / 2);
      // 그리기
      canvas.drawImageRect(backgroundImg!, src, dst, Paint());
    }

    // 각 생활시설 사이의 간격
    final double spacing = size.width / (places.length + 1) - 5;

    // 배경 그리기
    // Paint backgroundPaint = Paint()..color = Colors.grey.shade100;
    // Paint backgroundPaint = Paint()..color = Colors.transparent;

    // 캔버스 그리기
    // RRect backgroundRect =
    //     RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(20.0));
    // canvas.drawRRect(backgroundRect, backgroundPaint);

    // 실선 그리기
    final Paint linePaint = Paint()
      ..color = PRIMARY_COLOR
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // 점선 그리기
    final Paint dashLinePaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 점선 그리기 함수
    void drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
      const double dashWidth = 3.0;
      const double dashSpace = 5.0;

      double totalLength = (end - start).distance; // 점선의 총 거리

      int numberOfDashes = totalLength ~/ (dashWidth + dashSpace); // 점선 내 점의 갯수

      double dx = end.dx - start.dx;
      double dy = end.dy - start.dy;

      // 기울기를 위한 변수
      double sinTheta = dy / totalLength;
      double cosTheta = dx / totalLength;

      for (int i = 0; i < numberOfDashes; i++) {
        double x1 = start.dx + (i * (dashSpace + dashWidth)) * cosTheta;
        double y1 = start.dy + (i * (dashSpace + dashWidth)) * sinTheta;
        double x2 = x1 + dashWidth * cosTheta;
        double y2 = y1 + dashWidth * sinTheta;
        // 각 점을 그려감
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      }
    }

    // 텍스트 및 점선 그리기
    for (int i = 0; i < places.length; i++) {
      var place = places[i];
      var placeInfo = PlaceUtils.convertDistance(place.distance);
      int minute = placeInfo['minute'] ?? 0; // Null이면 0

      // 텍스트 스타일과 TextSpan 설정
      final textStyle = TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: 2);
      final textSpan = TextSpan(
          text: '${PlaceUtils.typeName(place.type)}(${minute}분)',
          style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // 텍스트 위치 계산
      double gap = 40;
      double xPosition = spacing * (i + 1) - textPainter.width / 2 + 40;
      double yPosition = baseHeight - ((i + 1) * gap); // 각 항목을 30 픽셀씩 상승

      // 점선 그리기
      drawDashedLine(
        canvas,
        Offset(xPosition + textPainter.width / 2, baseHeight),
        Offset(
            xPosition + textPainter.width / 2, yPosition - textPainter.height),
        dashLinePaint,
      );

      // 텍스트 배경 사각형 설정
      // 도보냐 차량이냐에 따라 배경 색 설정
      Paint fillPaint = Paint()
        ..color = place.walkOrCar ? WALK_COLOR : CAR_COLOR;
      // 배경 크기 및 위치 (텍스트 박스 기준)
      Rect rect = Rect.fromLTWH(
          xPosition - 10, // 좌우 // 너비/2 가 되어야 함!
          yPosition - textPainter.height - 5, // 위아래 // 높이/2 가 되어야 함!
          textPainter.width + 20, // 전체 너비
          textPainter.height + 10 // 전체 높이
          );
      // 둥글기 설정
      RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(8));
      // 텍스트 배경 그리기
      canvas.drawRRect(rRect, fillPaint);

      // // 배경 사각형 및 텍스트 그리기
      // Paint fillPaint = Paint()
      //   ..color = place.walkOrCar ? Colors.lightGreen : Colors.lightBlue;
      // Rect rect = Rect.fromLTWH(xPosition - 10, endYPosition,
      //     textPainter.width + 20, textPainter.height + 10);
      // RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(14));
      // canvas.drawRRect(rRect, fillPaint);
      // textPainter.paint(canvas, Offset(xPosition, endYPosition));

      // 텍스트 그리기
      textPainter.paint(
          canvas, Offset(xPosition, yPosition - textPainter.height));
    } // end of for 문

    // 바닥선 그리기
    canvas.drawLine(
        Offset(50, baseHeight), Offset(size.width - 10, baseHeight), linePaint);
  }

  // 다시 그릴일이 있다고 하면 커스텀하기!
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _NearbyLivingFacilities extends State<NearbyLivingFacilities> {
  List<NearbyLivingFacilityWithDistance> places = [];
  ui.Image? backgroundImg;

  // 이미지 로드 함수를 클래스 메서드로 선언
  Future<ui.Image> loadImage(String imagePath) async {
    ByteData data = await rootBundle.load(imagePath);
    Uint8List bytes = data.buffer.asUint8List();
    ui.Codec codec = await ui.instantiateImageCodec(bytes);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  void initState() {
    super.initState();
    places = [
      NearbyLivingFacilityWithDistance(
          type: PlaceType.library,
          name: "도서관A",
          distance: 0.07,
          walkOrCar: true),
      NearbyLivingFacilityWithDistance(
          type: PlaceType.bus, name: "버스정류장C", distance: 0.2, walkOrCar: true),
      NearbyLivingFacilityWithDistance(
          type: PlaceType.medicalFacility,
          name: "의료시설E",
          distance: 3,
          walkOrCar: false), // 차량으로 이동
      NearbyLivingFacilityWithDistance(
          type: PlaceType.park, name: "공원F", distance: 0.267, walkOrCar: true),
      NearbyLivingFacilityWithDistance(
          type: PlaceType.subway,
          name: "지하철역D",
          distance: 0.333,
          walkOrCar: true),
      NearbyLivingFacilityWithDistance(
          type: PlaceType.supermarket,
          name: "마트B",
          distance: 0.467,
          walkOrCar: true),
    ];

    // Sort the places list by distance
    places.sort((a, b) => a.distance.compareTo(b.distance));

    loadImage('asset/img/building/building_background.png').then((img) {
      setState(() {
        this.backgroundImg = img;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주변 생활 시설',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: backgroundImg == null
              ? CircularProgressIndicator()
              : CustomPaint(
                  painter: FacilitiesPainter(places, backgroundImg),
                  child: Container(
                    height: 320,
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child:
                          Icon(Icons.home_filled, size: 35, color: PRIMARY_COLOR),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
