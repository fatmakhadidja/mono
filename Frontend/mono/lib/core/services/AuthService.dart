import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String baseUrl = "http://192.168.1.11:8081/api/auth";
  String? token;

  /// Save token locally in SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    this.token = token;
  }

  /// Load token from SharedPreferences (e.g., on app start)
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
  }

  /// Remove token (logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    token = null;
  }

  /// Login and save JWT token
  Future<bool> authenticate(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await _saveToken(token);
      return true;
    }
    return false;
  }

  /// Register new user
  Future<bool> register(String fullname, String password, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullname,
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        try {
          final token = jsonDecode(response.body)['token'];
          await _saveToken(token);
        } catch (_) {}
      }
      return true;
    }
    return false;
  }

  /// Example of calling a protected endpoint
  Future<String?> getProtectedData() async {
    if (token == null) await loadToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/protected'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }
}
