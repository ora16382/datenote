import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/constant/enum/preferred_date_type.dart';
import 'package:datenote/constant/enum/recommend_plan_step_type.dart';
import 'package:datenote/main.dart';
import 'package:datenote/models/address/address_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/modules/main/main_controller.dart';
import 'package:datenote/modules/user/address/search/address_search_controller.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/services/kakao_local_service.dart';
import 'package:datenote/services/open_ai_service.dart';
import 'package:datenote/services/weather_service.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:datenote/util/widget/dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class RecommendPlanController extends GetxController {
  /// 유저 컨트롤러
  final userCtrl = Get.find<UserController>();

  /// open ai service
  final openAiService = Get.find<OpenAiService>();

  /// 카카오 local service
  final kakaoLocalService = Get.find<KakaoLocalService>();

  /// 날씨 service
  final weatherService = Get.find<WeatherService>();

  /// 스텝 단계
  Rx<RecommendPlanStepType> recommendPlanStepType = Rx(RecommendPlanStepType.date);

  /// 선택된 날짜
  final selectedDate = DateTime.now().obs;

  /// 날씨 데이터 요청 상태
  bool isWeatherLoading = true;

  /// 불러온 날씨 데이터
  Map<DateTime, Map<String, dynamic>> weatherData = {};

  /// 선호하는 데이트 타입
  final selectedPreferredDateType = PreferredDateType.values.first.obs;

  /// 주소 저장 요청 상태
  bool isAddressSaveLoadingProgress = false;

  /// 오픈 ai api 요청 상태
  bool isOpenAIAPILoadingProgress = false;

  /// 카카오 로컬 api 요청 상태
  bool isKakaoLocalAPILoadingProgress = false;

  @override
  void onInit() {
    loadWeatherData();

    super.onInit();
  }

  /// @author 정준형
  /// @since 2025. 4. 30.
  /// @comment 오늘~5일 뒤까지 날씨 데이터 조회
  ///
  Future<void> loadWeatherData() async {
    Position? position = await AddressSearchController.getCurrentPosition();

    if (position != null) {
      isWeatherLoading = true;
      update([':dateSelector']);

      try {
        weatherData = await weatherService.fetchWeatherForDate(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } catch (e) {
        showToast(e.toString());
      } finally {
        isWeatherLoading = false;
        update([':dateSelector']);
      }
    }
  }

  /// @author 정준형
  /// @since 2025. 4. 30.
  /// @comment 뒤로가기 버튼 클릭 콜백
  ///
  Future<void> onTapBackBtn() async {
    if (recommendPlanStepType.value == RecommendPlanStepType.date) {
      if (await showTwoButtonDialog(
        contents: '데이트 플랜 추천을 취소하시겠습니까?',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        Get.back();
      }
    } else {
      recommendPlanStepType.value = RecommendPlanStepType.values[recommendPlanStepType.value.index - 1];
      update([':progressIndicator', ':stepBody']);
    }
  }

  /// @author 정준형
  /// @since 2025. 4. 30.
  /// @comment 날짜 선택 콜백
  ///
  void onSelectDate(DateTime date) {
    selectedDate.value = date;
  }

  /// @author 정준형
  /// @since 2025. 4. 30.
  /// @comment 다음 버튼 클릭 콜백
  ///
  void onTapNextBtn() {
    switch (recommendPlanStepType.value) {
      case RecommendPlanStepType.date:
        if (isWeatherLoading) {
          showToast('날씨 정보를 불러오는중입니다. 잠시만 기다려주세요');
          return;
        }
        recommendPlanStepType.value = RecommendPlanStepType.values[recommendPlanStepType.value.index + 1];
        break;
      case RecommendPlanStepType.address:
        if (!Get.find<AddressSearchController>(tag: ':recommend_plan').validateAddress(isWithoutAddressName: true)) {
          return;
        }

        recommendPlanStepType.value = RecommendPlanStepType.values[recommendPlanStepType.value.index + 1];

        break;
      case RecommendPlanStepType.preferredDateType:
        recommendDatePlan();
        break;
    }

    update([':progressIndicator', ':stepBody']);
  }

  /// @author 정준형
  /// @since 2025. 4. 30.
  /// @comment 선호하는 데이트 타입 선택 콜백
  ///
  void onSelectPreferredDateType(PreferredDateType type) {
    selectedPreferredDateType.value = type;
  }

  /// @author 정준형
  /// @since 2025. 4. 30.
  /// @comment 데이트 플랜 추천 요청
  ///
  Future<void> recommendDatePlan() async {
    /// 1. 주소 저장
    AddressSearchController addressSearchController = Get.find<AddressSearchController>(tag: ':recommend_plan');

    if (addressSearchController.isSaveAddress.value) {
      try {
        isAddressSaveLoadingProgress = true;
        update([':addressSaveLoading']);

        await addressSearchController.updateAddress(isWithoutAddressName: true);
      } catch (e) {
        return;
      } finally {
        isAddressSaveLoadingProgress = false;
        update([':addressSaveLoading']);
      }
    }

    Map<String, dynamic> recommendDatePlanMap;

    // /// 2. open ai api 요청으로 목록 받기
    // try {
    //   isOpenAIAPILoadingProgress = true;
    //   update([':openAIAPILoading']);
    //
    //   recommendDatePlanMap = await _requestRecommendDatePlanToOpenAI(addressSearchController);
    // } catch (e) {
    //   logger.e(e);
    //   showToast('데이트 플랜 추천 도중 오류가 발생하였습니다. 잠시 후 다시 시도해주세요.');
    //   return;
    // } finally {
    //   isOpenAIAPILoadingProgress = false;
    //   update([':openAIAPILoading']);
    // }

    /// 타입별로 샘플 가져오기
    recommendDatePlanMap = _getSampleRecommendDatePlan();

    logger.i(recommendDatePlanMap);

    /// 3. open ai api 의 장소 결과를 각각 카카오 로컬 api 로 요청하기
    try {
      isKakaoLocalAPILoadingProgress = true;
      update([':kakaoLocalAPILoading']);

      await requestRecommendPlaceDataDetailInfoAndParsing(recommendDatePlanMap, addressSearchController);
    } catch (e) {
      logger.e(e);
      showToast('장소 검색 도중 오류가 발생하였습니다. 잠시 후 다시 시도해주세요.');
      return;
    } finally {
      isKakaoLocalAPILoadingProgress = false;
      update([':kakaoLocalAPILoading']);
    }

    /// 4. 데이터 저장
    String recommendDatePlanId = const Uuid().v4();

    recommendDatePlanMap['date'] = selectedDate.value;
    recommendDatePlanMap['baseAddress'] =
        AddressModel(
          id: recommendDatePlanId,
          address: addressSearchController.addressController.text,
          detailAddress: addressSearchController.detailAddressController.text,
          addressName: addressSearchController.addressNameController.text,
          latitude: addressSearchController.location?.latitude ?? 0,
          longitude: addressSearchController.location?.longitude ?? 0,
          createdAt: DateTime.now(),
          orderDate: DateTime.now(),
        ).toJson();

    recommendDatePlanMap['id'] = recommendDatePlanId;
    recommendDatePlanMap['userId'] = userCtrl.currentUser.uid;

    /// recommendDatePlanMap['createdAt'] = DateTime.now();
    /// recommendDatePlanMap['modifiedAt'] = Timestamp.fromDate(DateTime.now());
    /// 둘중 뭘로 해도 딱히 상관 없다.
    recommendDatePlanMap['createdAt'] = DateTime.now();
    recommendDatePlanMap['modifiedAt'] = DateTime.now();

    await FirebaseFirestore.instance
        .collection(FireStoreCollectionName.recommendDatePlan)
        .doc(recommendDatePlanId)
        .set(recommendDatePlanMap);

    /// 메인-캘린더 업데이트
    try {
      final mainCtrl = Get.find<MainController>();
      mainCtrl.updateDatePlanData(selectedDate.value);
    } catch (e) {
      /// 별다른 동작 없음
    }

    /// depth 1개 삭제
    Get.back();

    /// 5. 상세보기로 진입하기
    Get.toNamed(Routes.recommendPlanDetail, arguments: RecommendPlanModel.fromJson(recommendDatePlanMap));
  }

  /// @author 정준형
  /// @since 2025. 5. 14.
  /// @comment 수집한 데이터로 데이트 플랜 추천 요청
  ///
  Future<Map<String, dynamic>> _requestRecommendDatePlanToOpenAI(
    AddressSearchController addressSearchController,
  ) async {
    return openAiService.requestPlanRecommendResponse(
      weather:
          weatherData[selectedDate.value] != null
              ? weatherService.extractEssentialWeatherInfo(weatherData[selectedDate.value]!)
              : null,
      address: addressSearchController.addressController.text,
      preferredDateType: selectedPreferredDateType.value.label,
      age: userCtrl.currentUser.ageGroup?.label,
      dateStyle: userCtrl.currentUser.dateStyle?.map((e) => e.label).join(","),
    );
  }

  /// @author 정준형
  /// @since 2025. 5. 14.
  /// @comment 추천받은 장소의 상세 정보를 카카오 로컬 api 로 요청하기
  ///
  Future<void> requestRecommendPlaceDataDetailInfoAndParsing(
    Map<String, dynamic> recommendDatePlanMap,
    AddressSearchController addressSearchController,
  ) async {
    List<Map<String, dynamic>> datePlaces =
        (recommendDatePlanMap['date_places'] as List).map((e) => e as Map<String, dynamic>).toList();

    /// 카카오 api 로 조회한 장소 목록
    List<Map<String, dynamic>> detailPlaceInfoList = await Future.wait(
      datePlaces.map((place) async {
        Map<String, dynamic> detailInfo = await kakaoLocalService.getDetailPlaceInfoWithKeywordAndCategory(
          place,
          addressSearchController,
        );

        detailInfo['index'] = place['index'];

        return Future.value(detailInfo);
      }),
    );

    Map<int, Map<String, dynamic>> detailPlaceInfoMap = {};

    for (var detailPlaceInfo in detailPlaceInfoList) {
      detailPlaceInfoMap[detailPlaceInfo['index']!] = detailPlaceInfo;
    }

    /// 상세 정보가 있는 정보로 데이터 바꾸기
    datePlaces =
        datePlaces.map<Map<String, dynamic>>((e) {
          return detailPlaceInfoMap[e['index']] ?? {'noResult': true};
        }).toList();

    /// 검색 결과가 없는 장소는 제외
    recommendDatePlanMap['date_places'] =
        datePlaces.where((element) {
          return element['noResult'] != true;
        }).toList();
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment open ai api 비용을 아끼기 위하여 테스트 단계에서 사용하는 메소드
  ///
  Map<String, dynamic> _getSampleRecommendDatePlan() {
    switch (selectedPreferredDateType.value) {
      case PreferredDateType.chillCafeDate:
        return {
          "date_plan_title": "부산 북구 감성 카페 데이트",
          "why_recommend_dating_plans":
              "강한 비가 오는 날 실내에서 감성적인 시간을 보낼 수 있는 코스를 추천합니다. 맛집과 카페를 중심으로 한 데이트를 계획하여 편안하고 따뜻한 데이트를 즐길 수 있습니다.",
          "date_places": [
            {"index": 1, "keyword": "영화관", "category_code": "CT1"},
            {"index": 2, "keyword": "커피", "category_code": "CE7"},
            {"index": 3, "keyword": "디저트", "category_code": "FD6"},
          ],
        };
      case PreferredDateType.gourmetTourDate:
        return {
          "date_plan_title": "부산 덕천동 실내 맛집 탐방 데이트",
          "why_recommend_dating_plans": "부산 덕천동에서 흐린 날씨에 적합한 실내 맛집 및 문화시설을 중심으로 한 데이트 코스를 추천합니다.",
          "date_places": [
            {"index": 1, "keyword": "고기", "category_code": "FD6"},
            {"index": 2, "keyword": "커피", "category_code": "CE7"},
            {"index": 3, "keyword": "영화", "category_code": "CT1"},
          ],
        };
      // case PreferredDateType.culturalDate:
      //   break;
      // case PreferredDateType.activeDate:
      //   break;
      // case PreferredDateType.healingDate:
      //   break;
      default:
        return {
          "date_plan_title": "부산 북구 감성 카페 데이트",
          "why_recommend_dating_plans":
              "강한 비가 오는 날 실내에서 감성적인 시간을 보낼 수 있는 코스를 추천합니다. 맛집과 카페를 중심으로 한 데이트를 계획하여 편안하고 따뜻한 데이트를 즐길 수 있습니다.",
          "date_places": [
            {"index": 1, "keyword": "영화관", "category_code": "CT1"},
            {"index": 2, "keyword": "커피", "category_code": "CE7"},
            {"index": 3, "keyword": "디저트", "category_code": "FD6"},
          ],
        };
    }
  }
}
