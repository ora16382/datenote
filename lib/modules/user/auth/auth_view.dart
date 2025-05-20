import 'package:datenote/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/app/app_icon_contain_text.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 24),
                    child: Text(
                      "AI가 제안하고, 당신이 기록해요.\n오늘의 데이트를 계획하고, 추억으로 남겨보세요.",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleSmall,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo/google_logo.png', // 구글 로고 이미지 경로
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Google로 로그인',
                          style: Get.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GetBuilder<AuthController>(
              id: ':loading',
              builder: (ctrl) {
                if (!ctrl.isLoginProgress) {
                  return const SizedBox();
                } else {
                  return Center(
                    child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
