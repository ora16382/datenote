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


  /// 키워드로 장소 검색
  Future<Response> requestPlaceListWithKeyword({required String keyword, required String x, required String y, required String page}) {
    return get('/local/search/keyword.json', query: {
      'x': x,
      'y': y,
      'page' : page,
      'size' : 10.toString(),
      'radius': 3000.toString(),
      'query': keyword,
      'sort': 'accuracy',
    }, headers: defaultHeader);
  }


  /// 키워드와 카테고리로 장소 검색
  Future<Response> requestPlaceDetailInfoWithKeywordAndCategory({required Map<String, dynamic> place, required String x, required String y}) {
    return get('/local/search/keyword.json', query: {
      'x': x,
      'y': y,
      'radius': 3000.toString(),
      'query': place['keyword'],
      'category_group_code': place['category_code'],
      'sort': 'distance',
    }, headers: defaultHeader);
  }

  /// 카테고리로 장소 검색
  Future<Response> requestPlaceDetailInfoWithCategory({required Map<String, dynamic> place, required String x, required String y}) {
    return get('/local/search/category.json', query: {
      'x': x,
      'y': y,
      'radius': 3000.toString(),
      'category_group_code': place['category_code'],
      'sort': 'distance',
    }, headers: defaultHeader);
  }
}
