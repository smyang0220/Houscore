// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_list_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataListState<T> _$DataListStateFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    DataListState<T>(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$DataListStateToJson<T>(
  DataListState<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': instance.data.map(toJsonT).toList(),
    };
