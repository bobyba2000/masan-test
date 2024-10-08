import 'package:json_annotation/json_annotation.dart';
import 'package:web_test/model/question/answer/model.dart';
part 'model.g.dart';

enum QuestionType {
  numerical,
  scenario,
  critical,
  verbal,
  logical,
  
  @JsonValue('Vietnam Market Trends')
  techVMT,
  @JsonValue('Portfolio Strategy')
  techPortfolio,
  @JsonValue('Consumer Needs')
  techConsumerNeed,
  @JsonValue('Digital Marketing')
  techDigitalMarketing,
  @JsonValue('Product Launching')
  techProductLaunching,
  @JsonValue('Cross-work & Conflict Resolution')
  techCrossWork,
  @JsonValue('FMCG Understanding')
  techFMCGUndestanding,
  @JsonValue('Problem-Solving and Strategic Thinking')
  techProblem;
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class QuestionModel {
  final String question;
  final String? url;
  final String? scenario;
  final List<AnswerModel> answers;
  QuestionType? type;

  QuestionModel({
    required this.question,
    required this.answers,
    this.scenario,
    this.url,
    
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}
