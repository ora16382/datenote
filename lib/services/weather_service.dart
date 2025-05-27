

import 'dart:collection';

import 'package:datenote/main.dart';
import 'package:datenote/util/api/weather_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../util/functions/common_functions.dart';

class WeatherService extends GetxService {
  WeatherAPI weatherAPI = WeatherAPI();

  /// @author 정준형
  /// @since 2025. 4. 29.
  /// @comment 지금 현재 날씨를 가져온다.
  ///
  Future<Map<String, dynamic>> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await weatherAPI.fetchWeather(
      latitude: latitude,
      longitude: longitude,
    );

    if (response.isOk) {
      return response.body;
    } else {
      throw Exception('weather api 요청중 에러가 발생하였습니다.${response.body}');
    }
  }

  Future<Map<DateTime, Map<String, dynamic>>> fetchWeatherForDate({
    required double latitude,
    required double longitude,
  }) async {
    final response = await weatherAPI.fetchWeatherForDate(
      latitude: latitude,
      longitude: longitude,
    );

    if (response.isOk) {
      final body = response.body;

      final List<dynamic> forecastList = body['list'];

      /// 같은 날짜 데이터만 모으기
      LinkedHashMap<DateTime, Map<String, dynamic>> weatherData = LinkedHashMap(
        equals: isSameDay,
        hashCode: getHashCode,
      );

      /// 12시~15시 데이터 먼저 찾기
      /// 	데이트 시간대로 제일 일반적이기 때문
      for (Map<String, dynamic> forecast in forecastList) {
        final String dateTimeString = forecast['dt_txt'];
        final DateTime forecastDateTime = DateTime.parse(dateTimeString);
        if (forecastDateTime.hour >= 12 && forecastDateTime.hour <= 15) {
          weatherData[forecastDateTime] = forecast;
        }
      }

      for (int i = 0; i < 6; i++) {
        DateTime targetDate = DateTime.now().add(Duration(days: i));

        /// 6일 이내 데이터중 빠진게 있다면(12~15시 데이터가 없는 날짜가 있다면)
        if (!weatherData.containsKey(targetDate)) {
          final sameDayForecasts =
              forecastList.where((forecast) {
                final String dateTimeString = forecast['dt_txt'];
                final DateTime forecastDateTime = DateTime.parse(
                  dateTimeString,
                );
                return isSameDay(forecastDateTime, targetDate);
              }).toList();

          /// 가장 가까운 시간대 데이터 찾기
          sameDayForecasts.sort((a, b) {
            final aTime = DateTime.parse(a['dt_txt']);
            final bTime = DateTime.parse(b['dt_txt']);

            /// 기준 12시
            /// aTime.hour → a라는 예보의 시간 (예: 9시면 9, 15시면 15)
            /// 12 → 기준 시간 (우리가 "12시"를 최우선 기준으로 삼음)
            ///
            ///   (aTime.hour - 12).abs() → aTime이 12시랑 얼마나 차이나는지 계산
            /// (음수든 양수든 상관없이 거리를 보는 거니까 절댓값(abs) 사용
            final aDiff = (aTime.hour - 12).abs();
            final bDiff = (bTime.hour - 12).abs();
            return aDiff.compareTo(bDiff);
          });

          weatherData[targetDate] = sameDayForecasts.firstOrNull;
        }
      }

      return weatherData;
    } else {
      throw Exception('weather api 요청중 에러가 발생하였습니다. ${response.body}');
    }
  }


   /// @author 정준형
    /// @since 2025. 5. 14.
    /// @comment 날씨 정보를 프롬프트에 필요한 데이터로 추출한다.
    ///
  Map<String, dynamic> extractEssentialWeatherInfo(Map<String, dynamic> raw) {
    final weather = raw['weather'][0];

    return {
      'temperature': raw['main']['temp'],
      'feels_like': raw['main']['feels_like'],
      'weather_main': weather['main'],
      'weather_description': weather['description'],
      'humidity': raw['main']['humidity'],
      'wind_speed': raw['wind']['speed'],
      'cloud_percentage': raw['clouds']['all'],
      'visibility': raw['visibility'],
    };
  }

}
