import 'package:houscore/common/model/hasName.dart';
import 'package:houscore/common/model/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/component/list_section.dart';
import '../../residence/utils/place_utils.dart';

part 'interested_area.g.dart';

@JsonSerializable()
class InterestedAreaModel extends IModelWithNameAndId{
  final int areaId;
  final String address;

  InterestedAreaModel({
    required this.areaId,
    required this.address,
  }) : super(id: areaId);


  factory InterestedAreaModel.fromJson(Map<String, dynamic> json) {
    return InterestedAreaModel(
      areaId: json['areaId'],
      address: PlaceUtils.shortenMapAddress(json['address']),
    );
  }
  Map<String, dynamic> toJson() => _$InterestedAreaModelToJson(this);

  @override
  String get name => address;
}
