import 'package:datenote/modules/main/main_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final controller = Get.put(MainController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          _buildWeatherWidget(),
          _buildToListButtonsWidget(),
          _buildCalendarWidget(),
        ],
      ),
    );
  }

  /// @author 정준형
  /// @since 2025. 4. 29.
  /// @comment 날씨 위젯 part
  ///
  Widget _buildWeatherWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GetBuilder<MainController>(
        id: ':weatherWidget',
        builder: (context) {
          if (controller.isWeatherLoading) {
            return Center(
              child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0),
            );
          } else if (controller.isWeatherError) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: const Icon(
                        Icons.error,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '에러가 발생했어요',
                        style: Get.textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      '날씨 정보를 불러오는중 에러가 발생했어요,\n잠시후 다시 시도해주세요',
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (!controller.isLocationPermission) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: const Icon(
                        Icons.location_off,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '위치 권한이 필요해요!',
                        style: Get.textTheme.headlineSmall,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        '날씨 정보를 확인하려면\n위치 접근을 허용해주세요.',
                        textAlign: TextAlign.center,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: controller.onTapLocationSettingBtn,
                      child: const Text('권한 설정하기'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            final String iconUrl =
                "https://openweathermap.org/img/wn/${(((controller.weatherInfo?['weather'] as List?)?.firstOrNull?['icon'] ?? '') as String).replaceAll('n', 'd')}@2x.png";

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                            margin: const EdgeInsets.only(right: 8.0),
                            child: buildNetworkImage(
                              imagePath: iconUrl,
                              width: 32,
                              height: 32,
                            ),
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
                      child: Text(
                        controller.weatherType?.recommendComment ?? '',
                        style: Get.textTheme.bodyLarge,
                      ),
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
                          child: Icon(
                            Icons.refresh,
                            color: AppColors.primary,
                            size: 20,
                          ),
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
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 16.
  /// @comment 데이트 기록 / 플랜 추천 기록 상세보기 버튼
  ///
  Widget _buildToListButtonsWidget() {
    return Container();
  }

  /// @author 정준형
  /// @since 2025. 5. 16.
  /// @comment 캘린더 위젯 part
  ///
  Widget _buildCalendarWidget() {
    return Container(
      child: TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
      ),
    );
  }
}
