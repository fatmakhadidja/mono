
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefFunctions {
  static Future<void> saveFullName(String fullName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fullName', fullName);
  }

  static Future<void> getFullName(String? fullname ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    fullname = prefs.getString('fullName');
  }
  
  static Future<void> removeFullName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('fullName');
  }
}
