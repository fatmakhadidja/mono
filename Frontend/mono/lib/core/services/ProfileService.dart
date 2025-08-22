import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profileservice {
  String baseUrl = "http://192.168.1.7:8081/api/profile";

  Future<String?> changeFullname(String fullName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception("No token found. User might not be logged in.");
      }

      final response = await http.put(
        Uri.parse("$baseUrl/change_fullname/${fullName}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Seccesfully changed full name !");
        return null;
      }
    } catch (e) {
      print("Error changing fullname: $e");
      return "Error changing fullname: $e";
    }
  }

  Future<String?> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception("No token found. User might not be logged in.");
      }

      final response = await http.put(
        Uri.parse(
          "$baseUrl/change_password?currentPassword=$currentPassword&newPassword=$newPassword",
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return null;
      } else if (response.statusCode == 400 &&
          response.body == "Current password is incorrect") {
        return "Current password is incorrect";
      }
    } catch (e) {
      return "Error changing password: $e";
    }
  }

  Future<Uint8List?> getProfilePic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception("No token found. User might not be logged in.");
      }

      final response = await http.get(
        Uri.parse("$baseUrl/picture"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; 
      } else {
        print("Failed to load profile picture. Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching profile picture: $e");
      return null;
    }
  }
}
