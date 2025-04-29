import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../user/user_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(milliseconds: 1000)); // 스플래시 애니메이션용

    if (FirebaseAuth.instance.currentUser != null) {
      /// 유저 상태 초기화
      await Get.find<UserController>().loadUser();
    } else {
      Get.offAllNamed(Routes.auth);
    }
  }
}
