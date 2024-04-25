import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/common/layout/default_layout.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab>
    with
        SingleTickerProviderStateMixin{
  late TabController controller;

  int index = 0;

  @override
  void initState(){
    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener(){
    setState(() {
      index = controller.index;
    });
  }
  // vsync

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
        title: '넥스트그라운드'
      ,
      child : TabBarView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(), // 안움직이게 만듬
        children: [
          Center(child: Container(child: Text('홈'))),
          KakaoAddressScreen(),
          Center(child: Container(child: Text('주문'))),
          Center(child: Container(child: Text('프로필'))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR, // 선택된 탭의 색상을 검정색으로 설정
        unselectedItemColor: BODY_TEXT_COLOR, // 선택되지 않은 탭의 색상을 검정색으로 설정
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting,
        onTap: (int index){
          setState(() {
            this.index = index;
            controller.animateTo(index);
          });
        },
        currentIndex: index,
        items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
        label: '홈'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식'
        ),    BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문'
        ),  BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '프로필'
        ),
      ],
       ),
    );
  }
}


class KakaoAddressScreen extends StatelessWidget {
  KakaoAddressScreen({super.key});

  /// Form State
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};

  /// Controller
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController =
  TextEditingController();

  Widget _gap() {
    return const SizedBox(
      height: 10,
    );
  }

  void _searchAddress(BuildContext context) async {
    KopoModel? model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );

    if (model != null) {
      final postcode = model.zonecode ?? '';
      _postcodeController.value = TextEditingValue(
        text: postcode,
      );
      formData['postcode'] = postcode;

      final address = model.address ?? '';
      _addressController.value = TextEditingValue(
        text: address,
      );
      formData['address'] = address;

      final buildingName = model.buildingName ?? '';
      _addressDetailController.value = TextEditingValue(
        text: buildingName,
      );
      formData['address_detail'] = buildingName;
    }
  }

  @override
  Widget build(BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _postcodeController,
                    decoration: const InputDecoration(
                      hintText: '우편번호',
                    ),
                    readOnly: true,
                  ),
                  _gap(),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: '기본주소',
                    ),
                    readOnly: true,
                  ),
                  _gap(),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: _addressDetailController,
                    decoration: const InputDecoration(
                      hintText: '상세주소 입력',
                    ),
                  ),
                  _gap(),
                  CupertinoButton(
                    onPressed: () => _searchAddress(context),
                    child: const Text('주소검색'),
                  )
                ],
              ),
            ),
          ],
        );
  }
}