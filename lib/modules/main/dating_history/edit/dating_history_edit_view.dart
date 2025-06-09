// ignore_for_file: invalid_annotation_target

import 'dart:io';

import 'package:datenote/constant/enum/assets_type.dart';
import 'package:datenote/constant/enum/mood_type.dart';
import 'package:datenote/modules/main/dating_history/edit/dating_history_edit_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_loading_indicator_widget.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reorderables/reorderables.dart';

class DatingHistoryEditView extends StatefulWidget {
  const DatingHistoryEditView({super.key});

  @override
  State<DatingHistoryEditView> createState() => _DatingHistoryEditViewState();
}

class _DatingHistoryEditViewState extends State<DatingHistoryEditView> {
  final editCtrl = Get.put(DatingHistoryEditController());

  final List<File> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('데이트 기록', style: Get.textTheme.titleMedium),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        leading: buildBackBtn(() => editCtrl.onTapBackBtn()),
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
  /// @since 2025. 5. 21.
  /// @comment body 컨텐츠 영역
  ///
  Widget _buildBodyContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Stack(
        children: [
          ListView(
            children: [
              _buildDescriptionField(),
              _buildDatePicker(),
              _buildMoodSelector(),
              _buildTagsInput(),
              _buildTagChips(),
              _buildMediaUploadArea(),
              _buildRecommendPlanInfo(),
              _buildOpenToCommunity(),
            ],
          ),
          _buildSaveButton(),
          CommonLoadingIndicator<DatingHistoryEditController>(),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 본문 위젯
  ///
  Widget _buildDescriptionField() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 16),
      child: TextField(
        focusNode: editCtrl.descriptionFocusNode,
        controller: editCtrl.descriptionController,
        maxLength: 1000,
        maxLines: 8,
        decoration: InputDecoration(
          hintText: '데이트가 어땠나요? 기록으로 남겨보세요.',
          hintStyle: Get.textTheme.titleMedium?.copyWith(color: AppColors.grey),
          floatingLabelStyle: Get.textTheme.titleMedium?.copyWith(color: AppColors.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 0.5, color: AppColors.secondary),
          ),
        ),
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 날짜 선택 위젯
  ///
  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 데이트 날짜 선택 위젯
  ///
  Widget _buildDatePicker() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📅 데이트 날짜 선택', style: Get.textTheme.titleMedium),
          const SizedBox(height: 8),
          Obx(() {
            final dateText = DateFormat('yyyy년 MM월 dd일').format(editCtrl.selectedDate.value);
            return GestureDetector(
              onTap: editCtrl.onTapDatePicker,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Text(dateText, style: Get.textTheme.bodyMedium),
                    const Spacer(),
                    const Icon(Icons.edit_calendar, color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 기분 선택 위젯
  ///
  Widget _buildMoodSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Text('😊 오늘 데이트 기분은 어땠나요?', style: Get.textTheme.titleMedium),
          ),
          Obx(() {
            return Wrap(
              spacing: 12,
              children:
                  MoodType.values.map((mood) {
                    final isSelected = editCtrl.selectedMood.value == mood;
                    return ChoiceChip(
                      label: Text(mood.label),
                      selected: isSelected,
                      onSelected: (value) {
                        editCtrl.onSelectedMood(mood);
                      },
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.secondary, width: 0.5),
                      backgroundColor: AppColors.background,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.secondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 태그 입력 위젯
  ///
  Widget _buildTagsInput() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🏷️ 태그 추가', style: Get.textTheme.titleMedium),
              Text('스페이스바를 이용하여 추가할 수 있습니다.', style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: editCtrl.tagController,
            onChanged: editCtrl.onChangedTagInput,
            onSubmitted: (value) {
              editCtrl.onChangedTagInput(value, isOnSubmitted: true);
            },
            decoration: InputDecoration(
              hintText: '예: 카페, 비오는날',
              hintStyle: Get.textTheme.titleMedium?.copyWith(color: AppColors.grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              floatingLabelStyle: Get.textTheme.titleMedium?.copyWith(color: AppColors.primary),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(width: 0.5, color: AppColors.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 태그 칩 위젯
  ///
  Widget _buildTagChips() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GetBuilder<DatingHistoryEditController>(
        id: ':tagChips',
        builder: (_) {
          return Wrap(
            spacing: 8,
            children:
                editCtrl.tags.map((tag) {
                  return Chip(
                    label: Text('#$tag'),
                    deleteIcon: const Icon(Icons.close, size: 16, color: AppColors.secondary),
                    onDeleted: () {
                      editCtrl.onDeleteTagChip(tag);
                    },
                    backgroundColor: AppColors.primarySoft,
                    side: BorderSide(color: AppColors.primary, width: 0.8),
                    labelStyle: Get.textTheme.titleSmall?.copyWith(color: AppColors.secondary),
                  );
                }).toList(),
          );
        },
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 미디어 업로드 영역
  ///
  Widget _buildMediaUploadArea() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Text('📷 사진/영상 업로드', style: Get.textTheme.titleMedium),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: editCtrl.onTapAddPhoto,
                  icon: const Icon(Icons.photo),
                  label: const Text('사진 추가'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: editCtrl.onTapAddVideo,
                  icon: const Icon(Icons.videocam),
                  label: const Text('영상 추가'),
                ),
              ],
            ),
          ),
          GetBuilder<DatingHistoryEditController>(
            id: ':assetFileList',
            builder: (context) {
              return Offstage(
                offstage: editCtrl.assetList.isEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '*이미지는 클릭하여 편집할 수 있어요.',
                            style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                          ),
                          Text(
                            '*첨부파일을 길게 터치하여 순서를 변경할 수 있어요.',
                            style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                    ReorderableWrap(
                      needsLongPressDraggable: true,
                      onReorder: (int oldIndex, int newIndex) {
                        editCtrl.onReorderMedia(oldIndex, newIndex);
                      },
                      children: [
                        ...editCtrl.assetList.map((asset) {
                          return Stack(
                            key: ValueKey(asset.id),
                            children: [
                              GestureDetector(
                                onTap: () {
                                  editCtrl.onTapMedia(asset);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: GetBuilder<DatingHistoryEditController>(
                                    id: ':assetPreview:${asset.id}',
                                    builder: (context) {
                                      return ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                        child: Builder(
                                          builder: (context) {
                                            /// 이미 추가된 파일인 경우
                                            if(asset.url != null) {
                                              return buildNetworkImage(
                                                imagePath: asset.type == AssetType.image ? asset.url ?? '' : asset.thumbnailUrl ?? '',
                                                width: 90,
                                                height: 90,
                                              );
                                            } else {
                                              /// 새롭게 추가한 파일인 경우
                                              return buildFileImage(
                                                file:
                                                editCtrl.assetFileMap[asset.id]?[asset.type == AssetType.image ? 0 : 1] ??
                                                    XFile(''),
                                                width: 90,
                                                height: 90,
                                              );
                                            }
                                          }
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    editCtrl.onTapDeleteMedia(asset);
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.secondary),
                                    child: const Center(child: Icon(Icons.clear, color: Colors.white, size: 12)),
                                  ),
                                ),
                              ),
                              if (asset.type == AssetType.video)
                                const Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Icon(Icons.video_file_rounded, color: AppColors.primary, size: 16),
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment. 관련된 데이트 플랜 위젯
  ///
  Widget _buildRecommendPlanInfo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Text('🗂 관련된 데이트 플랜 (선택 사항)', style: Get.textTheme.titleMedium),
          ),
          Obx(() {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    editCtrl.selectedRecommendPlan.value == null
                        ? Colors.grey.withAlpha(20)
                        : AppColors.primary.withAlpha(10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      editCtrl.selectedRecommendPlan.value == null
                          ? Colors.grey.withAlpha(100)
                          : AppColors.primary.withAlpha(40),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          editCtrl.selectedRecommendPlan.value == null
                              ? '연동된 추천 플랜이 없습니다.'
                              : editCtrl.selectedRecommendPlan.value!.title,
                          style:
                              editCtrl.selectedRecommendPlan.value == null
                                  ? Get.textTheme.bodyMedium?.copyWith(color: Colors.grey)
                                  : Get.textTheme.bodyMedium,
                        ),
                        if (editCtrl.selectedRecommendPlan.value != null)
                          Text(
                            '${editCtrl.selectedRecommendPlan.value!.baseAddress.addressName.isNotEmpty ? '${editCtrl.selectedRecommendPlan.value!.baseAddress.addressName} · ' : ''}${editCtrl.selectedRecommendPlan.value!.baseAddress.address}',
                            style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (editCtrl.selectedRecommendPlan.value != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                          tooltip: '삭제',
                          onPressed: editCtrl.onTapRecommendPlanDelete,
                        ),
                      TextButton(
                        onPressed: editCtrl.onTapRecommendPlanEdit,
                        child: Text(editCtrl.selectedRecommendPlan.value == null ? '선택' : '변경'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 저장 버튼 위젯
  ///
  Widget _buildSaveButton() {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: Get.width - 40,
        height: 48,
        child: ElevatedButton(
          onPressed: editCtrl.isModify ? editCtrl.onTapModify : editCtrl.onTapSave,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text(
            '${editCtrl.isModify ? '수정' : '저장'}하기',
            style: Get.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 커뮤니티 공개 여부 체크박스
  ///
  Widget _buildOpenToCommunity() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.only(bottom: 72),
        child: CheckboxListTile(
          title: Text('커뮤니티에 공개', style: Get.textTheme.titleMedium),
          value: editCtrl.isOpenToCommunity.value,
          onChanged: (v) {
            editCtrl.onTapOpenToCommunity(v);
          },
          contentPadding: EdgeInsets.zero,
          side: BorderSide(color: AppColors.secondary),
          activeColor: AppColors.primary,
          checkColor: AppColors.onPrimary,
        ),
      );
    });
  }
}
