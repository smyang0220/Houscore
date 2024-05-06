import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/residence/utils/place_utils.dart';
import '../model/residence_detail_indicators_model.dart';

class NearbyPublicTransportation extends StatefulWidget {
  final List<Infra> transportItems;

  const NearbyPublicTransportation({
    Key? key,
    required this.transportItems,
  }) : super(key: key);

  @override
  _NearbyPublicTransportationState createState() =>
      _NearbyPublicTransportationState();
}

class _NearbyPublicTransportationState
    extends State<NearbyPublicTransportation> {
  bool _showBuses = true;

  @override
  Widget build(BuildContext context) {
    // 필터링된 리스트: _showBuses 값에 따라 버스 또는 지하철만 표시
    // List<PublicTransport> filteredList = widget.transportItems.where((item) => item.busOrSubway == _showBuses).toList();
    List<Infra> transportList = widget.transportItems.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '주변 대중교통',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 15),
        ...List.generate(transportList.length, (index) {
          Infra transport = transportList[index];
          String transportType;
          int time = PlaceUtils.convertDistance(transport.distance)['minute'];
          Image leadingIcon = Image.asset(
            transport.type == InfraType.bus
                ? 'asset/icon/bus.png'
                : 'asset/icon/subway.png',
            width: 15,
          );
          Color color;

          return ListTile(
            leading: leadingIcon,
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    transport.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Text(
                  '${time}분 (${transport.distance}km)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
