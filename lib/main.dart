import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:sky_techiez/screens/splas_screen.dart';

import 'package:sky_techiez/theme/app_theme.dart';

void main() async {
  await GetStorage.init();
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
      home: const SplashScreen(),
      // home: const HomeScreen(),
    );
  }
}
