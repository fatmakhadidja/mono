import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fullname;

  @override
  void initState() {
    super.initState();
    _loadFullname();
  }

  Future<void> _loadFullname() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullname = prefs.getString('fullname');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: fullname == null
            ? const CircularProgressIndicator()
            : Text("Hello $fullname"),
      ),
    );
  }
}
