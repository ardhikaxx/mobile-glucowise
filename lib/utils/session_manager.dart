import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<String?> getNik() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nik');
  }

  static Future<void> setNik(String nik) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nik', nik);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}