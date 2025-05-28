import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/main.dart';
import 'package:datenote/models/place/place_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:datenote/util/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendPlanEditController extends GetxController {
  /// 유저 컨트롤러
  final userCtrl = Get.find<UserController>();

  /// 데이트 플랜 제목 컨트롤러
  final TextEditingController _titleController = TextEditingController();

  TextEditingController get titleController => _titleController;

  /// 데이트 플랜 본문 컨트롤러
  final TextEditingController _descriptionController = TextEditingController();

  TextEditingController get descriptionController => _descriptionController;

  /// 데이트 플랜 모델
  late RecommendPlanModel recommendPlanModel;

  /// 로딩 상태
  bool isLoadingProgress = false;

  @override
  void onInit() {
    if (Get.arguments is RecommendPlanModel) {
      recommendPlanModel = Get.arguments;

      _titleController.text = recommendPlanModel.title;
      _descriptionController.text = recommendPlanModel.description;
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

  @override
  void onClose() {
    _titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 수정사항 저장 콜백
  ///
  Future<void> onTapModify() async {
    try {
      isLoadingProgress = true;
      update([':loading']);

      await FirebaseFirestore.instance
          .collection(FireStoreCollectionName.recommendDatePlan)
          .doc(recommendPlanModel.id)
          .update(
            recommendPlanModel
                .copyWith(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  modifiedAt: DateTime.now(),
                  /// place 는 이미 반영되어 있음
                ).toJson(),
          );

      /// 수정 여부(bool) result 로 보내기
      Get.back(result: true);
    } catch (e) {
      showToast('데이트 플랜 수정에 실패했습니다. 잠시 후 다시 시도해 주세요.');
      return;
    } finally {
      isLoadingProgress = false;
      update([':loading']);
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 플레이스 제거 콜백
  ///
  Future<void> onRemovePlace(PlaceModel place) async {
    List<PlaceModel> filteredPlaces = recommendPlanModel.places.toList();

    filteredPlaces.remove(place);

    List<PlaceModel> updatePlaces = [];

    /// 인덱스 업데이트
    for (var element in filteredPlaces.indexed) {
      /// freezed 는 불변객체기 때문에 copyWith 사용
      updatePlaces.add(element.$2.copyWith(index: element.$1 + 1));
    }

    recommendPlanModel = recommendPlanModel.copyWith(places: updatePlaces);

    update([':places']);
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 플레이스 추가 콜백
  ///
  Future<void> onAddPlace() async {
    if (recommendPlanModel.places.length >= 10) {
      showToast('플레이스는 10개까지 추가할 수 있습니다.');
      return;
    }

    final PlaceModel? result =
        (await Get.toNamed(Routes.placeSearch, arguments: recommendPlanModel.baseAddress) as PlaceModel?);

    if (result != null) {
      List<PlaceModel> filteredPlaces = recommendPlanModel.places.toList();

      filteredPlaces.add(result);

      List<PlaceModel> updatePlaces = [];

      /// 인덱스 업데이트
      for (var element in filteredPlaces.indexed) {
        /// freezed 는 불변객체기 때문에 copyWith 사용
        updatePlaces.add(element.$2.copyWith(index: element.$1 + 1));
      }

      recommendPlanModel = recommendPlanModel.copyWith(places: updatePlaces);

      update([':places']);
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 뒤로가기 콜백
  ///
  Future<void> onTapBackBtn() async {
    if (await showTwoButtonDialog(
      contents: '데이트 플랜 수정을 취소하시겠습니까?',
      positiveButton: '확인',
      negativeButton: '취소',
      positiveCallBack: () {
        Get.back(result: true);
      },
    )) {
      /// PopScope 때문에 result 를 주지만 실제로 값이 사용되지는 않는다.
      Get.back(result: false);
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 데이트 플랜 재정렬 콜백
  ///
  void onReorderPlace(int oldIndex, int newIndex) {
    List<PlaceModel> filteredPlaces = recommendPlanModel.places.toList();

    PlaceModel place = filteredPlaces.removeAt(oldIndex);
    filteredPlaces.insert(newIndex, place);

    List<PlaceModel> updatePlaces = [];

    /// 인덱스 업데이트
    for (var element in filteredPlaces.indexed) {
      /// freezed 는 불변객체기 때문에 copyWith 사용
      updatePlaces.add(element.$2.copyWith(index: element.$1 + 1));
    }

    recommendPlanModel = recommendPlanModel.copyWith(places: updatePlaces);

    update([':places']);
  }
}
