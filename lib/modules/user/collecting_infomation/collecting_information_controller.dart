import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/constant/enum/age_group.dart';
import 'package:datenote/constant/enum/collecting_information_page.dart';
import 'package:datenote/constant/enum/date_style.dart';
import 'package:datenote/constant/enum/gender.dart';
import 'package:datenote/constant/enum/region.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/util/const/fire_store_collection_name.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:datenote/util/widget/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../main.dart';

class CollectingInformationController extends GetxController {
  final userCtrl = Get.find<UserController>();

  /// 수정 모드 여부
  final isModify = Get.parameters['isModify'] == 'true';

  /// 현재 페이지 enum
  final Rx<CollectingInformationPage> collectingInformationPage =
      CollectingInformationPage.gender.obs;

  /// 성별
  Rxn<Gender> gender = Rxn();

  /// 연령대
  Rxn<AgeGroup> ageGroup = Rxn();

  /// 데이트 스타일
  RxList<DateStyle> dateStyleList = <DateStyle>[].obs;

  Rxn<Region> region = Rxn();

  /// 로딩 스핀 위젯 표시 상태
  bool isLoadingProgress = false;

  bool get isDateStyleListSelected => dateStyleList.isNotEmpty;

  @override
  void onInit() {
    /// 수정으로 진입한 경우 첫번째 화면은 제외시킨다.
    if (isModify) {
      /// 초기값 설정
      gender.value = userCtrl.currentUser.gender;
      ageGroup.value = userCtrl.currentUser.ageGroup;
      dateStyleList.value = List<DateStyle>.from(userCtrl.currentUser.dateStyle ?? []);
      region.value = userCtrl.currentUser.region;
    }

    super.onInit();
  }

  /// @author 정준형
  /// @since 2025. 4. 16.
  /// @comment 다음, 완료 버튼 클릭 콜백
  ///
  Future<void> onTapNextBtn() async {
    /// 마지막 페이지일 경우
    if (collectingInformationPage.value ==
        CollectingInformationPage.values.last) {
      isLoadingProgress = true;
      update([':loading']);

      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) return;

      try {
        await FirebaseFirestore.instance.collection(FireStoreCollectionName.users).doc(uid).update({
          'gender' : gender.value?.name,
          'ageGroup': ageGroup.value?.name,
          'dateStyle' : dateStyleList.map((dateStyle) => dateStyle.name).toList(),
          'region': region.value?.name,
        });

        await Get.find<UserController>().loadUser(isOnlyLoad: true);

        Get.back(result: isModify);
      } catch (e) {
        showToast('추가 정보 업데이트 도중 오류가 발생하였습니다 잠시 후 다시 시도해주세요.');
      } finally {
        isLoadingProgress = false;
        update([':loading']);
      }

    } else {
      collectingInformationPage.value =
          CollectingInformationPage
              .values[collectingInformationPage.value.index + 1];
    }
  }

  /// @author 정준형
  /// @since 2025. 4. 16.
  /// @comment 성별 아이템 클릭 콜백
  ///
  void onTapGenderItem(Gender gender) {
    this.gender.value = gender;

    Future.delayed(400.milliseconds, () {
      onTapNextBtn();
    });
  }

  /// @author 정준형
  /// @since 2025. 4. 16.
  /// @comment 연령대 아이템 클릭 콜백
  ///
  void onTapAgeGroupItem(AgeGroup ageGroup) {
    this.ageGroup.value = ageGroup;

    Future.delayed(400.milliseconds, () {
      onTapNextBtn();
    });
  }

  /// @author 정준형
  /// @since 2025. 4. 16.
  /// @comment 선호하는 데이트 스타일 클릭 콜백
  ///
  void onTapDateStyleItem(DateStyle dateStyle) {
    if (dateStyleList.contains(dateStyle)) {
      dateStyleList.remove(dateStyle);
    } else {
      dateStyleList.add(dateStyle);
    }
  }

  /// @author 정준형
  /// @since 2025. 4. 16.
  /// @comment 지역 선택 콜백
  ///
  Future<void> onTapRegionItem(Region region) async {
    this.region.value = region;
  }

  /// @author 정준형
  /// @since 2025. 4. 16.
  /// @comment 건너뛰기 버튼 클릭 콜백
  ///
  Future<void> onTapSkipBtn() async {
    if (await showTwoButtonDialog(
      title: '빠른 시작을 원하시나요?'.tr,
      contents: '지금 스킵하면 해당 단계를 건너뛰고\n홈으로 이동합니다.\n원하시면 나중에 이어서 진행할 수 있어요.'.tr,
      positiveButton: '홈으로 가기'.tr,
      negativeButton: '아니요'.tr,
      positiveCallBack: () {
        Get.back(result: true);
      },
    )) {
      /// PopScope 때문에 result 를 주지만 실제로 값이 사용되지는 않는다.
      Get.back(result: false);
    }
  }

  /// @author 정준형
  /// @since 2025. 4. 16.
  /// @comment 뒤로가기 버튼 클릭 콜백
  ///
  void onTapBackBtn() {
    if (collectingInformationPage.value == CollectingInformationPage.gender) {
      onTapSkipBtn();
      return;
    }

    collectingInformationPage.value =
        CollectingInformationPage.values[collectingInformationPage.value.index -
            1];
  }

  /// @author 정준형
  /// @since 10/8/24
  /// @comment 수정시 뒤로가기 버튼 클릭 콜백
  ///
  Future<void> onTapModifyBackBtn() async {
    if (await showTwoButtonDialog(
      contents: '추가 정보 수정을 취소하시겠어요?'.tr,
      positiveButton: '네'.tr,
      negativeButton: '아니요'.tr,
      positiveCallBack: () {
        Get.back(result: true);
      },
    )) {
      Get.back(result: false);
    }
  }
}
