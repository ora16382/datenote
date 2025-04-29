import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class WeatherService extends GetxService {
  final String _apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await GetConnect().get(
      '$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric&lang=kr',
    );

    if (response.isOk) {
      return response.body;
    } else {
      throw Exception('weather api 요청중 에러가 발생하였습니다.${response.body}');
    }
  }
}
