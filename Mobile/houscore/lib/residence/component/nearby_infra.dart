import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/residence/utils/place_utils.dart';

import '../model/nearby_infra_model.dart';

class NearbyInfra extends StatefulWidget {
  final List<Infra> infraItems;

  const NearbyInfra({
    Key? key,
    required this.infraItems,
  }) : super(key: key);

  @override
  _NearbyInfraState createState() => _NearbyInfraState();
}

class _NearbyInfraState extends State<NearbyInfra> {
  InfraType? _selectedType;

  @override
  Widget build(BuildContext context) {
    List<Infra> filteredList = _selectedType == null ? widget.infraItems : widget.infraItems.where((item) => item.type == _selectedType).toList();

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

    // 필터링된 부분 구성
    List<Widget> buildInfraList(List<Infra> list) {
      return list.map((infra) {
        var results = PlaceUtils.convertDistance(infra.distance);

        return ListTile(
          leading: results['leadingIcon'],
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  infra.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${results['minute']}분 (${infra.distance}km)',
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
                  _selectedType = InfraType.values[index];
                });
              },
              isSelected: InfraType.values.map((e) => e == _selectedType).toList(),
            ),
          ],
        ),
        SizedBox(height: 15),
        ...buildInfraList(filteredList),
        Divider(),
      ],
    );
  }
}
