import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static setLocale(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await storage.write(key: "ApiUrl", value: value);
    await prefs.setString("Locale", value);
  }

  static Future<dynamic> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? value = await storage.read(key: "ApiUrl");
    // return value;
    return prefs.getString("Locale");
  }

  static setPower(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await storage.write(key: "ApiUrl", value: value);
    await prefs.setString("powerR", value);
  }

  static Future<dynamic> getPower() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? value = await storage.read(key: "ApiUrl");
    // return value;
    return prefs.getString("powerR");
  }

  static setPopupInfo(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(value);
    // await storage.write(key: "ApiUrl", value: value);
    await prefs.setString("popupInfo", value);
  }

  static Future<dynamic> getPopupInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? value = await storage.read(key: "ApiUrl");
    // return value;
    return prefs.getString("popupInfo");
  }
}
