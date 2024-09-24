import 'package:json_annotation/json_annotation.dart';
import 'package:web_test/model/question/model.dart';
part 'model.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class UserAnswerModel {
  int point;
  QuestionModel question;
  int answer;
  double time;

  UserAnswerModel({
    required this.point,
    required this.question,
    required this.answer,
    required this.time,
  });

  factory UserAnswerModel.fromJson(Map<String, dynamic> json) => _$UserAnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAnswerModelToJson(this);
}
