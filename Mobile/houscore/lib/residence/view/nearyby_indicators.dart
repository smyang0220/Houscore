import 'package:flutter/material.dart';
import 'package:houscore/residence/component/nearby_infra.dart';
import 'package:houscore/residence/component/nearby_public_transportation.dart';

import '../component/about_residence.dart';
import '../component/nearby_living_facilities.dart';
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
    // 병원 예시
    Infra(name: "시내 병원", minutes: 5, distance: 0.5, type: InfraType.hospital),
    Infra(name: "서울 종합 병원", minutes: 8, distance: 1.2, type: InfraType.hospital),
    Infra(name: "강남 성형외과", minutes: 10, distance: 2.0, type: InfraType.hospital),
    Infra(name: "노원 구급 센터", minutes: 12, distance: 3.0, type: InfraType.hospital),

    // 공원 예시
    Infra(name: "중앙 공원", minutes: 7, distance: 0.8, type: InfraType.park),
    Infra(name: "강변 공원", minutes: 15, distance: 1.5, type: InfraType.park),
    Infra(name: "시립 공원", minutes: 20, distance: 2.5, type: InfraType.park),
    Infra(name: "해변 산책로", minutes: 30, distance: 4.0, type: InfraType.park),

    // 학교 예시
    Infra(name: "중앙 초등학교", minutes: 3, distance: 0.3, type: InfraType.school),
    Infra(name: "서울 고등학교", minutes: 6, distance: 0.7, type: InfraType.school),
    Infra(name: "대학교 본부", minutes: 10, distance: 1.0, type: InfraType.school),
    Infra(name: "국제 대학교", minutes: 15, distance: 1.8, type: InfraType.school),
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
            NearbyLivingFacilities(),
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