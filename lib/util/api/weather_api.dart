// lib/services/openai_service.dart
import 'package:datenote/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class WeatherAPI extends GetConnect {
  final String _apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/';

  WeatherAPI() {
    httpClient.baseUrl = _baseUrl;
  }

  /// @author 정준형
  /// @since 2025. 4. 29.
  /// @comment 지금 현재 날씨를 가져온다.
  ///
  Future<Response> fetchWeather({
    required double latitude,
    required double longitude,
  }) {
    return get(
      'weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric&lang=kr',
    );
  }

  /// @author 정준형
  /// @since 2025. 4. 29.
  /// @comment 일주일 이내의 원하는 날짜 날씨 정보를 가져온다.
  ///
  Future<Response> fetchWeatherForDate({
    required double latitude,
    required double longitude,
  }) async {
    print('DEBUG API KEY: $_apiKey');
    return get(
      'forecast?lat=$latitude&lon=$longitude&exclude=minutely,hourly,current,alerts&appid=$_apiKey&units=metric&lang=kr',
    );
  }
}
