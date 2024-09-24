// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultModel _$ResultModelFromJson(Map<String, dynamic> json) => ResultModel(
      type: $enumDecode(_$TestTypeEnumMap, json['Type']),
      time: (json['Time'] as num).toDouble(),
      answers: (json['Answers'] as List<dynamic>)
          .map((e) => UserAnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      point: json['Point'] as int,
      username: json['Username'] as String,
    );

Map<String, dynamic> _$ResultModelToJson(ResultModel instance) =>
    <String, dynamic>{
      'Type': _$TestTypeEnumMap[instance.type]!,
      'Time': instance.time,
      'Point': instance.point,
      'Answers': instance.answers,
      'Username': instance.username,
    };

const _$TestTypeEnumMap = {
  TestType.brandManager: 'brandManager',
  TestType.assistantBM: 'assistantBM',
  TestType.brandExecutive: 'brandExecutive',
  TestType.customType: 'customType',
};
