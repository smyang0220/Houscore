import 'package:houscore/common/const/data.dart';

class DataUtils{
  // JSON에서 로컬 경로를 받아서 완전한 URL로 변환하는 역할
  // @JsonKey(fromJson: DataUtils.pathToUrl)에서 쓰임!
  static pathToUrl(String value){
    return 'http://$ip$value';
  }
}