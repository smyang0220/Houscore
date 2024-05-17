import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../const/data.dart';
import '../provider/data_list_param_provider.dart';


class DataUtils{
  static String pathToUrl(String value){
    return 'http://$ip$value';
  }

  static List<String> listPathsToUrls(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);

    return encoded;
  }

  static String plainFromBase64(String plain){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.decode(plain);

    return encoded;
  }

  static Map<String, dynamic> parseJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('잘못된 JWT 토큰입니다.');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('잘못된 Payload 데이터입니다.');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('잘못된 Base64 문자열');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static double convertToKilometers(double meters) {
    double kilometers = meters / 1000;
    return double.parse(kilometers.toStringAsFixed(2)); // 소수점 2자리까지
  }

  static Future<String> xFileToBase64(XFile file) async {
    // 파일로부터 바이트 데이터를 읽어옵니다.
    List<int> imageBytes = await file.readAsBytes();

    // 바이트 데이터를 base64 문자열로 인코딩합니다.
    String base64String = base64Encode(imageBytes);

    return base64String;
  }

  static String floorDescription(String residenceFloor) {
    switch (residenceFloor) {
      case 'HIGH':
        return '16층 이상';
      case 'MEDIUM':
        return '5-15층';
      case 'LOW':
        return '2-5층';
      case 'BOTTOM':
        return '1층';
      default:
        return '알 수 없는 층';
    }
  }

  static String typeDescription(String residenceType) {
    switch (residenceType) {
      case 'VILLA':
        return '원룸/빌라';
      case 'APT':
        return '아파트';
      case 'OFFICETEL':
        return '오피스텔';
      default:
        return '알 수 없는 유형';
    }
  }

  // ReviewList provider한테 알려 주는 함수야
  // 알려주려면 param에 대한 provider가 필요해
  // provider를 받고 걔한테 이제 현재 위치 가져와버려서
  // 그걸 알려줘.
  // 그러면 걔가 이제 그걸로 param을 업데이트 시켜
  // 그러면 이제 얘를 보고 있던 놈이 아 얘 바꼈네
  // 아 바꼈으니깐 나도 api요청 보내야지
  //
  static Future<void> getLocation({
    required DataListParamsNotifier provider,
  }) async {
    // 위치 받아와
    Position position = await Geolocator.getCurrentPosition();

    // 설정해
    final double lat = position.latitude;
    final double lng = position.longitude;

    // 야호
    print("야호");
    print("lat $lat lng $lng 얌");

    // 그걸로 매개변수 업데이트
    provider.updateParams(lng: lng, lat: lat);

  }

}