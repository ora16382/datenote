import 'package:datenote/models/place/place_model.dart';
import 'package:datenote/modules/main/recommendPlan/detail/recommend_plan_detail_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_loading_indicator_widget.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecommendPlanDetailView extends StatefulWidget {
  const RecommendPlanDetailView({super.key});

  @override
  State<RecommendPlanDetailView> createState() => _RecommendPlanDetailViewState();
}

class _RecommendPlanDetailViewState extends State<RecommendPlanDetailView> {
  final detailCtrl = Get.put(RecommendPlanDetailController());

  final Map<String, String> categoryEmojis = {
    'MT1': '🛒',
    'CS2': '🏪',
    'PS3': '🧒',
    'SC4': '🏫',
    'AC5': '📚',
    'PK6': '🅿️',
    'OL7': '⛽',
    'SW8': '🚇',
    'BK9': '🏦',
    'CT1': '🎭',
    'AG2': '🏘️',
    'PO3': '🏛️',
    'AT4': '🏞️',
    'AD5': '🏨',
    'FD6': '🍽️',
    'CE7': '☕',
    'HP8': '🏥',
    'PM9': '💊',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('데이트 플랜', style: Get.textTheme.titleMedium),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: buildBackBtn(() => Get.back()),
        actions: [
          Builder(
            builder: (context) {
              if (detailCtrl.isCommunity) {
                /// 데이트 기록, 커뮤니티를 통해 들어왔으면 수정, 삭제 동작이 어차피 불가능 하기 때문에 숨김처리
                return SizedBox.shrink();
              }

              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    detailCtrl.onTapEditBtn();
                  } else {
                    detailCtrl.onTapDeleteBtn();
                  }
                },
                color: Colors.white,
                // menuPadding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 60),
                itemBuilder:
                    (context) => [
                      PopupMenuItem<String>(value: 'edit', child: Text('수정', style: Get.theme.textTheme.titleSmall)),
                      PopupMenuItem<String>(value: 'delete', child: Text('삭제', style: Get.theme.textTheme.titleSmall)),
                    ],
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: GetBuilder<RecommendPlanDetailController>(
              id: ':datePlanBody',
              builder: (context) {
                if (detailCtrl.isDataLoadingProgress) {
                  return Center(child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0));
                } else {
                  return ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          detailCtrl.recommendPlanModel.title,
                          style: Get.textTheme.titleLarge?.copyWith(color: AppColors.primary),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        child: Text(detailCtrl.recommendPlanModel.description, style: Get.textTheme.bodyMedium),
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
                                style: Get.textTheme.titleMedium?.copyWith(
                                  color: AppColors.primary.withAlpha(192),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(detailCtrl.recommendPlanModel.date),
                              style: Get.textTheme.titleMedium?.copyWith(
                                color: AppColors.primary.withAlpha(192),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text('📍 기준 장소', style: Get.textTheme.titleMedium),
                      ),
                      _buildBasePlaceCard(),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text('📒 데이트 플랜', style: Get.textTheme.titleMedium),
                      ),
                      ...detailCtrl.recommendPlanModel.places.map((place) => _buildPlaceCard(place)).toList(),

                      /// 생성일
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '생성일: ${DateFormat('yyyy.MM.dd HH:mm').format(detailCtrl.recommendPlanModel.createdAt)}',
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
          CommonLoadingIndicator<RecommendPlanDetailController>(),
        ],
      ),
    );
  }

  Widget _buildBasePlaceCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withAlpha(40), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(detailCtrl.recommendPlanModel.baseAddress.address, style: Get.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(detailCtrl.recommendPlanModel.baseAddress.detailAddress, style: Get.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(PlaceModel place) {
    final emoji = categoryEmojis[place.category_group_code] ?? '📍';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey.withAlpha(80)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: InkWell(
        onTap: () => detailCtrl.onTapPlaceCard(place),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '${place.index}. ${place.place_name}',
                      style: Get.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text('$emoji ', style: const TextStyle(fontSize: 18)),
                        Text(place.category_group_name, style: Get.textTheme.titleSmall),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    child: Text(place.address_name, style: Get.textTheme.bodySmall),
                  ),
                  Text(
                    '기준 장소와의 거리: ${int.parse(place.distance ?? '0') >= 1000 ? '${(int.parse(place.distance ?? '0') / 1000).toStringAsFixed(2)}km' : '${int.parse(place.distance ?? '0')}m'}',
                    style: Get.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.open_in_new_rounded, size: 20, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
