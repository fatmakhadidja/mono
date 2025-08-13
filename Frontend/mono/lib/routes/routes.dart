import 'package:flutter/material.dart';
import 'package:mono/ui/screens/home_screen.dart';
import 'package:mono/ui/screens/login_screen.dart';
import 'package:mono/ui/screens/onboarding_screen.dart';
import 'package:mono/ui/screens/register_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
        case home:
        return MaterialPageRoute(builder: (_) =>HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
