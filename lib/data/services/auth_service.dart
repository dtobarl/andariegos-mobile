import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final SharedPreferences _prefs;
  static const String _userEmailKey = 'user_email';
  static const String _userPasswordKey = 'user_password';
  static const String _isLoggedInKey = 'is_logged_in';

  AuthService(this._prefs);

  Future<void> login(String email, String password) async {
    // For demo purposes, we'll accept any email/password
    // In a real app, you'd want to add proper validation
    await _prefs.setString(_userEmailKey, email);
    await _prefs.setString(_userPasswordKey, password);
    await _prefs.setBool(_isLoggedInKey, true);
  }

  Future<void> logout() async {
    await _prefs.setBool(_isLoggedInKey, false);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  String? getStoredEmail() {
    return _prefs.getString(_userEmailKey);
  }
} 