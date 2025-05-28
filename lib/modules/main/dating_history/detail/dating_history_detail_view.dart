import 'package:datenote/constant/enum/assets_type.dart';
import 'package:datenote/models/dating_history/dating_history_model.dart';
import 'package:datenote/modules/main/dating_history/detail/dating_history_detail_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_loading_indicator_widget.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:datenote/util/widget/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DatingHistoryDetailView extends StatefulWidget {
  const DatingHistoryDetailView({super.key});

  @override
  State<DatingHistoryDetailView> createState() => _DatingHistoryDetailViewState();
}

class _DatingHistoryDetailViewState extends State<DatingHistoryDetailView> {
  final datingCtrl = Get.put(DatingHistoryDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('데이트 기록', style: Get.textTheme.titleMedium),
        centerTitle: true,
        leading: buildBackBtn(() => Get.back()),
        actions: [
          GetBuilder<DatingHistoryDetailController>(
            id: ':isCommunityOpen',
            builder: (_) {
              if (datingCtrl.model.userId != datingCtrl.userCtrl.currentUser.uid) {
                return SizedBox.shrink();
              } else {
                return IconButton(
                  icon: Icon(
                    datingCtrl.model.isOpenToCommunity ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    color: datingCtrl.model.isOpenToCommunity ? AppColors.primary : Colors.grey,
                  ),
                  tooltip: datingCtrl.model.isOpenToCommunity ? '커뮤니티에 공개 중' : '비공개 상태',
                  onPressed: () {
                    datingCtrl.toggleCommunityOpen(); // 공개 상태 토글 함수
                  },
                );
              }
            },
          ),
          Builder(
            builder: (context) {
              if (datingCtrl.model.userId != datingCtrl.userCtrl.currentUser.uid) {
                return SizedBox.shrink();
              } else {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      datingCtrl.onTapEditBtn();
                    } else {
                      datingCtrl.onTapDeleteBtn();
                    }
                  },
                  color: Colors.white,
                  // menuPadding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 60),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem<String>(value: 'edit', child: Text('수정', style: Get.theme.textTheme.titleSmall)),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('삭제', style: Get.theme.textTheme.titleSmall),
                        ),
                      ],
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: GetBuilder<DatingHistoryDetailController>(
                  id: ':datingHistoryBody',
                  builder: (context) {
                    if (datingCtrl.isDataLoadingProgress) {
                      return Center(child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0));
                    } else {
                      return ListView(
                        children: [
                          /// 날짜
                          Container(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  child: const Text('📅', style: TextStyle(fontSize: 16)),
                                ),
                                Text(
                                  DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(datingCtrl.model.date),
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary.withAlpha(192),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Carousel
                          if (datingCtrl.model.assets.isNotEmpty)
                            Column(
                              children: [
                                SizedBox(
                                  height: 280,
                                  child: PageView.builder(
                                    controller: datingCtrl.pageController,
                                    itemCount: datingCtrl.model.assets.length,
                                    itemBuilder: (context, index) {
                                      final asset = datingCtrl.model.assets[index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            alignment: Alignment.center,
                                            children: [
                                              asset.type == AssetType.video
                                                  ? VideoPlayerWidget(assetModel: asset, controller: datingCtrl,)
                                                  : buildNetworkImage(
                                                    imagePath:
                                                        asset.type == AssetType.video
                                                            ? asset.thumbnailUrl ?? ''
                                                            : asset.url ?? '',
                                                    width: double.infinity,
                                                  ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SmoothPageIndicator(
                                  controller: datingCtrl.pageController,
                                  count: datingCtrl.model.assets.length,
                                  effect: const WormEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    activeDotColor: AppColors.primary,
                                    dotColor: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),

                          /// 설명
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(datingCtrl.model.description, style: Get.textTheme.bodyMedium),
                          ),

                          /// 기분
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '오늘의 기분: ${datingCtrl.model.mood.label}',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                // color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          /// 태그
                          if (datingCtrl.model.tags.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children:
                                    datingCtrl.model.tags.map((tag) {
                                      return Text(
                                        '#$tag',
                                        style: Get.textTheme.bodySmall?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),

                          /// 추천 플랜 영역
                          if (datingCtrl.model.recommendPlanId != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GetBuilder<DatingHistoryDetailController>(
                                id: ':recommendPlan',
                                builder: (context) {
                                  return GestureDetector(
                                    onTap: datingCtrl.onTapRecommendPlan,
                                    child: Container(
                                      width: double.infinity,
                                      height: 72,
                                      margin: const EdgeInsets.only(top: 16),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withAlpha(10),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.primary.withAlpha(40)),
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          if (datingCtrl.isRecommendPlanLoading) {
                                            return Center(
                                              child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0),
                                            );
                                          } else {
                                            if (datingCtrl.recommendPlanModel == null) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [Text('삭제된 데이트 플랜', style: Get.textTheme.bodyMedium)],
                                              );
                                            } else {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          datingCtrl.recommendPlanModel!.title,
                                                          style: Get.textTheme.bodyMedium,
                                                        ),
                                                        Text(
                                                          '${datingCtrl.recommendPlanModel!.baseAddress.addressName.isNotEmpty ? '${datingCtrl.recommendPlanModel!.baseAddress.addressName} · ' : ''}${datingCtrl.recommendPlanModel!.baseAddress.address}',
                                                          style: Get.textTheme.bodySmall?.copyWith(
                                                            color: AppColors.grey,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(4.0),
                                                    child: Icon(
                                                      Icons.open_in_new_rounded,
                                                      size: 20,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          /// 생성일 & 수정일
                          Container(
                            margin: const EdgeInsets.only(top: 24, bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// 좋아요 영역
                                GetBuilder<DatingHistoryDetailController>(
                                  id: ':favorite',
                                  builder: (context) {
                                    if (datingCtrl.favoriteLoadingProgress) {
                                      return SpinKitFadingCircle(color: AppColors.primary, size: 20.0);
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          datingCtrl.onTapFavorite();
                                        },
                                        behavior: HitTestBehavior.translucent,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(right: 4),
                                              child: Icon(
                                                Icons.favorite,
                                                color:
                                                    datingCtrl.model.likesUserId.contains(
                                                          datingCtrl.userCtrl.currentUser.uid,
                                                        )
                                                        ? Colors.redAccent
                                                        : AppColors.grey,
                                                size: 20,
                                              ),
                                            ),
                                            Text(
                                              '${datingCtrl.model.likesUserId.length}',
                                              style: Get.textTheme.bodySmall?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  '생성일: ${DateFormat('yyyy.MM.dd HH:mm').format(datingCtrl.model.createdAt)}',
                                  style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),

            /// 하단 고정 입력창
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
                  ],
                ),
                child: Row(
                  children: [
                    /// 텍스트 입력 박스
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: TextField(
                          enabled: datingCtrl.model.isOpenToCommunity,
                          decoration: InputDecoration(
                            hintText: datingCtrl.model.isOpenToCommunity ? '댓글을 입력하세요' : '커뮤니티에 공개해야 댓글을 작성할 수 있습니다.',
                            border: InputBorder.none,
                            hintStyle:
                                datingCtrl.model.isOpenToCommunity ? Get.textTheme.bodyLarge : Get.textTheme.bodyMedium,
                            hintMaxLines: 1,
                          ),
                          minLines: 1,
                          maxLines: 3,
                        ),
                      ),
                    ),

                    /// 전송 버튼
                    Container(
                      decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        onPressed: datingCtrl.onTapCommentSendBtn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CommonLoadingIndicator<DatingHistoryDetailController>(),
          ],
        ),
      ),
    );
  }
}
