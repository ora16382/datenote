import 'package:datenote/constant/enum/assets_type.dart';
import 'package:datenote/models/dating_history/dating_history_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/models/test/rewarded_test_view.dart';
import 'package:datenote/modules/main/main_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../main.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final controller = Get.put(MainController());

  @override
  void initState() {
    controller.loadAdaptiveBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    controller.bannerAdReset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          _buildWeatherWidget(),
          _buildBannerAdWidget(),
          _buildToListButtonsWidget(),
          _buildCalendarWidget(),
          _buildDateContentSection(),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 4. 29.
  /// @comment 날씨 위젯 part
  ///
  Widget _buildWeatherWidget() {
    return GestureDetector(
      onTap: (){
        Get.to(RewardedAdTestView());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: GetBuilder<MainController>(
          id: ':weatherWidget',
          builder: (context) {
            if (controller.isWeatherLoading) {
              return Container(
                height: 138,
                alignment: Alignment.center,
                child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0),
              );
            } else if (controller.isWeatherError) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: const Icon(Icons.error, size: 24, color: Colors.grey),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Text('에러가 발생했어요', style: Get.textTheme.headlineSmall),
                      ),
                      Text(
                        '날씨 정보를 불러오는중 에러가 발생했어요,\n잠시후 다시 시도해주세요',
                        textAlign: TextAlign.center,
                        style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              );
            } else if (!controller.isLocationPermission) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: const Icon(Icons.location_off, size: 24, color: Colors.grey),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Text('위치 권한이 필요해요!', style: Get.textTheme.headlineSmall),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          '날씨 정보를 확인하려면\n위치 접근을 허용해주세요.',
                          textAlign: TextAlign.center,
                          style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                        ),
                      ),
                      ElevatedButton(onPressed: controller.onTapLocationSettingBtn, child: const Text('권한 설정하기')),
                    ],
                  ),
                ),
              );
            } else {
              final String iconUrl =
                  "https://openweathermap.org/img/wn/${(((controller.weatherInfo?['weather'] as List?)?.firstOrNull?['icon'] ?? '') as String).replaceAll('n', 'd')}@2x.png";

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                              ),
                              margin: const EdgeInsets.only(right: 8.0),
                              child: buildNetworkImage(imagePath: iconUrl, width: 32, height: 32),
                            ),
                            Text(
                              '${(controller.weatherInfo?['main']?['temp'] ?? '').toStringAsFixed(1)}°C',
                              style: Get.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: Text(controller.weatherType?.recommendComment ?? '', style: Get.textTheme.bodyLarge),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (controller.weatherInfo?['date'] != null)
                            Container(
                              margin: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '기준 : ${DateFormat('a hh:mm:ss').format((controller.weatherInfo?['date'] as DateTime))}',
                                style: Get.textTheme.bodyMedium,
                              ),
                            ),
                          GestureDetector(
                            onTap: controller.fetchWeather,
                            child: Icon(Icons.refresh, color: AppColors.primary, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 16.
  /// @comment 데이트 기록 / 플랜 추천 기록 상세보기 버튼
  ///
  Widget _buildToListButtonsWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.onTapGoToRecommendPlanList,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: const Icon(Icons.favorite_outline, color: AppColors.primary),
                      ),
                      Text('데이트 플랜', style: Get.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: controller.onTapGoToDatingHistoryList,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: const Icon(Icons.book_outlined, color: AppColors.primary),
                      ),
                      Text('데이트 기록', style: Get.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 16.
  /// @comment 캘린더 위젯 part
  ///
  Widget _buildCalendarWidget() {
    return GetBuilder<MainController>(
      id: ':calendar',
      builder: (_) {
        return TableCalendar(
          firstDay: Jiffy.now().subtract(years: 1).startOf(Unit.month).dateTime,

          /// 데이트 플랜 추천받을 수 있는 +5일까지를 범위로 설정
          lastDay: Jiffy.now().add(days: 5).endOf(Unit.month).dateTime,

          /// 포커스 요일
          focusedDay: controller.focusedDay,
          locale: Get.locale.toString(),

          /// 선택된 날짜 검증
          selectedDayPredicate: (day) {
            return isSameDay(controller.selectedDay, day);
          },
          calendarFormat: controller.calendarFormat,

          /// 포커스 날짜 변경 콜백
          onPageChanged: controller.onCalendarPageChanged,
          availableGestures: AvailableGestures.horizontalSwipe,
          onDaySelected: controller.onDaySelected,

          /// 포맷 변경 콜백
          onFormatChanged: controller.onFormatChanged,

          /// 캘린더 스타일
          calendarStyle: const CalendarStyle(
            /// 현재 달 외의 날짜 숨김
            outsideDaysVisible: false,
            cellMargin: EdgeInsets.all(12.0),
            cellPadding: EdgeInsets.all(12.0),
            // 요일 부분 높이 설정
          ),
          // rowHeight: 64,
          availableCalendarFormats: const {
            CalendarFormat.month: '월',
            CalendarFormat.twoWeeks: '2주',
            CalendarFormat.week: '주',
          },

          /// 캘린더 상단 포맷 버튼 비활성화
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            leftChevronVisible: false,
            rightChevronVisible: false,
            // headerPadding: EdgeInsets.only(bottom: 24),
          ),
          // eventLoader: (day) {
          //  /// 각 요일별로 여러가지 데이터를 가지고올거기 때문에 eventLoader 를 사용하지 않는다.
          // },
          /// 사용자가 달력 페이지를 빠르게 스와이프할 때, 여러 달을 건너뛰어 이동할 수 있음
          pageJumpingEnabled: false,
          daysOfWeekHeight: 42,
          calendarBuilders: CalendarBuilders(
            dowBuilder: _buildCalendarDowBuilder,
            headerTitleBuilder: _buildHeaderTitleBuilder,
            outsideBuilder: _buildDefaultBuilder,
            defaultBuilder: _buildDefaultBuilder,
            selectedBuilder: _buildDefaultBuilder,
            todayBuilder: _buildDefaultBuilder,
          ),
          // /// 날짜 선택 콜백
        );
      },
    );
  }

  Widget _buildCalendarDowBuilder(context, day) {
    final text = DateFormat.E().format(day);

    return Container(alignment: Alignment.center, child: Text(text, style: Get.textTheme.titleSmall));
  }

  Widget? _buildHeaderTitleBuilder(BuildContext context, DateTime day) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                DateTime now = Jiffy.now().subtract(years: 1).dateTime;
                bool isSameMonth = now.year == controller.focusedDay.year && now.month == controller.focusedDay.month;

                return Opacity(
                  opacity: isSameMonth ? 0 : 1,
                  child: IgnorePointer(
                    ignoring: isSameMonth,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: controller.onTapLeftChevron,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/images/icon/chevron_left.png',
                          width: 28,
                          height: 28,
                          color: const Color(0XFF666666),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${day.year}.${day.month}',
                style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
            Builder(
              builder: (context) {
                DateTime lastDay = Jiffy.now().add(days: 5).dateTime;
                bool isSameMonth =
                    lastDay.year == controller.focusedDay.year && lastDay.month == controller.focusedDay.month;

                return Opacity(
                  /// 마지막날이 아닐 경우에만 보이도록
                  opacity: isSameMonth ? 0 : 1,
                  child: IgnorePointer(
                    ignoring: isSameMonth,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: controller.onTapRightChevron,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/images/icon/chevron_right.png',
                          width: 28,
                          height: 28,
                          color: const Color(0XFF666666),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        Positioned(
          right: 0,
          top: 4,
          child: Builder(
            builder: (context) {
              if (isSameDay(controller.selectedDay, DateTime.now())) {
                return const SizedBox();
              } else {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: controller.onTapTodayBtn,
                  child: Container(
                    width: 48,
                    height: 28,
                    padding: const EdgeInsets.all(4),
                    decoration: ShapeDecoration(
                      color: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: Text(
                      '오늘',
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleSmall?.copyWith(color: AppColors.onPrimary),
                    ),
                  ).animate().fade(duration: 500.ms),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget? _buildDefaultBuilder(BuildContext context, DateTime day, DateTime focusedDay) {
    final isEqualDay = isSameDay(day, controller.selectedDay);

    final hasRecommendPlan = controller.recommendPlanModelDataMap[day]?.isNotEmpty ?? false;
    final hasDatingHistory = controller.datingHistoryModelDataMap[day]?.isNotEmpty ?? false;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(bottom: 4.0),
          decoration: BoxDecoration(shape: BoxShape.circle, color: isEqualDay ? AppColors.primary : null),
          alignment: const CalendarStyle().cellAlignment,
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: isEqualDay ? Colors.white : const Color(0XFF666666),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        /// ⬇️ 동그라미 마커 표시 영역
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasRecommendPlan)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pinkAccent, // ✅ 예: 추천 플랜용
                ),
              ),
            if (hasDatingHistory)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent, // ✅ 예: 데이트 히스토리용
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 27.
  /// @comment 캘린더 하단 플랜, 데이트 기록 위젯
  ///
  Widget _buildDateContentSection() {
    return GetBuilder<MainController>(
      id: ':planAndHistory',
      builder: (context) {
        final hasRecommendPlan = controller.recommendPlanModelDataMap[controller.selectedDay]?.isNotEmpty ?? false;
        final hasDatingHistory = controller.datingHistoryModelDataMap[controller.selectedDay]?.isNotEmpty ?? false;

        return Container(
          margin: const EdgeInsets.only(top: 12, bottom: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  DateFormat('📅 yyyy년 M월 d일 (E)', 'ko').format(controller.selectedDay),
                  style: Get.textTheme.titleLarge,
                ),
              ),
              if (!hasDatingHistory && !hasRecommendPlan)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: const Icon(Icons.calendar_today, size: 48, color: Color(0xFFCCCCCC)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: const Text(
                          '아직 등록된 데이트 기록이 없어요.',
                          style: TextStyle(fontSize: 15, color: Color(0xFF999999)),
                        ),
                      ),
                      const Text(
                        '새로운 데이트 플랜을 추천받거나\n기록을 작성해보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                      ),
                    ],
                  ),
                ),
              if (hasRecommendPlan) _buildSectionTitle('추천 데이트 플랜', Colors.pinkAccent),
              ...controller.recommendPlanModelDataMap[controller.selectedDay]
                      ?.map((plan) => _buildPlanTile(plan))
                      .toList() ??
                  [],
              if (hasRecommendPlan) const SizedBox(height: 16),
              if (hasDatingHistory) _buildSectionTitle('나의 데이트 기록', Colors.blueAccent),
              ...controller.datingHistoryModelDataMap[controller.selectedDay]
                      ?.map((history) => _buildHistoryTile(history))
                      .toList() ??
                  [],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 27.
  /// @comment 데이트 플랜 카드 위젯
  ///
  Widget _buildPlanTile(RecommendPlanModel plan) {
    return GestureDetector(
      onTap: () {
        controller.onTapRecommendPlan(plan);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 제목
                      Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: Text(plan.title, style: Get.textTheme.headlineSmall),
                      ),

                      /// 설명
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          plan.description,
                          style: Get.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.place, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${plan.baseAddress.addressName.isNotEmpty ? '${plan.baseAddress.addressName} · ' : ''}${plan.baseAddress.address}',
                              style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 27.
  /// @comment 데이트 기록 카드 위젯
  ///
  Widget _buildHistoryTile(DatingHistoryModel history) {
    return GestureDetector(
      onTap: () {
        controller.onTapDatingHistory(history);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                /// 텍스트
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        history.description,
                        style: Get.textTheme.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (history.assets.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          buildNetworkImage(
                            imagePath:
                                history.assets.first.type == AssetType.video
                                    ? history.assets.first.thumbnailUrl ?? ''
                                    : history.assets.first.url ?? '',
                            width: 100,
                            height: 100,
                          ),
                          if (history.assets.first.type == AssetType.video)
                            Positioned(
                              bottom: -2,
                              right: 2,
                              child: Icon(Icons.videocam, color: AppColors.primary, size: 32),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 6. 9.
  /// @comment 배너형 광고
  ///
  Widget _buildBannerAdWidget() {
    return GetBuilder<MainController>(
      id: ':bannerAd',
      builder: (context) {
        if(!controller.isAdLoaded) {
          return Container(margin: const EdgeInsets.only(bottom: 12.0),child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0));
        } else {
          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            width: controller.bannerAd.size.width.toDouble(),
            height: controller.bannerAd.size.height.toDouble(),
            child: AdWidget(ad: controller.bannerAd),
          );
        }

      }
    );
  }
}
