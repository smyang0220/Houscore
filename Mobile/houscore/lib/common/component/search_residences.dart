import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class SearchScreen extends StatefulWidget {
  final Function(String) onAddressSelected;

  const SearchScreen({Key? key, required this.onAddressSelected}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주소 검색'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onTap: _addressAPI,
              controller: _addressController,
              decoration: InputDecoration(
                labelText: '주소',
                hintText: '주소를 클릭하여 검색하세요',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  void _addressAPI() async {
    KopoModel model = await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => RemediKopo()),
    );

    setState(() {
      _addressController.text = '${model.zonecode!} ${model.address!} ${model.buildingName!}';
      widget.onAddressSelected(_addressController.text);
    });
  }
}


class SearchResidences extends StatefulWidget {
  final String? title;

  const SearchResidences({Key? key, this.title}) : super(key: key);

  @override
  _SearchResidencesState createState() => _SearchResidencesState();
}

class _SearchResidencesState extends State<SearchResidences> {
  String? selectedAddress = '주소를 검색해주세요.';

  void setAddress(String address) {
    setState(() {
      selectedAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '💯 내가 살 곳의 점수는?',
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen(onAddressSelected: setAddress)),
              );
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: PRIMARY_COLOR, width: 2.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedAddress!,
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Icon(Icons.search, color: PRIMARY_COLOR),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
