import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houscore/common/const/color.dart';
import 'package:lottie/lottie.dart';
import '../../common/model/data_state_model.dart';
import '../model/location_model.dart';
import '../provider/residence_detail_info_provider.dart';
import '../model/residence_detail_info_model.dart';

class ResidenceDetailInfo extends ConsumerStatefulWidget {
  final Location? location;

  const ResidenceDetailInfo({Key? key, this.location}) : super(key: key);

  @override
  _ResidenceDetailInfoState createState() => _ResidenceDetailInfoState();
}

class _ResidenceDetailInfoState extends ConsumerState<ResidenceDetailInfo> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '건물 상세 정보',
            style: TextStyle(
                fontFamily: 'NotoSans',fontSize: 18, fontWeight: FontWeight.w100),
          ),
        ),
        SizedBox(height: 15,),
        Visibility(
          visible: _isExpanded,
          maintainState: true,
          child: widget.location != null
              ? Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(residenceDetailInfoProvider(widget.location!));
                    if (state is DataStateLoading) {
                      return Lottie.asset('asset/img/logo/loading_lottie_animation.json');
                    }
                    else if (state is DataStateError) {
                      return Container(
                          height: 300,
                          child: Column(
                            children: [
                              Expanded(
                                child: Lottie.asset(
                                    'asset/img/logo/error_lottie_animation_cat.json'),
                              ),
                              Text(
                                '해당 주소의 건물에 관한 상세 정보를 찾지 못했습니다.',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                          ));
                    }
                    else if (state is DataState<ResidenceDetailInfoModel>) {return _buildDetailsTable(state.data);}
                    else {return Text('데이터를 불러오는 중 문제가 발생했습니다.');}
                  },
                )
              : Text('위치 정보가 제공되지 않았습니다.'),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_isExpanded ? '접기' : '보기'),
                Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTable(ResidenceDetailInfoModel data) {
    double tableWidth = MediaQuery.of(context).size.width;

    return DataTable(
      headingRowColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered))
            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
          return PRIMARY_COLOR; // 기본 색상 설정
        },
      ),
      headingRowHeight: 40,
      dividerThickness: 2,
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey),
        verticalInside: BorderSide(color: Colors.grey),
        left: BorderSide(color: Colors.grey),
        right: BorderSide(color: Colors.grey),
        bottom: BorderSide(color: Colors.grey, width: 2),
      ),
      columns: [
        DataColumn(
          label: Container(
            alignment: Alignment.center,
            width: tableWidth / 4,  // 나머지 반을 사용하여 두 번째 열의 너비를 설정합니다.
            child: Text('항목'),
          ),
        ),
        DataColumn(
          label: Container(
            alignment: Alignment.center,
            width: tableWidth / 4,  // 나머지 반을 사용하여 두 번째 열의 너비를 설정합니다.
            child: Text('값'),
          ),
        ),
      ],
      rows: [
        _buildDataRow('대지 면적(㎡)', '${data.buildingInfo.platArea == 0 ? '정보 없음' : data.buildingInfo.platArea}'),
        _buildDataRow('건축 면적(㎡)', '${data.buildingInfo.archArea == 0 ? '정보 없음' : data.buildingInfo.archArea}'),
        _buildDataRow('총 면적(㎡)', '${data.buildingInfo.totArea == 0 ? '정보 없음' : data.buildingInfo.totArea}'),
        _buildDataRow('건폐율(%)', '${data.buildingInfo.bcRat == 0 ? '정보 없음' : data.buildingInfo.bcRat}'),
        _buildDataRow('용적률(%)', '${data.buildingInfo.vlRat == 0 ? '정보 없음' : data.buildingInfo.vlRat}'),
        _buildDataRow('주요 용도', data.buildingInfo.mainPurpsCdNm),
        _buildDataRow('등기 종류', data.buildingInfo.regstrKindCdNm),
        _buildDataRow('세대 수', '${data.buildingInfo.hhldCnt}'),
        _buildDataRow('주 건물 수', '${data.buildingInfo.mainBldCnt}'),
        _buildDataRow('총 주차 공간 수', '${data.buildingInfo.totPkngCnt}'),
      ],
    );
  }

  DataRow _buildDataRow(String name, String value) {
    return DataRow(
      cells: [
        DataCell(Center(child: Text(name))),
        DataCell(Center(child: Text(value))),
      ],
    );
  }
}
