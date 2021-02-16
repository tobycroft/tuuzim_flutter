import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<String> Get(String key) async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.get(key);
  }

  static Future<bool> Set(String key, value) async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.setString(key, value);
  }

  static Future<bool> Clear() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.clear();
  }

  static Future<bool> Delete(String key) async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.remove(key);
  }

  static Future<bool> Has(String key) async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.containsKey(key);
  }
}
