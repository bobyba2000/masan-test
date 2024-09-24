import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:web_test/service/local.dart';

class AuthService {
  final database = FirebaseDatabase.instance.ref('Account');
  Future<void> createAccountForTesting(int count) async {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

    for (var i = 0; i < count; i++) {
      String password = getRandomString(6);
      String index = i.toString().padLeft(3, '0');
      String username = 'test-$index';
      FirebaseDatabase.instance.ref('Account/$username').set(password);
    }
  }

  Future<bool> login(String username, String password) async {
    final database = await FirebaseDatabase.instance.ref('Account/$username').get();
    if (database.exists) {
      if (database.value.toString() == password) {
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    return LocalStorageUtility.storeData('username', '');
  }
}
