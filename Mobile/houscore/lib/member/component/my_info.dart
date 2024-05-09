import 'package:flutter/material.dart';
import '../model/member_info_model.dart';

class MyInfo extends StatelessWidget {
  final MemberInfo? memberInfo;

  MyInfo({this.memberInfo});

  @override
  Widget build(BuildContext context) {
    if (memberInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    // 프로필 이미지 설정 // 있는 경우와 없는 경우로 나눠서 !
    Widget profileImage = memberInfo!.profileImage.isNotEmpty
        ? CircleAvatar(
      radius: 30, // 원 반지름
      backgroundImage: NetworkImage(memberInfo!.profileImage), //
      backgroundColor: Colors.transparent,
    )
        : CircleAvatar(
      radius: 30,
      child: Icon(Icons.person, size: 40), // 이미지가 없는 경우 아이콘 표시
      backgroundColor: Colors.grey.shade300,
    );

    // 이름 설정, 이름이 없으면 "이름 없음"으로 표시
    String displayName = memberInfo!.name.isNotEmpty ? memberInfo!.name : "이름 없음";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: profileImage,
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(memberInfo!.email),
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
  }
}
