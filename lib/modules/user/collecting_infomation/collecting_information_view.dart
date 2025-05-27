// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:datenote/constant/enum/age_group.dart';
import 'package:datenote/constant/enum/collecting_information_page.dart';
import 'package:datenote/constant/enum/date_style.dart';
import 'package:datenote/constant/enum/gender.dart';
import 'package:datenote/constant/enum/region.dart';
import 'package:datenote/modules/user/collecting_infomation/collecting_information_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CollectingInformationView extends StatefulWidget {
  const CollectingInformationView({super.key});

  @override
  State<CollectingInformationView> createState() =>
      _CollectingInformationViewState();
}

class _CollectingInformationViewState extends State<CollectingInformationView> {
  final controller = Get.put(CollectingInformationController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        centerTitle: true,
        title: Text(controller.isModify ? '수정하기' : '추가 정보', style: Get.textTheme.titleMedium),
        actions: [
          GetBuilder<CollectingInformationController>(
            builder: (_) {
              if (controller.isModify) {
                return const SizedBox();
              } else {
                return TextButton(
                  onPressed: controller.onTapSkipBtn,
                  child: Text(
                    '건너뛰기',
                    textAlign: TextAlign.right,
                    style: Get.textTheme.titleSmall,
                  ),
                );
              }
            },
          ),
        ],

        /// 기본 뒤로가기 없애기 위해 추가
        leading: _buildLeadingWidget(),
      ),
      resizeToAvoidBottomInset: true,
      body: _buildBody(context),
    );
  }

  Widget _buildLeadingWidget() {
    return Obx(() {
      return controller.collectingInformationPage.value.getLeadingWidget(
        controller.isModify,
      );
    });
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Builder(
        builder: (context) {
          if (Platform.isAndroid) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (result == null) {
                  if (controller.isModify && controller.collectingInformationPage.value == CollectingInformationPage.values.first) {
                    controller.onTapModifyBackBtn();
                  } else {
                    controller.onTapBackBtn();
                  }
                }
              },
              child: _buildBodyContents(),
            );
          } else {
            return WillPopScope(
              onWillPop: () {
                /// true 로 해도 의미 없지만 명시적으로 false로 선언
                return Future.value(false);
              },
              child: _buildBodyContents(),
            );
          }
        },
      ),
    );
  }

  Widget _buildBodyContents() {
    return Stack(
      children: [
        Column(
          children: [
            Obx(() {
              return Container(
                margin: const EdgeInsets.only(top: 10),
                child: LinearPercentIndicator(
                  animation: true,
                  animationDuration: 300,
                  lineHeight: 4.0,
                  animateFromLastPercent: true,
                  percent:
                  controller.collectingInformationPage.value.index /
                      (CollectingInformationPage.values.length - 1),
                  padding: EdgeInsets.zero,
                  progressColor: AppColors.primary,
                  backgroundColor: AppColors.disabled,
                  barRadius: const Radius.circular(2.0),
                ),
              );
            }),
            Obx(() {
              switch (controller.collectingInformationPage.value) {
                case CollectingInformationPage.gender:
                  return _buildGenderPage(context);
                case CollectingInformationPage.ageGroup:
                  return _buildAgeGroupPage(context);
                case CollectingInformationPage.dateStyle:
                  return _buildDateStylePage(context);
                case CollectingInformationPage.region:
                  return _buildRegionPage(context);
              }
            }),
          ],
        ),
        GetBuilder<CollectingInformationController>(
          id: ':loading',
          builder: (ctrl) {
            if (!ctrl.isLoadingProgress) {
              return const SizedBox();
            } else {
              return Center(
                child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildGenderPage(BuildContext context) {
    Widget buildGenderItemWidget(Gender genderEnum) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            controller.onTapGenderItem(genderEnum);
          },
          child: Obx(() {
            return AnimatedContainer(
              duration: 300.milliseconds,
              margin:
                  genderEnum == Gender.male
                      ? const EdgeInsets.only(right: 16)
                      : null,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: ShapeDecoration(
                color:
                    controller.gender.value == genderEnum
                        ? AppColors.primarySoft
                        : AppColors.surface,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color:
                        controller.gender.value == genderEnum
                            ? AppColors.primary
                            : AppColors.disabled,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0X1415224D),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 32),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(genderEnum.getIcon),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(genderEnum.label, style: Get.textTheme.bodyLarge),
                ],
              ),
            );
          }),
        ),
      );
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 52.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('성별은\n어떻게 되시나요?', style: Get.textTheme.titleLarge),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Text(
                            '성별에 따라 결과가 달라질 수 있어요!',
                            style: Get.textTheme.titleSmall?.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(
                      Gender.values.length,
                      (index) => buildGenderItemWidget(Gender.values[index]),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isModify) buildBottomNextBtn(),
          ],
        ),
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 4. 16.
  /// @comment 연령대 설정 화면
  ///
  Widget _buildAgeGroupPage(BuildContext context) {
    Widget buildAgeGroupItemWidget(AgeGroup ageGroup) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.onTapAgeGroupItem(ageGroup);
        },
        child: Obx(() {
          return AnimatedContainer(
            duration: 300.milliseconds,
            height: 68,
            margin:
                ageGroup.index == AgeGroup.values.length - 1
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color:
                  controller.ageGroup.value == ageGroup
                      ? AppColors.primarySoft
                      : AppColors.surface,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color:
                      controller.ageGroup.value == ageGroup
                          ? AppColors.primary
                          : AppColors.disabled,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0X1415224D),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  ageGroup.label,
                  maxLines: 2,
                  style: Get.textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }),
      );
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 52, bottom: 22),
                    child: Text(
                      '연령대가 어떻게 되나요?',
                      style: Get.textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: List.generate(
                        AgeGroup.values.length,
                        (index) =>
                            buildAgeGroupItemWidget(AgeGroup.values[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isModify) buildBottomNextBtn(),
          ],
        ),
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 4. 16.
  /// @comment 데이트 스타일 설정 화면
  ///
  Widget _buildDateStylePage(BuildContext context) {
    Widget buildDateStyleItemWidget(DateStyle dateStyle) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.onTapDateStyleItem(dateStyle);
        },
        child: Obx(() {
          return AnimatedContainer(
            duration: 300.milliseconds,
            height: 68,
            margin:
                dateStyle.index == DateStyle.values.length - 1
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color:
                  controller.dateStyleList.contains(dateStyle)
                      ? AppColors.primarySoft
                      : AppColors.surface,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color:
                      controller.dateStyleList.contains(dateStyle)
                          ? AppColors.primary
                          : AppColors.disabled,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0X1415224D),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text(dateStyle.label, style: Get.textTheme.bodyLarge)],
            ),
          );
        }),
      );
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 52, bottom: 22),
                    child: Text(
                      '선호하는 데이트 스타일이 있나요? (복수)',
                      style: Get.textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: List.generate(
                        DateStyle.values.length,
                        (index) =>
                            buildDateStyleItemWidget(DateStyle.values[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildBottomNextBtn(),
          ],
        ),
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 4. 16.
  /// @comment 지역 설정 화면
  ///
  Widget _buildRegionPage(BuildContext context) {
    Widget buildRegionItemWidget(Region region) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.onTapRegionItem(region);
        },
        child: Obx(() {
          return AnimatedContainer(
            duration: 300.milliseconds,
            // region.index == Region.values.length - 1
            //     ? EdgeInsets.zero
            //     : const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color:
              controller.region.value == region
                  ? AppColors.primarySoft
                  : AppColors.surface,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color:
                  controller.region.value == region
                      ? AppColors.primary
                      : AppColors.disabled,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0X1415224D),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  region.label,
                  style: Get.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      );
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 52, bottom: 22),
                    child: Text(
                      '사는 지역이 어디인가요?',
                      style: Get.textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: GridView.count(
                      shrinkWrap: true, // 부모 높이 제약 허용
                      physics: const NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
                      crossAxisCount: 4, // 한 줄에 3개
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: List.generate(
                        Region.values.length,
                            (index) => buildRegionItemWidget(Region.values[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildBottomNextBtn(text: '완료'),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNextBtn({String text = '다음'}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: controller.onTapNextBtn,
      child: SafeArea(
        child: AnimatedContainer(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 16),
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          duration: 300.milliseconds,
          child: Text(
            text,
            style: Get.textTheme.titleMedium?.copyWith(color: AppColors.onPrimary),
          ),
        ),
      ),
    );
  }
}
