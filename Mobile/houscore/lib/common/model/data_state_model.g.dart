// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataState<T> _$DataStateFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    DataState<T>(
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$DataStateToJson<T>(
  DataState<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': toJsonT(instance.data),
    };
