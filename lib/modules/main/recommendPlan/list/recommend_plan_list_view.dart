import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/modules/main/recommendPlan/list/recommend_plan_list_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_loading_indicator_widget.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class RecommendPlanListView extends StatefulWidget {
  const RecommendPlanListView({super.key});

  @override
  State<RecommendPlanListView> createState() => _RecommendPlanListViewState();
}

class _RecommendPlanListViewState extends State<RecommendPlanListView> {
  final controller = Get.put(RecommendPlanListController());

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
        title: Text('데이트 플랜', style: Get.textTheme.titleMedium),

        /// 기본 뒤로가기 없애기 위해 추가
        leading: buildBackBtn(() => Get.back()),
      ),
      body: Stack(
        children: [
          Container(
            // margin: const EdgeInsets.only(bottom: 48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GetBuilder<RecommendPlanListController>(
              id: ':recommendPlanList',
              builder: (_) {
                return PagingListener(
                  controller: controller.pagingController,
                  builder: (context, state, fetchNextPage) {
                    return RefreshIndicator(
                      onRefresh: controller.onRefresh,
                      child: PagedListView<int, RecommendPlanModel>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate: PagedChildBuilderDelegate<RecommendPlanModel>(
                          itemBuilder: (context, recommendPlanModel, index) {
                            return _buildRecommendPlanItem(index, recommendPlanModel);
                          },
                          newPageErrorIndicatorBuilder: (context) {
                            return Text('오류가 발생하였습니다. 잠시 후 다시 시도해주세요.', style: Get.textTheme.bodyMedium);
                          },
                          noItemsFoundIndicatorBuilder: (context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/recommend_date_plan/no_data_image.png',
                                  width: 200,
                                  height: 200,
                                ),
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
          CommonLoadingIndicator<RecommendPlanListController>(),
        ],
      ),
      floatingActionButton:
          controller.isSelectMode
              ? null
              : FloatingActionButton.extended(
                onPressed: controller.onTapDatePlanRecommendBtn,
                icon: const Icon(Icons.favorite_rounded),
                label: Text('데이트 플랜 추천', style: Get.textTheme.headlineSmall?.copyWith(color: AppColors.onPrimary)),
              ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment 데이트 플랜 card widget
  ///
  Widget _buildRecommendPlanItem(int index, RecommendPlanModel recommendPlanModel) {
    return GetBuilder<RecommendPlanListController>(
      id: ':recommendPlanItem:${recommendPlanModel.id}',
      builder: (context) {
        recommendPlanModel = controller.pagingController.items?[index] ?? recommendPlanModel;

        final currentDate = DateTime(
          recommendPlanModel.date.year,
          recommendPlanModel.date.month,
          recommendPlanModel.date.day,
        );

        DateTime? previousDate;
        if (index > 0) {
          final prevItem = controller.pagingController.items![index - 1];
          previousDate = DateTime(prevItem.date.year, prevItem.date.month, prevItem.date.day);
        }

        final shouldShowHeader = index == 0 || previousDate != currentDate;

        return Column(
          children: [
            if (shouldShowHeader)
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 4),
                child: Text(
                  DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(currentDate),
                  style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            GestureDetector(
              onTap: () {
                controller.onTapRecommendPlan(recommendPlanModel);
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
                      /// 제목
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Text(recommendPlanModel.title, style: Get.textTheme.titleMedium),
                      ),

                      /// 설명
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          recommendPlanModel.description,
                          style: Get.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      /// 데이트 날짜 (요일)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Text('📅', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              '데이트 날짜: ${DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(recommendPlanModel.date)}',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary.withAlpha(192),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 장소 정보
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.place, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${recommendPlanModel.baseAddress.addressName.isNotEmpty ? '${recommendPlanModel.baseAddress.addressName} · ' : ''}${recommendPlanModel.baseAddress.address}',
                                style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 생성일
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '생성일: ${DateFormat('yyyy.MM.dd HH:mm').format(recommendPlanModel.createdAt)}',
                            style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
