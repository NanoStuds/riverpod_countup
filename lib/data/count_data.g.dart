// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CountDataImpl _$$CountDataImplFromJson(Map<String, dynamic> json) =>
    _$CountDataImpl(
      count: (json['count'] as num).toInt(),
      countUp: (json['countUp'] as num).toInt(),
      countDown: (json['countDown'] as num).toInt(),
    );

Map<String, dynamic> _$$CountDataImplToJson(_$CountDataImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'countUp': instance.countUp,
      'countDown': instance.countDown,
    };
