import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/screens/home_screen.dart';
import 'package:sky_techiez/screens/welcome_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sky Techiez',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      home: const WelcomeScreen(),
      // home: const HomeScreen(),
    );
  }
}
