import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';
import 'package:houscore/residence/utils/place_utils.dart';
import '../../common/utils/data_utils.dart';
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
    List<Infra> transportList = widget.transportItems.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '주변 대중교통',
              style:TextStyle(
    fontFamily: 'NotoSans',fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 16),
        ...transportList.map((transport) {
          int time = PlaceUtils.convertDistance(transport.distance)['minute'];
          Image leadingIcon = Image.asset(
            transport.type == InfraType.bus
                ? 'asset/icon/bus.png'
                : 'asset/icon/subway.png',
            width: 16,
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 7.0, right: 15),
                  child: leadingIcon,
                ),
                Expanded(
                  child: Text(
                    transport.name,
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '${time}분 ',
                  style:
                  transport.type == InfraType.bus ?
                  TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                  ) : TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue
                  ) ,
                ),
                Text(
                  '(${transport.distance.toStringAsFixed(1)}km)',
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
        }).toList(),
        SizedBox(height: 16,),
        Divider(),
      ],
    );
  }
}
