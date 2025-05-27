import 'package:datenote/constant/enum/assets_type.dart';
import 'package:datenote/main.dart';
import 'package:datenote/models/address/address_model.dart';
import 'package:datenote/models/dating_history/dating_history_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/modules/community/community_controller.dart';
import 'package:datenote/modules/main/dating_history/list%20/dating_history_list_controller.dart';
import 'package:datenote/modules/main/recommendPlan/list/recommend_plan_list_controller.dart';
import 'package:datenote/modules/user/address/manage/address_manage_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_loading_indicator_widget.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => CommunityViewState();
}

class CommunityViewState extends State<CommunityView> {
  final controller = Get.put(CommunityController());

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
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text('커뮤니티', style: Get.textTheme.titleMedium),

        /// 기본 뒤로가기 없애기 위해 추가
        leading: null,
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 48),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: GetBuilder<CommunityController>(
              id: ':communityList',
              builder: (_) {
                return PagingListener(
                  controller: controller.pagingController,
                  builder: (context, state, fetchNextPage) {
                    return RefreshIndicator(
                      onRefresh: controller.onRefresh,
                      child: PagedListView<int, DatingHistoryModel>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate: PagedChildBuilderDelegate<DatingHistoryModel>(
                          itemBuilder: (context, datingHistoryModel, index) {
                            return _buildDatingHistoryItem(index, datingHistoryModel);
                          },
                          newPageErrorIndicatorBuilder: (context) {
                            return Text('오류가 발생하였습니다. 잠시 후 다시 시도해주세요.', style: Get.textTheme.bodyMedium);
                          },
                          noItemsFoundIndicatorBuilder: (context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/community/no_data_image.png', width: 200, height: 200),
                              ],
                            );
                          },
                          firstPageErrorIndicatorBuilder: (context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Image.asset(
                                    'assets/images/common/load_error_image.png',
                                    width: 200,
                                    height: 200,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: controller.onRefresh,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(
                                    '새로고침',
                                    style: Get.textTheme.headlineSmall?.copyWith(color: AppColors.onPrimary),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          CommonLoadingIndicator<CommunityController>(),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment 데이트 기록 card widget
  ///
  Widget _buildDatingHistoryItem(int index, DatingHistoryModel datingHistoryModel) {
    return GetBuilder<CommunityController>(
      id: ':datingHistoryItem:${datingHistoryModel.id}',
      builder: (context) {
        datingHistoryModel = controller.pagingController.items?[index] ?? datingHistoryModel;

        return GestureDetector(
          onTap: () {
            controller.onTapDatingHistory(datingHistoryModel);
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 사용자 닉네임
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          child: const Icon(Icons.person_rounded, size: 18, color: AppColors.grey),
                        ),
                        Text(
                          datingHistoryModel.user?.displayName ?? '익명',
                          style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  /// 데이트 날짜
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 6.0),
                          child: const Text('📅', style: TextStyle(fontSize: 16)),
                        ),
                        Text(
                          '데이트 날짜: ${DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(datingHistoryModel.date)}',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary.withAlpha(192),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Carousel (assets)
                  if (datingHistoryModel.assets.isNotEmpty) _buildAssetCarousel(datingHistoryModel),

                  /// 설명
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      datingHistoryModel.description,
                      style: Get.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  /// 기분
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Text(
                          '오늘의 기분: ${datingHistoryModel.mood.label}',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            // color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 태그
                  if (datingHistoryModel.tags.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            datingHistoryModel.tags.map((tag) {
                              return Text(
                                '#$tag',
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            }).toList(),
                      ),
                    ),

                  /// 생성일
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// 좋아요 영역
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: GetBuilder<CommunityController>(
                              id: ':favorite:datingHistoryItem:${datingHistoryModel.id}',
                              builder: (_) {
                                if(controller.favoriteLoadingProgressMap[datingHistoryModel.id] ?? false) {
                                  return SpinKitFadingCircle(color: AppColors.primary, size: 20.0);
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.onTapFavorite(datingHistoryModel);
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 4),
                                          child: Icon(Icons.favorite, color: datingHistoryModel.likesUserId.contains(controller.userCtrl.currentUser.uid) ? Colors.redAccent : AppColors.grey, size: 20),
                                        ),
                                        Text(
                                          '${datingHistoryModel.likesUserId.length}',
                                          style: Get.textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                            ),
                          ),
                          if(datingHistoryModel.userId == controller.userCtrl.currentUser.uid)
                          /// 커뮤니티 노출 영역
                            GetBuilder<CommunityController>(
                              id: ':isCommunityOpen:datingHistoryItem:${datingHistoryModel.id}',
                              builder: (_) {
                                if (controller.isCommunityOpenLoadingProgressMap[datingHistoryModel.id] ?? false) {
                                  return SpinKitFadingCircle(color: AppColors.primary, size: 20.0);
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.onTapIsCommunityOpen(datingHistoryModel);
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 4),
                                      child: Icon(
                                        Icons.visibility_rounded,
                                        color:
                                        datingHistoryModel.isOpenToCommunity
                                            ? AppColors.primary
                                            : AppColors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                      Text(
                        '생성일: ${DateFormat('yyyy.MM.dd HH:mm').format(datingHistoryModel.createdAt)}',
                        style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAssetCarousel(DatingHistoryModel model) {
    final pageController = PageController(viewportFraction: 1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            height: 180,
            child: PageView.builder(
              controller: pageController,
              itemCount: model.assets.length,
              itemBuilder: (context, index) {
                final asset = model.assets[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        buildNetworkImage(
                          imagePath: asset.type == AssetType.video ? asset.thumbnailUrl ?? '' : asset.url ?? '',
                          width: double.infinity,
                        ),
                        if (asset.type == AssetType.video)
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Icon(Icons.videocam, color: AppColors.primary, size: 32),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: SmoothPageIndicator(
              controller: pageController,
              count: model.assets.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.primary,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
