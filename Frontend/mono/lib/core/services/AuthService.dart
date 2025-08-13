import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String baseUrl = "http://10.82.77.43:8081/api/auth";
  String? token;

  /// Save token locally in SharedPreferences
  Future<void> _saveTokenAndFullname(String token, String fullname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setString('fullname', fullname);
    print("here is full name -------------- ${prefs.getString('fullname')}");
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
  Future<String?> authenticate(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/authenticate'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        final data = jsonDecode(response.body)['fullname'];
        await _saveTokenAndFullname(token, data ?? "");
        return null;
      } else if (response.statusCode == 401) {
        return "Invalid credentials"; // wrong password or user doesn't exist
      } else {
        return "Login failed. Server returned ${response.statusCode}";
      }
    } catch (e) {
      return "Login error: $e";
    }
  }

  /// Register new user
  Future<String?> register(
    String fullname,
    String password,
    String email,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fullName': fullname,
              'password': password,
              'email': email,
            }),
          )
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          try {
            final token = jsonDecode(response.body)['token'];
            await _saveTokenAndFullname(token, fullname);
          } catch (_) {}
        }
        return null; // success
      } else if (response.statusCode == 409) {
        return "Email already exists";
      } else {
        return "Registration failed. Server returned ${response.statusCode}";
      }
    } catch (e) {
      return "Registration error: $e";
    }
  }

  /// Example of calling a protected endpoint
  Future<String?> getProtectedData() async {
    if (token == null) await loadToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/protected'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }
}
