import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/residence/component/nearby_infra.dart';
import 'package:houscore/residence/component/nearby_public_transportation.dart';
import 'package:houscore/residence/component/nearby_living_facilities.dart';
import 'package:houscore/residence/component/residence_price_safety.dart';
import 'package:houscore/residence/model/residence_detail_indicators_model.dart';
import 'package:houscore/residence/provider/residence_detail_indicators_provider.dart';
import 'package:lottie/lottie.dart';

import '../../common/model/data_state_model.dart';
import '../component/residence_detail_info.dart';
import '../model/location_model.dart';
import '../repository/naver_map_repository.dart';
import '../repository/residence_repository.dart';

class NearbyIndicators extends ConsumerStatefulWidget {
  final String address;

  const NearbyIndicators({Key? key, required this.address}) : super(key: key);

  @override
  ConsumerState<NearbyIndicators> createState() => _NearbyIndicatorsState();
}

class _NearbyIndicatorsState extends ConsumerState<NearbyIndicators> {
  Location? _currentLocation;

// 위도와 경도 값을 불러오기 위한 함수
  Future<void> _fetchLatLng(String address) async {
    try {
      final response = await ref
          .read(naverMapRepositoryProvider)
          .getLatLngFromAddress(widget.address);

// 응답 데이터 파싱
      if (response.data.isNotEmpty) {
        final responseData = response.data;
        // print("responseData['status'] = ${responseData['status']}");
        if (responseData['status'] == 'OK' &&
            responseData['addresses'].isNotEmpty) {
          final addressInfo = responseData['addresses'][0];
          final latitude = double.parse(addressInfo['y']);
          final longitude = double.parse(addressInfo['x']);
          // print('( ${latitude}, ${longitude} )');
          setState(() {
            _currentLocation = Location(address: widget.address, latitude: latitude, longitude: longitude);
            // print(
            //     '_currentLocation = (${_currentLocation?.address} : ${_currentLocation?.latitude} , ${_currentLocation?.longitude})');
          });
        } else {
          // print('latLng change error [EMPTY ADDRESS OR BAD STATUS]');
          setState(() => _currentLocation = null);
        }
      }
      else {
        // print('latLng change error [EMPTY RESPONSE]');
        setState(() => _currentLocation = null);
      }
    } catch (e) {
      // print('latLng change error [API ERROR]');
      // print(e.toString());
      setState(() => _currentLocation = null);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier =
        ref.watch(residenceDetailIndicatorProvider(widget.address).notifier);
    notifier.fetchDetailIndicator();
    _fetchLatLng(widget.address); // 위경도 값을 받아옴
  }

  // 카테고리별 가장 가까운 곳 찾기
  Infra? findClosestInfra(List<Infra> infras) {
    if (infras.isEmpty) return null;
    return infras.reduce((closest, current) =>
    current.distance < closest.distance ? current : closest);
  }

  // 전체 카테고리에서 가까운 곳들 찾아서 리스트화
  List<Infra>? getClosestInfras(ResidenceDetailIndicatorsModel? model) {
    if (model == null) return null;

    List<Infra> closestInfras = [];

    // 각 유형별로 최소 거리 인프라 찾기
    var closestMedical = findClosestInfra(model.infras.medicalFacilities);
    if (closestMedical != null) closestInfras.add(closestMedical);

    var closestPark = findClosestInfra(model.infras.park);
    if (closestPark != null) closestInfras.add(closestPark);

    var closestSchool = findClosestInfra(model.infras.school);
    if (closestSchool != null) closestInfras.add(closestSchool);

    var closestLibrary = findClosestInfra(model.infras.library);
    if (closestLibrary != null) closestInfras.add(closestLibrary);

    var closestSupermarket = findClosestInfra(model.infras.supermarket);
    if (closestSupermarket != null) closestInfras.add(closestSupermarket);

    var closestBus = findClosestInfra(model.publicTransport.bus);
    if (closestBus != null) closestInfras.add(closestBus);

    var closestSubway = findClosestInfra(model.publicTransport.subway);
    if (closestSubway != null) closestInfras.add(closestSubway);

    closestInfras.sort((a, b) => a.distance.compareTo(b.distance));

    return closestInfras;
  }

  List<Infra>? getInfrasByTypes(
      List<InfraType> types, ResidenceDetailIndicatorsModel? data) {
    if (data == null) return null;

    List<Infra> selectedInfras = [];
    int maxCount = 4; // 항목별 최대 갯수
    for (InfraType type in types) {
      List<Infra> infrasToAdd = [];
      switch (type) {
        case InfraType.medicalFacilities:
          infrasToAdd.addAll(data.infras.medicalFacilities);
          break;
        case InfraType.park:
          infrasToAdd.addAll(data.infras.park);
          break;
        case InfraType.school:
          infrasToAdd.addAll(data.infras.school);
          break;
        case InfraType.bus:
          infrasToAdd.addAll(data.publicTransport.bus);
          break;
        case InfraType.subway:
          infrasToAdd.addAll(data.publicTransport.subway);
          break;
        case InfraType.library:
          infrasToAdd.addAll(data.infras.library);
          break;
        case InfraType.supermarket:
          infrasToAdd.addAll(data.infras.supermarket);
          break;
      }
      infrasToAdd.sort((a, b) => a.distance.compareTo(b.distance));
      selectedInfras.addAll(infrasToAdd.take(maxCount));
    }
    return selectedInfras;
  }

  @override
  Widget build(BuildContext context) {
    // final repository = ref.watch(residenceRepositoryProvider);
    // final data = await repository.getResidenceDetailIndicator(address: widget.address);

    final data = ref.watch(residenceDetailIndicatorProvider(widget.address));

    // 상태에 따른 조건 처리
    if (data is DataStateLoading) {
      // 로딩 중 상태
      return Lottie.asset('asset/img/logo/loading_lottie_animation.json');
    }
    // else if (data is DataStateError) {
      // 에러 상태
      // return const Text('주변 지표에 대한 데이터를 불러오는데 실패했습니다.');
    // }
    // else if (data is DataState<ResidenceDetailIndicatorsModel>) {
    else  {
      // 성공적으로 데이터를 불러온 상태
      final residenceData = data is DataState<ResidenceDetailIndicatorsModel> ? data.data : null;

      // 다음 함수들을 호출할 때 residenceData를 사용
      List<Infra>? nearbyInfras = getInfrasByTypes(
          [InfraType.medicalFacilities, InfraType.park, InfraType.school],
          residenceData);
      List<Infra>? nearbyPublicTransportation =
          getInfrasByTypes([InfraType.bus, InfraType.subway], residenceData);

      return Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('현재 위경도는 ${_currentLatLng?.latitude} , ${_currentLatLng?.longitude}'),
              NearbyLivingFacilities(
                  closestInfras: getClosestInfras(residenceData)),
              NearbyInfra(infras: nearbyInfras ?? []),
              NearbyPublicTransportation(
                  transportItems: nearbyPublicTransportation ?? []),
              ResidencePriceSafety(
                  realCost: residenceData?.realCost,
                  pricePerPyeong: residenceData?.pricePerPyeong,
                  safetyGrade: residenceData?.safetyGrade),
              ResidenceDetailInfo(location: _currentLocation),
            ],
          ),
        ),
      );
    }
    // else {
    //   return Text('오류입니다.');
    // }
  }
}
