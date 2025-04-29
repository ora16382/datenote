import 'package:datenote/constant/enum/weather_type.dart';
import 'package:datenote/modules/user/address/search/address_search_controller.dart';
import 'package:datenote/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../main.dart';

class MainController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();

    fetchWeather();
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

        weatherInfo = await weatherService.fetchWeather(
          latitude: position.latitude,
          longitude: position.longitude,
        );

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
}
