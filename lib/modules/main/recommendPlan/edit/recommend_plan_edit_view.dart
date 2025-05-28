import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:datenote/modules/main/recommendPlan/edit/recommend_plan_edit_controller.dart';
import 'package:datenote/models/place/place_model.dart';
import 'package:intl/intl.dart';
import 'package:reorderables/reorderables.dart';

class RecommendPlanEditView extends StatefulWidget {
  const RecommendPlanEditView({super.key});

  @override
  State<RecommendPlanEditView> createState() => _RecommendPlanEditViewState();
}

class _RecommendPlanEditViewState extends State<RecommendPlanEditView> {
  final editCtrl = Get.put(RecommendPlanEditController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('데이트 플랜 수정', style: Get.textTheme.titleMedium),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        leading: buildBackBtn(editCtrl.onTapBackBtn),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Builder(
            builder: (context) {
              if (Platform.isAndroid) {
                return PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) {
                    if (result == null) {
                      editCtrl.onTapBackBtn();
                    }
                  },
                  child: _buildBodyContent(),
                );
              } else {
                return WillPopScope(
                  onWillPop: () {
                    /// true 로 해도 의미 없지만 명시적으로 false로 선언
                    return Future.value(false);
                  },
                  child: _buildBodyContent(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment body 컨텐츠 영역
  ///
  Widget _buildBodyContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Stack(
        children: [
          ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4, bottom: 16),
                child: TextField(
                  maxLength: 100,
                  controller: editCtrl.titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: '제목',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: TextField(
                  controller: editCtrl.descriptionController,
                  textInputAction: TextInputAction.done,
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: '플랜 설명',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              /// 날짜
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '📅 데이트 날짜 :',
                        style: Get.textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(editCtrl.recommendPlanModel.date),
                      style: Get.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                alignment: Alignment.centerLeft,
                child: Text('📍 기준 장소', style: Get.textTheme.titleMedium),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withAlpha(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(editCtrl.recommendPlanModel.baseAddress.address, style: Get.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(editCtrl.recommendPlanModel.baseAddress.detailAddress, style: Get.textTheme.bodySmall),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 8),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📒 데이트 플랜', style: Get.textTheme.titleMedium),
                    Text('드래그하여 순서를 변경할 수 있어요 ↕️', style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              _buildPlaces(),
              _buildAddCardButton(),
              const SizedBox(height: 68),
            ],
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: Get.width - 40,
              height: 48,
              child: ElevatedButton(
                onPressed: editCtrl.onTapModify,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text('저장하기', style: Get.textTheme.titleMedium?.copyWith(color: Colors.white)),
              ),
            ),
          ),
          GetBuilder<RecommendPlanEditController>(
            id: ':loading',
            builder: (ctrl) {
              if (!ctrl.isLoadingProgress) {
                return const SizedBox();
              } else {
                return Center(child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0));
              }
            },
          ),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 데이트 플랜 장소 목록 위젯
  ///
  Widget _buildPlaces() {
    return GetBuilder<RecommendPlanEditController>(
      id: ':places',
      builder: (context) {
        /// 최상단에 ListView 가 있기 때문에 Reorder 도중 아래로 스크롤은 되어지지 않는다.
        /// 하고싶다면, 최상단 ListView 를 CustomScrollView 로 변경하고 scrollController 로 수동 제어하자.
        return ReorderableColumn(
          onReorder: (int oldIndex, int newIndex) {
            editCtrl.onReorderPlace(oldIndex, newIndex);
          },
          children: [...editCtrl.recommendPlanModel.places.map((place) => _buildPlaceCard(place))],
          buildDraggableFeedback: (context, constraints, child) {
            return Container(constraints: constraints, child: child);
          },
        );
      },
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 데이트 플랜 장소 카드 위젯
  ///
  Widget _buildPlaceCard(PlaceModel place) {
    return ReorderableWidget(
      key: ValueKey(place.id),
      reorderable: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey.withAlpha(100)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${place.index}. ${place.place_name}', style: Get.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(place.address_name, style: Get.textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(
              onPressed: () => editCtrl.onRemovePlace(place),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 데이트 플랜 장소 추가하기 버튼 위젯
  ///
  Widget _buildAddCardButton() {
    return InkWell(
      onTap: editCtrl.onAddPlace,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey.withAlpha(100)),
        ),
        child: const Center(child: Icon(Icons.add_rounded, size: 32, color: Colors.grey)),
      ),
    );
  }
}
