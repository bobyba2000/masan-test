import 'package:json_annotation/json_annotation.dart';
import 'package:web_test/model/result/user_answer/model.dart';
import 'package:web_test/ui/main/dialog/choose_test.dart';
part 'model.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class ResultModel {
  TestType type;
  double time;
  int point;
  List<UserAnswerModel> answers;
  String username;

  factory ResultModel.fromJson(Map<String, dynamic> json) => _$ResultModelFromJson(json);

  ResultModel({
    required this.type,
    required this.time,
    required this.answers,
    required this.point,
    required this.username,
  });

  Map<String, dynamic> toJson() => _$ResultModelToJson(this);
}
