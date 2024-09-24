import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:web_test/model/result/model.dart';
import 'package:web_test/service/local.dart';

class ResultService {
  Future<void> submitResult(ResultModel result) async {
    final username = await LocalStorageUtility.getData('username');
    if (username == null) {
      return;
    }
    final data = FirebaseDatabase.instance.ref('Result/$username');
    data.set(
      jsonDecode(jsonEncode(result.toJson())),
    );
  }

  Future<ResultModel?> getResult() async {
    final username = await LocalStorageUtility.getData('username');
    if (username == null) {
      return null;
    }
    final response = await FirebaseDatabase.instance.ref('Result/$username').get();
    if (response.exists) {
      final data = jsonDecode(
        jsonEncode(response.value),
      ) as Map<String, dynamic>;
      return ResultModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<List<ResultModel>> getAllResult() async {
    final response = await FirebaseDatabase.instance.ref('Result').get();
    List<ResultModel> res = [];
    if (response.exists) {
      for (var data in response.children) {
        final value = jsonDecode(jsonEncode(data.value));
        final question = ResultModel.fromJson(value);
        res.add(question);
      }
    }
    return res;
  }
}
