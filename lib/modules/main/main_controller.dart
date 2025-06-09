import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/constant/enum/weather_type.dart';
import 'package:datenote/models/dating_history/dating_history_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/modules/user/address/search/address_search_controller.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/services/weather_service.dart';
import 'package:datenote/util/functions/common_functions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../main.dart';

class MainController extends GetxController {
  final userCtrl = Get.find<UserController>();

  /// #### 날씨 관련 필드 - 시작
  final weatherService = Get.find<WeatherService>();

  /// 날씨 데이터 가져오는중인지 여부
  bool isWeatherLoading = true;

  /// 위치 정보 권한 여부
  bool isLocationPermission = false;

  /// 날씨 데이터 요청중 에러 발생 여부
  bool isWeatherError = false;

  /// 날씨 타입
  WeatherType? weatherType;

  /// 날씨 정보
  Map<String, dynamic>? weatherInfo;

  /// #### 날씨 관련 필드 - 종료

  /// ======================== ///
  /// 캘린더 관련 변수
  /// ======================== ///

  /// 캘린더 포맷
  CalendarFormat calendarFormat = CalendarFormat.twoWeeks;

  /// 포커스 기준이 되는 날짜
  DateTime focusedDay = Jiffy.now().dateTime;

  /// 선택 날짜
  DateTime selectedDay = Jiffy.now().dateTime;

  /// 데이터 플랜 데이터 맵
  /// key 를 비교할때 Time 을 제외한 Date 만 비교하기 위하여 사용
  LinkedHashMap<DateTime, List<RecommendPlanModel>> recommendPlanModelDataMap = LinkedHashMap(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  /// 데이터 플랜 데이터 맵
  /// key 를 비교할때 Time 을 제외한 Date 만 비교하기 위하여 사용
  LinkedHashMap<DateTime, List<DatingHistoryModel>> datingHistoryModelDataMap = LinkedHashMap(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  LinkedHashSet<DateTime> isAlreadyLoadedDateSet = LinkedHashSet(equals: isSameDay, hashCode: getHashCode);

  @override
  void onInit() {
    super.onInit();

    fetchWeather();
    selectPlanAndDatingHistoryData();
  }

  /// @author 정준형
  /// @since 2025. 4. 29.
  /// @comment 날씨 데이터 불러오기
  ///
  Future<void> fetchWeather() async {
    isWeatherError = false;
    isLocationPermission = false;

    isWeatherLoading = true;
    update([':weatherWidget']);

    Position? position = await AddressSearchController.getCurrentPosition();

    if (position != null) {
      try {
        isLocationPermission = true;

        weatherInfo = await weatherService.fetchWeather(latitude: position.latitude, longitude: position.longitude);

        weatherInfo?['date'] = DateTime.now();

        weatherType = mapDescriptionToWeatherType(
          (weatherInfo?['weather'] as List?)?.firstOrNull?['description'] ?? '',
        );
      } catch (e) {
        logger.i(e);
        isWeatherError = true;
        update([':weatherWidget']);
      } finally {
        isWeatherLoading = false;
        update([':weatherWidget']);
      }
    } else {
      update([':weatherWidget']);
    }
  }

  /// @author 정준형
  /// @since 2025. 4. 29.
  /// @comment 위치 권한 설정 버튼 클릭
  ///
  Future<void> onTapLocationSettingBtn() async {
    await Geolocator.openAppSettings();
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment 데이트 플랜 목록으로 이동
  ///
  Future<void> onTapGoToRecommendPlanList() async {
    Get.toNamed(Routes.recommendPlanList);
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment 데이트 기록 목록으로 이동
  ///
  Future<void> onTapGoToDatingHistoryList() async {
    Get.toNamed(Routes.datingHistoryList);
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment 포커스 날짜 변경 콜백
  ///
  void onCalendarPageChanged(DateTime focusedDay, {bool isUpdateCalendar = false}) async {
    this.focusedDay = focusedDay;

    if (isUpdateCalendar) {
      /// < > 버튼으로 이동할때는 캘린더만 업데이트
      update([':calendar']);
    } else {
      /// 캘린더 업데이트 이후 호출되는 콜백에서는 데이터 조회
      selectPlanAndDatingHistoryData();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 27.
  /// @comment 데이트 플랜과, 데이트 기록 데이터 조회
  ///
  Future<void> selectPlanAndDatingHistoryData() async {
    Jiffy focusedDayJiffy = Jiffy.parseFromDateTime(focusedDay);
    final firstDayOfMonth = focusedDayJiffy.startOf(Unit.month).dateTime;
    final lastDayOfMonth = focusedDayJiffy.endOf(Unit.month).dateTime;

    if (isAlreadyLoadedDateSet.contains(firstDayOfMonth)) {
      /// 이미 기록한 데이터에 대해서는 다시 조회하지 않는다.
      /// 새롭게 추가되는 데이터는 해당 날짜만 별도로 조회시킴
      return;
    }

    /// 이미 추가한 날짜는 다시 조회하지 않는다.
    isAlreadyLoadedDateSet.add(firstDayOfMonth);

    await Future.wait<void>([
      selectDatePlanData(firstDayOfMonth, lastDayOfMonth),
      selectDatingHistoryData(firstDayOfMonth, lastDayOfMonth),
    ]);

    update([':calendar', ':planAndHistory']);
  }

  /// @author 정준형
  /// @since 2025. 5. 27.
  /// @comment 데이트 플랜 데이터 조회
  ///
  Future<void> selectDatePlanData(DateTime firstDayOfMonth, DateTime lastDayOfMonth) async {
    Query query = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.recommendDatePlan)
        .where('userId', isEqualTo: userCtrl.currentUser.uid)
        .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
        .where('date', isLessThanOrEqualTo: lastDayOfMonth)
        .orderBy('date', descending: true);

    final snapshot = await query.get();
    // snapshot.docs 사용해서 데이터 처리

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final plan = RecommendPlanModel.fromJson(data as Map<String, dynamic>);

        final originalDate = plan.date; // 예: DateTime 포함된 시간 있음
        final dateOnly = DateTime(originalDate.year, originalDate.month, originalDate.day);

        if (recommendPlanModelDataMap[dateOnly] == null) {
          recommendPlanModelDataMap[dateOnly] = [plan];
        } else {
          recommendPlanModelDataMap[dateOnly]!.add(plan);
        }
      }
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 27.
  /// @comment 데이트 기록 데이터 조회
  ///
  Future<void> selectDatingHistoryData(DateTime firstDayOfMonth, DateTime lastDayOfMonth) async {
    Query query = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.datingHistory)
        .where('userId', isEqualTo: userCtrl.currentUser.uid)
        .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
        .where('date', isLessThanOrEqualTo: lastDayOfMonth)
        .orderBy('date', descending: true);

    final snapshot = await query.get();
    // snapshot.docs 사용해서 데이터 처리

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final datingHistory = DatingHistoryModel.fromJson(data as Map<String, dynamic>);

        final originalDate = datingHistory.date; // 예: DateTime 포함된 시간 있음
        final dateOnly = DateTime(originalDate.year, originalDate.month, originalDate.day);

        if (datingHistoryModelDataMap[dateOnly] == null) {
          datingHistoryModelDataMap[dateOnly] = [datingHistory];
        } else {
          datingHistoryModelDataMap[dateOnly]!.add(datingHistory);
        }
      }
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 27.
  /// @comment 데이트플랜 작성, 삭제시 업데이트 콜백
  ///
  Future<void> updateDatePlanData(DateTime dateTime) async {
    Jiffy dateTimeJiffy = Jiffy.parseFromDateTime(dateTime);
    final firstDayOfMonth = dateTimeJiffy.startOf(Unit.day).dateTime;
    final lastDayOfMonth = dateTimeJiffy.endOf(Unit.day).dateTime;

    /// 기존 데이터 제거
    recommendPlanModelDataMap[dateTime]?.clear();
    await selectDatePlanData(firstDayOfMonth, lastDayOfMonth);

    update([':calendar']);

    /// selectedDay 랑 비교 후 업데이트
    if (isSameDay(dateTime, selectedDay)) {
      update([':planAndHistory']);
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 27.
  /// @comment 데이트기록 작성, 삭제시 업데이트 콜백
  ///
  Future<void> updateDatingHistoryData(DateTime dateTime) async {
    Jiffy dateTimeJiffy = Jiffy.parseFromDateTime(dateTime);
    final firstDayOfMonth = dateTimeJiffy.startOf(Unit.day).dateTime;
    final lastDayOfMonth = dateTimeJiffy.endOf(Unit.day).dateTime;

    /// 기존 데이터 제거
    datingHistoryModelDataMap[dateTime]?.clear();
    await selectDatingHistoryData(firstDayOfMonth, lastDayOfMonth);

    update([':calendar']);

    /// selectedDay 랑 비교 후 업데이트
    if (isSameDay(dateTime, selectedDay)) {
      update([':planAndHistory']);
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment calendar 이전달 클릭 콜백
  ///
  void onTapLeftChevron() {
    DateTime previousDateTime;
    if(calendarFormat == CalendarFormat.month) {
      previousDateTime = DateTime(focusedDay.year, focusedDay.month - 1);
    } else if(calendarFormat == CalendarFormat.twoWeeks){
      previousDateTime = DateTime(focusedDay.year, focusedDay.month, focusedDay.day - 14);
    } else {
      previousDateTime = DateTime(focusedDay.year, focusedDay.month, focusedDay.day - 7);
    }

    onCalendarPageChanged(previousDateTime, isUpdateCalendar: true);
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment calendar 다음달 클릭 콜백
  ///
  void onTapRightChevron() {
    DateTime nextDateTime;
    if(calendarFormat == CalendarFormat.month) {
      nextDateTime = DateTime(focusedDay.year, focusedDay.month + 1);
    } else if(calendarFormat == CalendarFormat.twoWeeks){
      nextDateTime = DateTime(focusedDay.year, focusedDay.month, focusedDay.day + 14);
    } else {
      nextDateTime = DateTime(focusedDay.year, focusedDay.month, focusedDay.day + 7);
    }

    onCalendarPageChanged(nextDateTime, isUpdateCalendar: true);
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment 투데이버튼 클릭 콜백
  ///
  void onTapTodayBtn() {
    onCalendarPageChanged(Jiffy.now().dateTime, isUpdateCalendar: true);
    onDaySelected(Jiffy.now().dateTime, Jiffy.now().dateTime);
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay = selectedDay;
    this.focusedDay = focusedDay;

    update([':calendar', ':planAndHistory']);
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment 데이트 플랜 추천 클릭 콜백
  ///
  void onTapRecommendPlan(RecommendPlanModel recommendPlanModel) {
    Get.toNamed(Routes.recommendPlanDetail, arguments: recommendPlanModel);
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment 데이트 플랜 추천 클릭 콜백
  ///
  void onTapDatingHistory(DatingHistoryModel datingHistoryModel) {
    /// 5. 상세보기로 진입하기
    Get.toNamed(Routes.datingHistoryDetail, arguments: datingHistoryModel);
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat = format;
    update([':calendar']);
  }
}
