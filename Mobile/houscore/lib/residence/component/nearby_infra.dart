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
    Widget buttonContent(String iconPath, String label) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 24),
        child: Row(
          children: [
            Image.asset(iconPath, width: 15),
            SizedBox(width: 8),
            Text(label)
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
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '${results['minute']}분 (${infra.distance.toStringAsFixed(1)}km)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: results['iconColor'],
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
        SizedBox(height: 15),
        Text(
          '주변 인프라',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButtons(
              fillColor: Colors.blue.shade50,
              selectedColor: Colors.black,
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderWidth: 0,
              children: <Widget>[
                // 병원
                buttonContent('asset/icon/hospital.png', '병원'),
                // 공원
                buttonContent('asset/icon/park.png', '공원'),
                // 학교
                buttonContent('asset/icon/school.png', '학교'),
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
