import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildingDetail extends ConsumerStatefulWidget {
  const BuildingDetail({Key? key}) : super(key: key);

  @override
  _BuildingDetailState createState() => _BuildingDetailState();
}

class _BuildingDetailState extends ConsumerState<BuildingDetail> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '건물 정보',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Visibility(
          visible: _isExpanded,
          child: FutureBuilder(
            future: _fetchBuildingDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return _buildDetailsTable(snapshot.data);
              }
            },
          ),
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
                Text('더보기'),
                Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _fetchBuildingDetails() async {
    // API 요청을 구현하세요.
    // 예시로 Future.delayed를 사용해 모의 데이터를 반환하도록 설정했습니다.
    return Future.delayed(
      const Duration(seconds: 2),
          () => {"Year Built": "1999", "Floors": "12", "Area": "15,000 sq ft"},
    );
  }

  Widget _buildDetailsTable(dynamic data) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Property')),
        DataColumn(label: Text('Value')),
      ],
      rows: data.entries.map<DataRow>((entry) {
        return DataRow(
          cells: [
            DataCell(Text(entry.key)),
            DataCell(Text(entry.value)),
          ],
        );
      }).toList(),
    );
  }
}
