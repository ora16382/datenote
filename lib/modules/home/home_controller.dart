import 'package:datenote/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constant/enum/home_type.dart';

class HomeController extends GetxController {
  final homeType = HomeType.main.obs;

  @override
  void onReady() {
    /// 가입시 추가정보 이동 화면으로 이동
    if (GetStorage().read("isSignupFinished") ?? false) {
      Get.toNamed(Routes.collectInformation);
      GetStorage().remove("isSignupFinished");
    }
    super.onReady();
  }

  /// @author 정준형
  /// @since 2025. 4. 29.
  /// @comment
  ///
  void onTapBottomNavi(int value) {
    homeType.value = HomeType.values[value];
  }

  /// @author 정준형
  /// @since 2025. 4. 29.
  /// @comment
  ///
  void onTapDateHistoryWriteBtn() {
    Get.toNamed(Routes.datingHistoryEdit);
  }

  /// @author 정준형
  /// @since 2025. 4. 29.
  /// @comment 데이트 플랜 추천 버튼 클릭 콜백
  ///
  void onTapDatePlanRecommendBtn() {
    Get.toNamed(Routes.recommendPlan);
  }
}
