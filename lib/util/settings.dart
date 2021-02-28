import 'package:shared_preferences/shared_preferences.dart';

class ElephantSettings {
  
  static setBolean(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getBolean(String key, bool fallback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool(key);
    return result != null ? result : fallback;
  }

  static setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int> getInt(String key, int fallback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int result = prefs.getInt(key);
    return result != null ? result : fallback;
  }

}