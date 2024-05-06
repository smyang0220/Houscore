import 'package:houscore/common/const/data.dart';

class DataUtils{
  // JSON에서 경로를 받아서 완전한 URL로 변환하는 역할
  // @JsonKey(fromJson: DataUtils.pathToUrl)에서 쓰임!
  // 예를 들면 섬네일 같은 경우 value만 가지고 다니고 실제 값으로는 url을 쓰도록!
  static pathToUrl(String value){
    return 'http://$ip$value';
  }
}