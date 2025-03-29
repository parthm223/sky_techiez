import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController controller = Get.put(SplashController());
  @override
  void initState() {
    super.initState();
    // getBaseURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlideTransition(
      position: controller.offsetAnimation,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/SkyLogo.png",
                        fit: BoxFit.cover, height: 65, width: 65),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
