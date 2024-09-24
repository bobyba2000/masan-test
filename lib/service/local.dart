import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtility {
  static Future<void> storeData(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(key, value);
    return;
  }

  static Future<String?> getData(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }
}
