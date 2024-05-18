import 'package:flutter/material.dart';
import 'package:houscore/residence/utils/place_utils.dart';
import '../../common/utils/data_utils.dart';
import '../model/residence_detail_indicators_model.dart';

class NearbyInfra extends StatefulWidget {
  final List<Infra> infras;

  const NearbyInfra({
    Key? key,
    required this.infras,
  }) : super(key: key);

  @override
  _NearbyInfraState createState() => _NearbyInfraState();
}

class _NearbyInfraState extends State<NearbyInfra> {
  InfraType? _selectedType = InfraType.medicalFacilities;

  List<Infra> getFilteredInfras(List<Infra> list, InfraType? selectedType) {
    if (selectedType == null) {
      return list;
    } else {
      return list.where((infra) => infra.type == selectedType).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 버튼 구성
    Widget buttonContent(String iconPath, String label, bool isSelected) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 24),
        child: Row(
          children: [
            Image.asset(iconPath, width: 16),
            SizedBox(width: 8, height: 40,),
            if(isSelected)
            Text(label, style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,),),
            if(!isSelected)
              Text(label,style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,),)
          ],
        ),
      );
    }

    // 버튼에 따라 달라지는 리스트 구성
    List<Widget> buildInfraList(List<Infra> list) {
      return list.map((infra) {
        var results = PlaceUtils.convertDistance(infra.distance);


        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.0), // 각 항목 사이의 간격 조정
          child: Row(
            children: <Widget>[
              results['leadingIcon'],
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  infra.name,
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                // '${results['minute']}분 (${DataUtils.convertToKilometers(infra.distance)}km)',
                '${results['minute']}분',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: results['iconColor'],
                ),
              ),
              Text(
                // '${results['minute']}분 (${DataUtils.convertToKilometers(infra.distance)}km)',
                ' (${infra.distance.toStringAsFixed(1)}km)',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList();
    }

    List<Infra> filteredList = getFilteredInfras(widget.infras, _selectedType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          '주변 인프라',
          style:TextStyle(
              fontFamily: 'NotoSans',fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        ToggleButtons(
          fillColor: Colors.blue.shade50,
          selectedColor: Colors.black,
          textStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w200,
          ),
          borderRadius: BorderRadius.all(Radius.circular(35)),
          borderWidth: 0,
          constraints: BoxConstraints(maxHeight: 50, minWidth: MediaQuery.of(context).size.width * 0.3 ),
          children: <Widget>[
            // 병원
            if(_selectedType == InfraType.medicalFacilities)
            buttonContent('asset/icon/hospital.png', '병원', true),
            if(_selectedType != InfraType.medicalFacilities)
              buttonContent('asset/icon/hospital.png', '병원',false),
            // 공원
            if(_selectedType == InfraType.park)
            buttonContent('asset/icon/park.png', '공원',true),
            if(_selectedType != InfraType.park)
            buttonContent('asset/icon/park.png', '공원',false),
            // 학교
            if(_selectedType == InfraType.school)
            buttonContent('asset/icon/school.png', '학교',true),
            if(_selectedType != InfraType.school)
            buttonContent('asset/icon/school.png', '학교',false),
          ],
          onPressed: (int index) {
            setState(() {
              switch (index) {
                case 0: // 병원 버튼
                  _selectedType = InfraType.medicalFacilities;
                  break;
                case 1: // 공원 버튼
                  _selectedType = InfraType.park;
                  break;
                case 2: // 학교 버튼
                  _selectedType = InfraType.school;
                  break;
              }
            });
          },
          isSelected: [
            _selectedType == InfraType.medicalFacilities, // 병원 버튼이 선택되었는지
            _selectedType == InfraType.park, // 공원 버튼이 선택되었는지
            _selectedType == InfraType.school, // 학교 버튼이 선택되었는지
          ],
        ),
        SizedBox(height: 16),
        ...buildInfraList(filteredList),
        SizedBox(height: 16),
        Divider(),
      ],
    );
  }
}
