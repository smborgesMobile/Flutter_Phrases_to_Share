import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/auth_user.dart';

class AuthStorage {
  static const _key = 'auth_user_v1';

  Future<void> saveUser(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'photoUrl': user.photoUrl,
    });
    await prefs.setString(_key, json);
  }

  Future<AuthUser?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return AuthUser(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        photoUrl: map['photoUrl'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
