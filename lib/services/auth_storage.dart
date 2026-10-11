import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _nameKey = 'user_name';
  static const _emailKey = 'user_email';
  static const _passwordKey = 'user_password';
  static const _loggedInKey = 'logged_in';

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_nameKey, name.trim());
    await preferences.setString(_emailKey, email.trim().toLowerCase());
    await preferences.setString(_passwordKey, password);
    await preferences.setBool(_loggedInKey, true);
    return true;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final valid = preferences.getString(_emailKey) == email.trim().toLowerCase() &&
        preferences.getString(_passwordKey) == password;
    if (valid) await preferences.setBool(_loggedInKey, true);
    return valid;
  }

  Future<String?> loadName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_nameKey);
  }

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_loggedInKey) ?? false;
  }

  Future<void> signOut() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_loggedInKey, false);
  }
}
