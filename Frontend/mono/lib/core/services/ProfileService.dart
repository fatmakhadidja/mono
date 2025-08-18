import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Profileservice {
  String baseUrl = "http://192.168.1.7:8081/api/profile";

  Future<String?> changeFullname(String fullName) async{

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
      return null;
    }
  }

}
