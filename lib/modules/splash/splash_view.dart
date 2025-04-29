import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: const Color(0xFF4A90E2),
      body: Container(
        color: Color(0XFFfcfbfb),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/app/splash_image.png',
        ),
      ),
    );
  }
}
