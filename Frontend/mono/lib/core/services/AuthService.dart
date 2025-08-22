import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String baseUrl = "http://192.168.1.7:8081/api/auth";
  String? token;

  /// Save token locally in SharedPreferences
  Future<void> _saveTokenAndFullnameAndEmail(
    String token,
    String fullName,
    String email,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setString('fullName', fullName);
    await prefs.setString('email', email);

    this.token = token;
  }

  /// Load token from SharedPreferences
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
  }

  /// Remove token (logout)
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('fullName');
    await prefs.remove('balance');
    await prefs.remove('incomeAmount');
    await prefs.remove('expenseAmount');
    token = null;
    Navigator.pushReplacementNamed(context, '/login');
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
        final data = jsonDecode(response.body)['fullName'];
        final email = jsonDecode(response.body)['email'];

        await _saveTokenAndFullnameAndEmail(token, data ?? "", email);
        return null;
      } else if (response.statusCode == 403) {
        return "Invalid credentials";
      } else {
        return "Login failed. Try again";
      }
    } catch (e) {
      return "Login error: $e";
    }
  }


Future<String?> register(
  String fullname,
  String password,
  String email,
  File? imageFile,
) async {
  try {
    String? base64Image;
    if (imageFile != null) {
      // Convert image file to Base64
      final bytes = await imageFile.readAsBytes();
      base64Image = base64Encode(bytes);
    }

    // JSON body
    final body = jsonEncode({
      "fullName": fullname,
      "password": password,
      "email": email,
      "image": base64Image, // can be null
    });

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final token = jsonDecode(response.body)['token'];
      await _saveTokenAndFullnameAndEmail(token, fullname, email);
      return null;
    } else if (response.statusCode == 409) {
      return "The email you entered already exists";
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
