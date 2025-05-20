import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/models/place/place_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/util/const/fire_store_collection_name.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';

class RecommendPlanDetailController extends GetxController {
  /// 유저 컨트롤러
  final userCtrl = Get.find<UserController>();

  late RecommendPlanModel recommendPlanModel;

  bool isLoadingProgress = false;

  @override
  void onInit() {
    if (Get.arguments is RecommendPlanModel) {
      recommendPlanModel = Get.arguments;
    }

    super.onInit();
  }

  @override
  void onReady() {
    if (Get.arguments is! RecommendPlanModel) {
      showToast('데이트 플랜 데이터가 유효하지 않습니다.');

      /// init 에 안 하고 ready 에 한 이유는
      /// init 에서 Get.back 할 경우 해당 컨트롤러가 메모리에서 해제되지 않기 때문
      Get.back();
    }
    super.onReady();
  }

  /// @author 정준형
  /// @since 2025. 5. 16.
  /// @comment 데이트 플랜 수정 콜백
  ///
  Future<void> onTapEditBtn() async {
    /// TODO 기존에 이거랑 연계된 데이트 기록이 있으면 수정 불가 안내
    /// else 수정으로 이동
    final bool result =
        ((await Get.toNamed(Routes.recommendPlanEdit, arguments: recommendPlanModel)) as bool?) ?? false;

    if (result) {
      isLoadingProgress = true;
      update([':datePlanBody']);

      try {
        /// 수정 되었을 경우 데이터 다시 로드하기
        Map<String, dynamic>? updateRecommendPlanModelMap =
            (await FirebaseFirestore.instance.collection(FireStoreCollectionName.recommendDatePlan).doc(recommendPlanModel.id).get()).data();

        if (updateRecommendPlanModelMap != null) {
          recommendPlanModel = RecommendPlanModel.fromJson(updateRecommendPlanModelMap);

          /// TODO 메인 페이지 업데이트 처리 해줘야 함
        }
      } catch (e) {
        showToast('데이트 플랜 조회에 실패했습니다. 잠시 후 다시 시도해 주세요.');
        return;
      } finally {
        isLoadingProgress = false;
        update([':datePlanBody']);
      }
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 16.
  /// @comment 데이트 플랜 삭제 콜백
  ///
  Future<void> onTapDeleteBtn() async {
    /// TODO 기존에 이거랑 연계된 데이트 기록이 있으면 삭제 불가 안내
    /// else 삭제
    try {
      logger.i(recommendPlanModel.id);
      await FirebaseFirestore.instance.collection(FireStoreCollectionName.recommendDatePlan).doc(recommendPlanModel.id).delete();

      /// TODO 메인 페이지 업데이트 처리 해줘야 함
      showToast('데이트 플랜 삭제가 완료되었습니다.');
      Get.back();
    } catch (e) {
      showToast('데이트 플랜 삭제에 실패했습니다. 잠시 후 다시 시도해 주세요.');
      return;
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 16.
  /// @comment place 클릭 콜백
  ///
  Future<void> onTapPlaceCard(PlaceModel place) async {
    Uri uri = Uri.parse(place.place_url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showToast('${place.place_url}를 열 수 없음');
    }
  }
}
