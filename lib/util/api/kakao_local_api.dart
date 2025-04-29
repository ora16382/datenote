// lib/services/openai_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class KakaoLocalApi extends GetConnect {
  static const String _baseUrl = 'https://dapi.kakao.com/v2';
  final defaultHeader = {
    'Authorization': 'KakaoAK ${dotenv.env['KAKAO_API_KEY']}',
  };

  KakaoLocalApi(){
    httpClient.baseUrl = _baseUrl;
  }

  /// 좌표를 주소로 변환
  Future<Response> requestConvertingCoordinatesToAddresses({
    required String x,
    required String y,
    String? inputCoord,
  }) {


    return get('/local/geo/coord2address.json', query: {
      'x': x,
      'y': y,
      'input_coord': inputCoord ?? 'WGS84',
    }, headers: defaultHeader);
  }

  /// 주소를 좌표로 변환
  Future<Response> requestConvertingAddressesToCoordinates({required String address}) {
    return get('/local/search/address.json', query: {
      'query': address,
    }, headers: defaultHeader);
  }
}
