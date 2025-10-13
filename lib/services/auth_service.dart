import 'dart:convert';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userKey = 'registered_users';
  static const String _loggedInUserKey = 'logged_in_user';

  // 🔹 Dummy user tunggal
  static final List<User> _users = [
    User(
      fullname: 'User Dummy',
      email: 'user1@example.com',
      username: 'user1',
      password: 'password1',
    ),
  ];

  static User? _loggedInUser;

  /// Simpan user baru ke SharedPreferences
  static Future<bool> registerUser({
    required String fullname,
    required String email,
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final usersJson = prefs.getString(_userKey);
    List<dynamic> users = usersJson != null ? jsonDecode(usersJson) : [];

    // Cek apakah username sudah digunakan
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

  /// Login user (cek username dan password)
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

  /// Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInUserKey);
  }
}
