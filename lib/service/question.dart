import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:web_test/model/question/model.dart';

class QuestionService {
  final database = FirebaseDatabase.instance.ref('Question');
  Future<List<QuestionModel>> getTechnicalQuestions() async {
    final technicalDatabase = database.child('Technical');
    final data = await technicalDatabase.get();
    List<QuestionModel> res = [];
    if (data.exists) {
      for (var data in data.children) {
        final value = jsonDecode(jsonEncode(data.value));
        final question = QuestionModel.fromJson(value);
        res.add(question);
      }
    }
    return res;
  }

  Future<List<QuestionModel>> getNumericalQuestion() async {
    final technicalDatabase = database.child('Numerical');
    final data = await technicalDatabase.get();
    List<QuestionModel> res = [];
    if (data.exists) {
      for (var data in data.children) {
        final value = jsonDecode(jsonEncode(data.value));
        final question = QuestionModel.fromJson(value)..type = QuestionType.numerical;
        res.add(question);
      }
    }
    return res;
  }

  Future<List<QuestionModel>> getScenarioQuestion() async {
    final technicalDatabase = database.child('Scenario');
    final data = await technicalDatabase.get();
    List<QuestionModel> res = [];
    if (data.exists) {
      for (var data in data.children) {
        final value = jsonDecode(jsonEncode(data.value));
        final question = QuestionModel.fromJson(value)..type = QuestionType.scenario;
        res.add(question);
      }
    }
    return res;
  }

  Future<List<QuestionModel>> getVerbalQuestion() async {
    final technicalDatabase = database.child('Verbal');
    final data = await technicalDatabase.get();
    List<QuestionModel> res = [];
    if (data.exists) {
      for (var data in data.children) {
        final value = jsonDecode(jsonEncode(data.value));
        final question = QuestionModel.fromJson(value)..type = QuestionType.verbal;
        res.add(question);
      }
    }
    return res;
  }

  Future<List<QuestionModel>> getLogicalQuestion() async {
    final technicalDatabase = database.child('Logical');
    final data = await technicalDatabase.get();
    List<QuestionModel> res = [];
    if (data.exists) {
      for (var data in data.children) {
        final value = jsonDecode(jsonEncode(data.value));
        final question = QuestionModel.fromJson(value)..type = QuestionType.logical;
        res.add(question);
      }
    }
    return res;
  }
}
