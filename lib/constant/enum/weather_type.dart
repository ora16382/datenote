import 'package:flutter/material.dart';

enum WeatherType {
  clear('맑은 날이에요! 야외 데이트 어때요?',Icons.wb_sunny), // 맑음
  cloudy('구름이 조금 있지만, 데이트하기 좋은 날이에요!', Icons.cloud), // 흐림
  rain('비가 와요. 실내 데이트를 추천해요.', Icons.umbrella), // 비
  snow('눈 오는 로맨틱한 하루! 따뜻하게 입어요!', Icons.ac_unit), // 눈
  fog('시야가 안 좋아요. 실내에서 즐기는 데이트를 추천해요.', Icons.foggy); // 안개/먼지

  final String recommendComment;
  final IconData iconData;
  const WeatherType(this.recommendComment, this.iconData);
}

WeatherType mapDescriptionToWeatherType(String description) {
  if (description.contains('맑음')) {
    return WeatherType.clear;
  } else if (description.contains('구름') || description.contains('흐림')) {
    return WeatherType.cloudy;
  } else if (description.contains('비')) {
    return WeatherType.rain;
  } else if (description.contains('눈')) {
    return WeatherType.snow;
  } else if (description.contains('안개') || description.contains('연무') || description.contains('황사')) {
    return WeatherType.fog;
  } else {
    return WeatherType.clear; // 기본값
  }
}
