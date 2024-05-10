import 'package:flutter/material.dart';
import 'package:houscore/common/utils/data_utils.dart';
import 'package:houscore/residence/model/residence_detail_indicators_model.dart';

import '../component/place_with_minute.dart';

enum PlaceType {
  library, // 도서관
  supermarket, // 대형마트
  bus, // 버스정류장
  subway, // 지하철역
  medicalFacility, // 의료시설
  park // 공원
}

class PlaceUtils {

  static String typeName(InfraType type) {
    switch (type) {
      case InfraType.library:
        return "도서관";
      case InfraType.supermarket:
        return "대형마트";
      case InfraType.bus:
        return "버스정류장";
      case InfraType.subway:
        return "지하철역";
      case InfraType.medicalFacilities:
        return "병원";
      case InfraType.park:
        return "공원";
      case InfraType.school:
        return "학교";
      default:
        return "알 수 없음";
    }
  }

  static Map <String, dynamic> convertDistance(double distance) {
    int minute;
    String transportType;
    Icon leadingIcon;
    Color iconColor;

    double kiloDistance = DataUtils.convertToKilometers(distance);

    // 1.5 km 까지만 도보로 가정 // 사람이 1시간에 4km를 걷는다고 가정
    if (kiloDistance <= 1.5) {
      int walkTime = (kiloDistance / 4 * 60).round();
      minute = walkTime;
      transportType = '도보';
      iconColor = Colors.green;
      leadingIcon = Icon(Icons.directions_walk, color: iconColor);
    }
    // 그 이상은 차량으로 가정 // 차량이 1시간에 60km를 이동한다고 가정
    else {
      int driveTime = (kiloDistance / 60 * 60).round();  // Assuming average speed is 60 km/h
      minute = driveTime;
      transportType = '차량';
      iconColor = Colors.blue;
      leadingIcon = Icon(Icons.directions_car, color: iconColor);
    }

    return {
      'minute': minute,
      'transportType': transportType,
      'leadingIcon': leadingIcon,
      'iconColor': iconColor
    };
  }
}
