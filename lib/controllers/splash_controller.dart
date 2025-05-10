import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../widgets/session_string.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<Offset> offsetAnimation;
  final _storage = GetStorage();
  final _random = Random();

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: const Duration(seconds: 1), // Reduced from 0 to 1 second
      vsync: this,
    );

    offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5), // Start slightly below
      end: Offset.zero, // Move to normal position
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutQuart,
      ),
    );

    animationController.forward();
  }

  @override
  void onReady() {
    super.onReady();
    _navigateToAppropriateScreen();
  }

  Future<void> _navigateToAppropriateScreen() async {
    // Random delay between 5-7 seconds (improved from 7-9)
    final delaySeconds = 5 + _random.nextInt(3);
    await Future.delayed(Duration(seconds: delaySeconds));

    final isLoggedIn = _storage.hasData(isLoginSession);
    final routeName = isLoggedIn ? '/home' : '/welcome';

    Get.offAllNamed(routeName); // Using named routes
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
