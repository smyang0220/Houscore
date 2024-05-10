import 'package:houscore/common/model/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'interested_area.g.dart';

@JsonSerializable()
class InterestedArea extends IModelWithId{
  final int areaId;
  final String address;

  InterestedArea({
    required this.areaId,
    required this.address,
  }) : super(id: areaId);

  // JSON serialization
  factory InterestedArea.fromJson(Map<String, dynamic> json) => _$InterestedAreaFromJson(json);
  Map<String, dynamic> toJson() => _$InterestedAreaToJson(this);
}
