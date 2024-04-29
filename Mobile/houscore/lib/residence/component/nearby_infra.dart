import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

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
  bool _showHospitals = true;

  @override
  Widget build(BuildContext context) {
    List<Infra> filteredList = widget.infraItems.where((item) => item.hospitalOrPark == _showHospitals).toList();

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
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderWidth: 0,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'asset/icon/hospital.png',
                        width: 15,
                      ),
                      SizedBox(width: 15),
                      Text('병원')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 50),
                  child: Row(
                    children: [
                      Image.asset(
                        'asset/icon/park.png',
                        width: 15,
                      ),
                      SizedBox(width: 15),
                      Text('공원')
                    ],
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  _showHospitals = index == 0;
                });
              },
              isSelected: [_showHospitals, !_showHospitals],
            ),
          ],
        ),
        SizedBox(height: 15),
        ...List.generate(filteredList.length, (index) {
          Infra infra = filteredList[index];
          String transportType;
          String time;
          Icon leadingIcon;
          Color iconColor;

          if (infra.distance <= 1.5) {
            int walkTime = (infra.distance / 4 * 60).round();
            time = '$walkTime분';
            transportType = '도보';
            leadingIcon = Icon(Icons.directions_walk);
            iconColor = Colors.green;
          } else {
            int driveTime = (infra.distance / 60 * 60).round();
            time = '$driveTime분';
            transportType = '차량';
            leadingIcon = Icon(Icons.directions_car);
            iconColor = Colors.blue;
          }

          return ListTile(
            leading: Icon(
              leadingIcon.icon,
              color: iconColor,
            ),
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
                  '$time (${infra.distance}km)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          );
        }),
        Divider(),
      ],
    );
  }
}
