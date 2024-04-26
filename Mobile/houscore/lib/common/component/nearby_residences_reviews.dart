import 'package:flutter/material.dart';
import 'package:houscore/common/const/color.dart';

class NearbyResidencesReview extends StatelessWidget {
  final List<String> residenceNames;
  final VoidCallback onViewAll;

  const NearbyResidencesReview({
    Key? key,
    required this.residenceNames,
    required this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    // Icon(
                    //   Icons.explore,
                    //   size: 32.0,
                    //   color: PRIMARY_COLOR,
                    // ),
                    Text(
                      '🚩 근처 거주지',
                      // '🗺 근처 거주지 리뷰',
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: onViewAll,
                    child: Text(
                      '전체보기',
                      style: TextStyle(color: Colors.grey),
                    )),
              ],
            ),
          ),
          Container(
            height: 40, // 버튼들의 높이
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: residenceNames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      // 각 거주지 버튼 클릭 시 로직
                    },
                    child: Text(residenceNames[index]),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}