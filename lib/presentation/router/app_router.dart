import 'package:easy_contacts/presentation/screens/home/home_layout.dart';
import 'package:easy_contacts/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_contacts/core/constants.dart' as screens;

class AppRouter {
  late Widget startScreen;

  Route? onGenerateRoute(RouteSettings settings){
    startScreen = const SplashScreen();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => startScreen);
      case screens.homeLayout:
        return MaterialPageRoute(builder: (_) => const HomeLayout());
      default:
        return null;
    }
  }
}