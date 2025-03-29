import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/screens/home_screen.dart';
import 'package:sky_techiez/screens/welcome_screen.dart';

import '../widgets/session_string.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  SplashController();

  late AnimationController _controller;
  late Animation<Offset> offsetAnimation;

  @override
  void onInit() {
    super.onInit();
    _controller =
        AnimationController(duration: const Duration(seconds: 0), vsync: this);
    offsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 0.0)).animate(
            CurvedAnimation(parent: _controller, curve: Curves.decelerate));
  }

  @override
  void onReady() {
    super.onReady();
    _launchPage();
  }

  _launchPage() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    bool whereLogin = GetStorage().hasData(isLoginSession);
    if (whereLogin == false) {
      Get.offAll(() => const WelcomeScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }
}
