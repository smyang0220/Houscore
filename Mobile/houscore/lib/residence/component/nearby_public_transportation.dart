import 'package:flutter/material.dart';

import '../model/nearby_public_transportation_model.dart';

class NearbyPublicTransportation extends StatefulWidget {
  final List<PublicTransport> transportItems;

  const NearbyPublicTransportation({
    Key? key,
    required this.transportItems,
  }) : super(key: key);

  @override
  _NearbyPublicTransportationState createState() => _NearbyPublicTransportationState();
}

class _NearbyPublicTransportationState extends State<NearbyPublicTransportation> {
  bool _showBuses = true;

  @override
  Widget build(BuildContext context) {
    // 필터링된 리스트: _showBuses 값에 따라 버스 또는 지하철만 표시
    List<PublicTransport> filteredList = widget.transportItems.where((item) => item.busOrSubway == _showBuses).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Text(
          '주변 대중교통',
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
                        'asset/icon/bus.png',
                        width: 15,
                      ),
                      SizedBox(width: 15,),
                      Text('버스'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 50),
                  child: Row(
                    children: [
                      Image.asset(
                        'asset/icon/subway.png',
                        width: 15,
                      ),
                      SizedBox(width: 15,),
                      Text('지하철'),
                    ],
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  _showBuses = index == 0;
                });
              },
              isSelected: [_showBuses, !_showBuses],
            ),
          ],
        ),
        SizedBox(height: 15),
        ...List.generate(filteredList.length, (index) {
          PublicTransport transport = filteredList[index];
          String transportType;
          String time;
          Icon leadingIcon;
          Color iconColor;

          if (transport.distance <= 1.5) {
            int walkTime = (transport.distance / 4 * 60).round();
            time = '$walkTime분';
            transportType = '도보';
            leadingIcon = Icon(Icons.directions_walk);
            iconColor = Colors.green;
          } else {
            int driveTime = (transport.distance / 60 * 60).round();
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
                    transport.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '$time (${transport.distance}km)',
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