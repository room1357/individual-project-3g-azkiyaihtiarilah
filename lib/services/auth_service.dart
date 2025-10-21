import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'registered_users';
  static const String _loggedInUserKey = 'logged_in_user';

  /// Register user baru
  static Future<bool> registerUser({
    required String fullname,
    required String email,
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final usersJson = prefs.getString(_userKey);
    List<dynamic> users = usersJson != null ? jsonDecode(usersJson) : [];

    // Cek apakah username sudah ada
    bool exists = users.any((u) => u['username'] == username);
    if (exists) return false;

    users.add({
      'fullname': fullname,
      'email': email,
      'username': username,
      'password': password,
    });

    await prefs.setString(_userKey, jsonEncode(users));
    return true;
  }

  /// Login user (cek dari SharedPreferences)
  static Future<bool> loginUser({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_userKey);

    if (usersJson == null) return false;

    List<dynamic> users = jsonDecode(usersJson);

    final user = users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => null,
    );

    if (user != null) {
      await prefs.setString(_loggedInUserKey, jsonEncode(user));
      return true;
    }

    return false;
  }

  /// Ambil user yang sedang login
  static Future<Map<String, dynamic>?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_loggedInUserKey);
    return userJson != null ? jsonDecode(userJson) : null;
  }

  /// Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInUserKey);
  }
}
