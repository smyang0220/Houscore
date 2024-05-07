import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// localhost
final emulatorIp = '10.0.2.2:3000';
final simulatorIp = '127.0.0.1:3000';

// final ip = Platform.isIOS ? simulatorIp : emulatorIp;
final ip = 'k10s206.p.ssafy.io:8084';

// 사용자 개인 정보나 인증 토큰과 같은 중요한 데이터를 안전하게 보관하는데 사용되는 플러그인
// iOS : Keychain 활용
// Android : 안전 저장소(Secure SharedPreferences) 사용
// WEB : Local Storage 활용
// 사용자 기기에 데이터를 저장 & 외부 앱이나 사용자 접근 불가
final storage = FlutterSecureStorage();