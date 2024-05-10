import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/const/data.dart';
import '../model/myinfo_model.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => FlutterSecureStorage());

final userInfoProvider = FutureProvider<MyinfoModel>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  String? name = await storage.read(key: USER_NAME_KEY);
  String? email = await storage.read(key: USER_EMAIL_KEY);

  // print('name : ${name}');
  // print('email : ${name}');

  return MyinfoModel(
    name: (name == null || name.isEmpty) ? "알 수 없음" : name,
    email: (email == null || email.isEmpty) ? "알 수 없음" : email,
  );
});

class MyInfo extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoAsyncValue = ref.watch(userInfoProvider);

    // print('user name : ${userInfoAsyncValue.value!.name}');
    // print('user email : ${userInfoAsyncValue.value!.email}');

    return userInfoAsyncValue.when(
      data: (info) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 5,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(info.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(info.email),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Divider(thickness: 4, endIndent: 20, indent: 20,),
            Divider(thickness: 4, endIndent: 40, indent: 40,),
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('에러 발생: $e')),
    );
  }
}

