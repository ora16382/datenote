import 'package:datenote/constant/enum/preferred_date_type.dart';
import 'package:datenote/constant/enum/recommend_plan_step_type.dart';
import 'package:datenote/modules/main/recommendPlan/recommend_plan_controller.dart';
import 'package:datenote/modules/user/address/search/address_search_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_loading_indicator_widget.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:datenote/util/widget/date_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class RecommendPlanView extends StatefulWidget {
  const RecommendPlanView({super.key});

  @override
  State<RecommendPlanView> createState() => _RecommendPlanViewState();
}

class _RecommendPlanViewState extends State<RecommendPlanView> {
  final controller = Get.put(RecommendPlanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        scrolledUnderElevation: 0,
        title: Text('데이트 플랜 추천', style: Get.textTheme.titleSmall),

        /// 기본 뒤로가기 없애기 위해 추가
        leading: buildBackBtn(controller.onTapBackBtn),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Stack(
            children: [
              Column(
                children: [
                  _buildStepIndicator(),
                  _buildStepBody(),
                  _buildBottomNextBtn(),
                ],
              ),
              ..._buildProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return GetBuilder<RecommendPlanController>(
      id: ':progressIndicator',
      builder: (_) {
        return StepProgressIndicator(
          totalSteps: RecommendPlanStepType.values.length,
          currentStep: controller.recommendPlanStepType.value.index + 1,
          // 지금 2단계 진행 중
          selectedColor: AppColors.primary,
          unselectedColor: AppColors.grey,
          size: 12,
          roundedEdges: Radius.circular(16),
          padding: 4,
        );
      },
    );
  }

  Widget _buildStepBody() {
    return GetBuilder<RecommendPlanController>(
      id: ':stepBody',
      builder: (_) {
        switch (controller.recommendPlanStepType.value) {
          case RecommendPlanStepType.date:
            return _buildDateStepBody();
          case RecommendPlanStepType.address:
            return _buildAddressStepBody();
          case RecommendPlanStepType.preferredDateType:
            return _buildPreferredDateTypeStepBody();
        }
      },
    );
  }

  Widget _buildDateStepBody() {
    return Expanded(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 48, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Text('언제 데이트하시나요?', style: Get.textTheme.titleLarge),
                ),
                Text(
                  '*표시된 날씨는 12~15시 기준입니다.',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<RecommendPlanController>(
            id: ':dateSelector',
            builder: (_) {
              if (controller.isWeatherLoading) {
                return Container(
                  alignment: Alignment.center,
                  height: Get.height / 2,
                  child: SpinKitFadingCircle(
                    color: AppColors.primary,
                    size: 50.0,
                  ),
                );
              } else {
                return DateSelector(
                  initialDate: controller.selectedDate.value,
                  onDateSelected: controller.onSelectDate,
                  length: 6,
                  weatherData: controller.weatherData,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStepBody() {
    final controller = Get.put(
      AddressSearchController(),
      tag: ':recommend_plan',
    );

    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 48, bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('데이트할 장소를 작성해주세요', style: Get.textTheme.titleLarge),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: SizedBox(
                                height: 52,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    // 주소록
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: ElevatedButton.icon(
                                        onPressed:
                                            controller
                                                .loadAddressFromAddressBook,
                                        icon: const Icon(
                                          Icons.menu_book_rounded,
                                          size: 24,
                                        ),
                                        label: Text(
                                          '주소록',
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                color: AppColors.onPrimary,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: ElevatedButton.icon(
                                        onPressed:
                                            controller.fetchCurrentLocation,
                                        icon: const Icon(
                                          Icons.my_location,
                                          size: 24,
                                        ),
                                        label: Text(
                                          '현재 위치',
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                color: AppColors.onPrimary,
                                              ),
                                        ),
                                      ),
                                    ),
                                    // 🏷️ Daum 주소 검색 버튼
                                    ElevatedButton.icon(
                                      onPressed: controller.openDaumPost,
                                      icon: const Icon(Icons.search, size: 24),
                                      label: Text(
                                        '주소 검색',
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                              color: AppColors.onPrimary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // ✍️ 텍스트 필드로 직접 수정
                            TextField(
                              controller: controller.addressController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.grey),
                                ),
                                floatingLabelStyle: Get.textTheme.titleMedium
                                    ?.copyWith(color: AppColors.grey),
                                labelStyle: Get.textTheme.titleMedium?.copyWith(
                                  color: AppColors.grey,
                                ),
                                labelText: '주소',
                              ),
                              maxLines: 1,
                              readOnly: true,
                            ),
                            // ✍️ 나머지 주소 입력
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: TextField(
                                focusNode: controller.detailAddressFocusNode,
                                controller: controller.detailAddressController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  floatingLabelStyle: Get.textTheme.titleMedium
                                      ?.copyWith(color: AppColors.secondary),
                                  labelStyle: Get.textTheme.titleMedium
                                      ?.copyWith(color: AppColors.secondary),
                                  labelText: '나머지 주소 (건물명, 동호수 등)',
                                ),
                                onEditingComplete:
                                    controller.onEditingCompleteAddressDetail,
                              ),
                            ),
                            Obx(() {
                              return CheckboxListTile(
                                title: Text('주소록에 저장하기'),
                                value: controller.isSaveAddress.value,
                                onChanged: (v) {
                                  controller.isSaveAddress.value = v!;
                                },
                                contentPadding: EdgeInsets.zero,
                                side: BorderSide(color: AppColors.secondary),
                                // visualDensity: VisualDensity.compact,
                                activeColor: AppColors.primary,
                                checkColor: AppColors.onPrimary,
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CommonLoadingIndicator<AddressSearchController>(tag: ':recommend_plan',),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferredDateTypeStepBody() {
    return Expanded(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 48, bottom: 24),
            child: Text('어떤 데이트를 원하시나요?', style: Get.textTheme.titleLarge),
          ),
          Obx(() {
            final selected = controller.selectedPreferredDateType.value;
            return Column(
              children:
                  PreferredDateType.values.map((type) {
                    final isSelected = type == selected;
                    return GestureDetector(
                      onTap: () => controller.onSelectPreferredDateType(type),
                      child: Container(
                        height: 72,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primary.withAlpha(25)
                                  : AppColors.grey.withAlpha(25),
                          border: Border.all(
                            color:
                                isSelected ? AppColors.primary : AppColors.grey,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          type.label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.secondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomNextBtn({String text = '다음'}) {
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
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildProgress() {
    return [
      GetBuilder<RecommendPlanController>(
        id: ':addressSaveLoading',
        builder: (ctrl) {
          if (!ctrl.isAddressSaveLoadingProgress) {
            return const SizedBox();
          } else {
            return Center(
              child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0),
            );
          }
        },
      ),
      GetBuilder<RecommendPlanController>(
        id: ':openAIAPILoading',
        builder: (ctrl) {
          if (!ctrl.isOpenAIAPILoadingProgress) {
            return const SizedBox();
          } else {
            return Center(
              child: SpinKitFadingCircle(
                color: AppColors.primary,
                size: 50.0,
              ),
            );
          }
        },
      ),
      GetBuilder<RecommendPlanController>(
        id: ':kakaoLocalAPILoading',
        builder: (ctrl) {
          if (!ctrl.isKakaoLocalAPILoadingProgress) {
            return const SizedBox();
          } else {
            return Center(
              child: SpinKitFadingCircle(
                color: AppColors.primary,
                size: 50.0,
              ),
            );
          }
        },
      )
    ];
  }
}
