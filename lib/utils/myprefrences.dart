import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences {
  static const THEME_STATUS = "THEMESTATUS";
  static const Daily_val = "Daily_val";
  static const time_val = "time_val";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
  Future<String> getdaily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Daily_val) ?? "None";
  }
  Future<String> gettime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(time_val) ?? "00:00 AM";
  }

}