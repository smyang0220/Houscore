import 'package:flutter/material.dart';
import '../utils/place_utils.dart';

class NearbyLivingFacilityWithDistance extends StatelessWidget {
  final PlaceType type;
  final String name;
  final double distance;
  final bool walkOrCar;

  const NearbyLivingFacilityWithDistance({
    Key? key,
    required this.type,
    required this.name,
    required this.distance,
    required this.walkOrCar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> placeInfo = PlaceUtils.convertDistance(distance);
    int minute = placeInfo['minute'];
    Icon leadingIcon = placeInfo['leadingIcon'];

    return GestureDetector(
      onTap: () {
        print('Clicked on ${PlaceUtils.typeName(type)} [${name.toString()}]');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: walkOrCar ? Colors.lightGreen : Colors.lightBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            leadingIcon, // 아이콘을 표시
            SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
            Text(
              '${PlaceUtils.typeName(type)} (${minute}분)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}