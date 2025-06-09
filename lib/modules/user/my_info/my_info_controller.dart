import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/util/widget/dialog.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../auth/auth_controller.dart';

class MyInfoController extends GetxController {
  final authController = Get.find<AuthController>();

  Future<PackageInfo> loadPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  /// 로그아웃 클릭 콜백
  Future<void> onTapLogout() async {
    if (await showTwoButtonDialog(contents: '로그아웃 하시겠습니까?', positiveButton: '확인', negativeButton: '취소', positiveCallBack: () {
      Get.back(result: true); // 다이얼로그 닫고
    })) {
      authController.signOut();
    }
  }

  /// 개인정보 수정 클릭 콜백
  Future<void> onTapEditProfile() async {
    if ((await Get.toNamed(Routes.collectInformation, parameters: {'isModify': 'true'})
            as bool?) ??
        false) {
      /// 수정했을 경우
      update([':myInfoCard']);
    }
  }

  void onTapManageAddress() {
    Get.toNamed(Routes.addressManage);
  }
}
