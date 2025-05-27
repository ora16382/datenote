import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/models/asset/asset_model.dart';
import 'package:datenote/models/dating_history/dating_history_model.dart';
import 'package:datenote/models/place/place_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/util/mixin/controller_loading_mix.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:datenote/util/widget/dialog.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../main_controller.dart';

class RecommendPlanDetailController extends GetxController with ControllerLoadingMix {
  /// 커뮤니티로 진입했는지 여부
  final isCommunity = Get.parameters['isCommunity'] == 'true';

  /// 유저 컨트롤러
  final userCtrl = Get.find<UserController>();

  /// 데이트 플랜 모델
  late RecommendPlanModel recommendPlanModel;

  /// 데이터 로딩 상태
  bool isDataLoadingProgress = false;

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
    /// 기존에 이거랑 연계된 데이트 기록이 있으면 추가 안내
    final associatedDatingHistorySnapshot = (await FirebaseFirestore.instance
        .collection(FireStoreCollectionName.datingHistory)
        .where('recommendPlanId', isEqualTo: recommendPlanModel.id).limit(1).get());

    if(associatedDatingHistorySnapshot.docs.isNotEmpty) {
      if (!await showTwoButtonDialog(
        contents: '연관된 데이트 기록이 있습니다.\n그래도 수정하시겠습니까?',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        return;
      }
    }

    /// else 수정으로 이동
    final bool result =
        ((await Get.toNamed(Routes.recommendPlanEdit, arguments: recommendPlanModel)) as bool?) ?? false;

    if (result) {
      isDataLoadingProgress = true;
      update([':datePlanBody']);

      try {
        /// 수정 되었을 경우 데이터 다시 로드하기
        Map<String, dynamic>? updateRecommendPlanModelMap =
            (await FirebaseFirestore.instance
                    .collection(FireStoreCollectionName.recommendDatePlan)
                    .doc(recommendPlanModel.id)
                    .get())
                .data();

        if (updateRecommendPlanModelMap != null) {
          recommendPlanModel = RecommendPlanModel.fromJson(updateRecommendPlanModelMap);

          /// firestore 에서는 아래와 같이 listener 등록하여 수정사항을 반영 시킬 수 있지만
          /// firestore 한정이기 때문에 코드 범용성을 위하여 직접 조회하여 수정해주는걸로 한다.

          /// FirebaseFirestore.instance
          ///     .collection('dating_history')
          ///     .doc(feedId)
          ///     .snapshots()
          ///     .listen((snapshot) {
          ///     if (snapshot.exists) {
          ///        final model = DatingHistoryModel.fromJson(snapshot.data()!);
          ///         updateUI(model);
          ///       }
          ///     });

          /// 메인-캘린더 업데이트
          try {
            final mainCtrl = Get.find<MainController>();
            mainCtrl.updateDatePlanData(recommendPlanModel.date);
          } catch (e) {
            /// 별다른 동작 없음
          }
        }
      } catch (e) {
        showToast('데이트 플랜 조회에 실패했습니다. 잠시 후 다시 시도해 주세요.');
        return;
      } finally {
        isDataLoadingProgress = false;
        update([':datePlanBody']);
      }
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 16.
  /// @comment 데이트 플랜 삭제 콜백
  ///
  Future<void> onTapDeleteBtn() async {
    /// 기존에 이거랑 연계된 데이트 기록이 있으면 추가 안내
    final associatedDatingHistorySnapshot =
        (await FirebaseFirestore.instance
            .collection(FireStoreCollectionName.datingHistory)
            .where('recommendPlanId', isEqualTo: recommendPlanModel.id)
            .limit(1)
            .get());

    if (associatedDatingHistorySnapshot.docs.isNotEmpty) {
      if (!await showTwoButtonDialog(
        contents: '연관된 데이트 기록이 있습니다.\n그래도 삭제하시겠습니까?',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        return;
      }
    }

    /// else 삭제
    try {
      if (!await showTwoButtonDialog(
        contents: '데이트 플랜을 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        return;
      }

      startLoading();

      await FirebaseFirestore.instance
          .collection(FireStoreCollectionName.recommendDatePlan)
          .doc(recommendPlanModel.id)
          .delete();

      /// 메인-캘린더 업데이트
      try {
        final mainCtrl = Get.find<MainController>();
        mainCtrl.updateDatePlanData(recommendPlanModel.date);
      } catch (e) {
        /// 별다른 동작 없음
      }

      showToast('데이트 플랜 삭제가 완료되었습니다.');
      Get.back();
    } catch (e) {
      showToast('데이트 플랜 삭제에 실패했습니다. 잠시 후 다시 시도해 주세요.');
      return;
    } finally {
      endLoading();
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
