import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/models/dating_history/dating_history_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/modules/main/main_controller.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/util/mixin/controller_loading_mix.dart';
import 'package:datenote/util/mixin/controller_with_video_player_mix.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:datenote/util/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';

class DatingHistoryDetailController extends GetxController with ControllerLoadingMix, ControllerWithVideoPlayer {
  /// 커뮤니티로 진입했는지 여부
  // final isCommunity = Get.parameters['isCommunity'] == 'true';

  /// 유저 컨트롤러
  final userCtrl = Get.find<UserController>();

  /// 이미지 스크롤을 위한 페이지 컨트롤러
  final pageController = PageController(viewportFraction: 1);

  /// 데이트 기록 모델
  late DatingHistoryModel model;

  /// 데이트 플랜 로딩 상태
  bool isRecommendPlanLoading = true;

  /// 데이트 플랜 상세 기록
  RecommendPlanModel? recommendPlanModel;

  /// 데이터 로딩 상태
  bool isDataLoadingProgress = false;

  /// 좋아요 로딩 상태
  bool favoriteLoadingProgress = false;

  @override
  void onInit() {
    if (Get.arguments is DatingHistoryModel) {
      model = Get.arguments;

      selectRecommendPlanDetail();
    }

    super.onInit();
  }

  @override
  void onReady() {
    if (Get.arguments is! DatingHistoryModel) {
      showToast('데이트 기록 데이터가 유효하지 않습니다.');

      /// init 에 안 하고 ready 에 한 이유는
      /// init 에서 Get.back 할 경우 해당 컨트롤러가 메모리에서 해제되지 않기 때문
      Get.back();
    }
    super.onReady();
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 데이트 기록 수정 콜백
  ///
  Future<void> onTapEditBtn() async {
    /// 비디오 일시 정지
    pauseCurrentVideoPlayer(pageController, model.assets);

    /// else 수정으로 이동
    final bool result =
        ((await Get.toNamed(Routes.datingHistoryEdit, arguments: model, parameters: {
          'isModify': 'true',
        })) as bool?) ?? false;

    if (result) {
      isDataLoadingProgress = true;
      update([':datingHistoryBody']);

      try {
        /// 수정 되었을 경우 데이터 다시 로드하기
        Map<String, dynamic>? datingHistoryModelMap =
        (await FirebaseFirestore.instance
            .collection(FireStoreCollectionName.datingHistory)
            .doc(model.id)
            .get())
            .data();

        if (datingHistoryModelMap != null) {
          model = DatingHistoryModel.fromJson(datingHistoryModelMap);
          selectRecommendPlanDetail();

          /// 메인-캘린더 업데이트
          try {
            final mainCtrl = Get.find<MainController>();
            mainCtrl.updateDatingHistoryData(model.date);
          } catch (e){/// 별다른 동작 없음
            logger.e(e);
          }
        }
      } catch (e) {
        showToast('데이트 기록 조회에 실패했습니다. 잠시 후 다시 시도해 주세요.');
        return;
      } finally {
        isDataLoadingProgress = false;
        update([':datingHistoryBody']);
      }
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 데이트 기록 삭제 콜백
  ///
  Future<void> onTapDeleteBtn() async {
    try {
      if (!await showTwoButtonDialog(
        contents: '데이트 기록을 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        return;
      }

      startLoading();

      await FirebaseFirestore.instance.collection(FireStoreCollectionName.datingHistory).doc(model.id).delete();

      /// 메인-캘린더 업데이트
      try {
        final mainCtrl = Get.find<MainController>();
        mainCtrl.updateDatingHistoryData(model.date);
      } catch (e){/// 별다른 동작 없음
      }

      showToast('데이트 기록 삭제가 완료되었습니다.');
      Get.back();
    } catch (_) {
      showToast('오류가 발생하였습니다. 잠시 후 다시 시도해주세요');
    } finally {
      endLoading();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 데이트 플랜 데이터 상세 정보 조회
  ///
  Future<void> selectRecommendPlanDetail() async {
    Map<String, dynamic>? recommendPlanModelMap =
    (await FirebaseFirestore.instance
        .collection(FireStoreCollectionName.recommendDatePlan)
        .doc(model.recommendPlanId)
        .get())
        .data();

    if (recommendPlanModelMap != null) {
      recommendPlanModel = RecommendPlanModel.fromJson(recommendPlanModelMap);
    }

    isRecommendPlanLoading = false;
    update([':recommendPlan']);
  }

  /// @author 정준형
  /// @since 2025. 5. 26.
  /// @comment 데이트 플랜 상세 페이지로 이동
  ///
  void onTapRecommendPlan() {
    if (recommendPlanModel != null) {
      pauseCurrentVideoPlayer(pageController, model.assets);

      Get.toNamed(Routes.recommendPlanDetail, arguments: recommendPlanModel, parameters: {'isCommunity': 'true'});
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 26.
  /// @comment 커뮤니티 공개 모드 수정 콜백
  ///
  Future<void> toggleCommunityOpen() async {
    try {
      if (!await showTwoButtonDialog(
        contents: '커뮤니티에 ${model.isOpenToCommunity ? '비' : ''}공개 하시겠습니까?',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        return;
      }

      startLoading();

      await FirebaseFirestore.instance.collection(FireStoreCollectionName.datingHistory).doc(model.id).update({
        'isOpenToCommunity': !model.isOpenToCommunity,
      });

      model = model.copyWith(isOpenToCommunity: !model.isOpenToCommunity);
      update([':isCommunityOpen']);
    } catch (_) {
      showToast('오류가 발생하였습니다. 잠시 후 다시 시도해주세요');
    } finally {
      endLoading();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 26.
  /// @comment 댓글 전송
  ///
  void onTapCommentSendBtn() {
    /// TODO 댓글 기능 구현
    showToast('준비중입니다.');
  }

   /// @author 정준형
    /// @since 2025. 5. 26.
    /// @comment 좋아요 클릭 콜백
    ///
  Future<void> onTapFavorite() async {
    final docRef = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.datingHistory)
        .doc(model.id);

    final currentUserId = userCtrl.currentUser.uid;

    try {
      favoriteLoadingProgress = true;
      update([':favorite']);

      late List<String> updatedLikedUserIds;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = (await transaction.get(docRef)).data();

        final likedUserIds = List<String>.from(snapshot?['likesUserId'] ?? []);

        updatedLikedUserIds = likedUserIds.contains(currentUserId)
            ? likedUserIds.where((e) => e != currentUserId).toList()
            : [...likedUserIds, currentUserId];

        transaction.update(docRef, {
          'likesUserId':
          likedUserIds.contains(currentUserId)
              ? FieldValue.arrayRemove([currentUserId])
              : FieldValue.arrayUnion([currentUserId]),
        });
      });
      /// 트랜잭션 안에서 업데이트된 데이터를 로컬에도 반영
      model = model.copyWith(likesUserId: updatedLikedUserIds);
    } catch (e) {
      showToast('좋아요도중 오류가 발생했습니다.');
    } finally {
      favoriteLoadingProgress = false;
      update([':favorite']);
    }
  }
}
