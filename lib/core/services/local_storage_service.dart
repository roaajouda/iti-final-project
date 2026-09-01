import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String isLoggedInKey = 'isLoggedIn';
  static const String userNameKey = 'userName';

  Future<void> saveUser({required String name}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(isLoggedInKey, true);
    await prefs.setString(userNameKey, name);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(isLoggedInKey) ?? false;
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(userNameKey);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
