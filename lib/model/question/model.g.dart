// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      question: json['Question'] as String,
      answers: (json['Answers'] as List<dynamic>)
          .map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      scenario: json['Scenario'] as String?,
      url: json['Url'] as String?,
    )..type = $enumDecodeNullable(_$QuestionTypeEnumMap, json['Type']);

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'Question': instance.question,
      'Url': instance.url,
      'Scenario': instance.scenario,
      'Answers': instance.answers,
      'Type': _$QuestionTypeEnumMap[instance.type],
    };

const _$QuestionTypeEnumMap = {
  QuestionType.numerical: 'numerical',
  QuestionType.scenario: 'scenario',
  QuestionType.verbal: 'verbal',
  QuestionType.logical: 'logical',
  QuestionType.techVMT: 'Vietnam Market Trends',
  QuestionType.techPortfolio: 'Portfolio Strategy',
  QuestionType.techConsumerNeed: 'Consumer Needs',
  QuestionType.techDigitalMarketing: 'Digital Marketing',
  QuestionType.techProductLaunching: 'Product Launching',
  QuestionType.techCrossWork: 'Cross-work & Conflict Resolution',
  QuestionType.techFMCGUndestanding: 'FMCG Understanding',
  QuestionType.techProblem: 'Problem-Solving and Strategic Thinking',
};
