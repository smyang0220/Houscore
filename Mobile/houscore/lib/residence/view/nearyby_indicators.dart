import 'package:flutter/material.dart';
import 'package:houscore/residence/component/nearby_infra.dart';
import 'package:houscore/residence/component/nearby_public_transportation.dart';

import '../component/about_residence.dart';
import '../component/price_per_pyeong.dart';
import '../model/about_residence_model.dart';
import '../model/nearby_infra_model.dart';
import '../model/nearby_public_transportation_model.dart';

class NearbyIndicators extends StatefulWidget {
  const NearbyIndicators ({Key? key}) : super (key: key);

  @override
  State<StatefulWidget> createState() => _NearbyIndicatorsState();
}

class _NearbyIndicatorsState extends State<NearbyIndicators> {

  List<Infra> infraItems = [
    // 가상의 데이터
    Infra(name: '청담가정의학과의원', minutes: 15, distance: 0.9, hospitalOrPark: true),
    Infra(name: '대청메디컬내과의원', minutes: 8, distance: 2.4, hospitalOrPark: true),
    Infra(name: '유성소공원', minutes: 12, distance: 3.3, hospitalOrPark: false),
    Infra(name: '강아름대공원', minutes: 20, distance: 6.7, hospitalOrPark: false),
  ];

  List<PublicTransport> transportItems = [
    // 버스 정류장 예시
    PublicTransport(name: '청담 버스정류장', distance: 0.5, busOrSubway: true),
    PublicTransport(name: '대청마루 버스정류장', distance: 1.1, busOrSubway: true),
    // 지하철 역 예시
    PublicTransport(name: '강남역', distance: 0.7, busOrSubway: false),
    PublicTransport(name: '선릉역', distance: 1.2, busOrSubway: false),
  ];

  AboutResidenceModel residenceInfo = AboutResidenceModel(
    primarySchoolDistance: 0.3,  // 가까운 초등학교 거리
    middleSchoolDistance: 0.75,  // 가까운 중학교 거리
    safetyGrade: 3,              // 안전 등급
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NearbyInfra(infraItems: infraItems),
            NearbyPublicTransportation(transportItems: transportItems),
            AboutResidence(
              primarySchoolDistance: residenceInfo.primarySchoolDistance,
              middleSchoolDistance: residenceInfo.middleSchoolDistance,
              safetyGrade: residenceInfo.safetyGrade,
            ),
            PricePerPyeong(finalPrice: 120, averagePrice: 100)
            // NearbyPublicTransportation(transportItems: transportItems),
            // Text('치안'),
            // Text('실거래가'),
          ],
        ),
      ),
    );
  }
}