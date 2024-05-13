import 'package:flutter/material.dart';
import 'package:houscore/common/utils/data_utils.dart';
import 'package:houscore/residence/model/residence_detail_indicators_model.dart';
import 'package:intl/intl.dart';

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

  static Map<String, String> sidoDict = {
    "서울": "서울특별시",
    "부산": "부산광역시",
    "대구": "대구광역시",
    "인천": "인천광역시",
    "광주": "광주광역시",
    "대전": "대전광역시",
    "울산": "울산광역시",
    "세종": "세종특별자치시",
    "경기": "경기도",
    "강원": "강원특별자치도",
    "충북": "충청북도",
    "충남": "충청남도",
    "전북": "전북특별자치도",
    "전남": "전라남도",
    "경북": "경상북도",
    "경남": "경상남도",
    "제주": "제주특별자치도"
  };

  static final Map<String, String> reversedSidoDict = sidoDict.map((key, value) => MapEntry(value, key));

  static String mapAddressForAPI(String address) {
    // 주소를 공백으로 분리하고 첫 부분을 추출
    var parts = address.split(' ');
    if (parts.isEmpty) return address; // 주소가 비어있으면 변환 없이 반환

    var firstPart = parts[0]; // 첫 부분을 추출
    if (sidoDict.containsKey(firstPart)) {
      // 매핑된 주소로 변환
      return address.replaceFirst(firstPart, sidoDict[firstPart]!);
    }

    return address; // 매핑 키가 없으면 원본 주소 반환
  }

  static String shortenMapAddress(String fullAddress) {
    // 매핑된 주소를 찾아 반대로 매핑하여 반환
    for (String key in reversedSidoDict.keys) {
      if (fullAddress.contains(key)) {
        return fullAddress.replaceFirst(key, reversedSidoDict[key]!);
      }
    }
    return fullAddress;
  }

  // 가격 변환 to String & 반점 추가
  static String formatPrice(num? value) {
    if (value == null) return '-';
    final formatter = NumberFormat("#,###", "ko_KR");
    return "${formatter.format(value)}만원";
  }

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
