// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAnswerModel _$UserAnswerModelFromJson(Map<String, dynamic> json) =>
    UserAnswerModel(
      point: json['Point'] as int,
      question:
          QuestionModel.fromJson(json['Question'] as Map<String, dynamic>),
      answer: json['Answer'] as int,
      time: (json['Time'] as num).toDouble(),
    );

Map<String, dynamic> _$UserAnswerModelToJson(UserAnswerModel instance) =>
    <String, dynamic>{
      'Point': instance.point,
      'Question': instance.question,
      'Answer': instance.answer,
      'Time': instance.time,
    };
