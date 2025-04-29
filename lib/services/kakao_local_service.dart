// lib/services/openai_service.dart


import 'dart:convert';

import 'package:datenote/main.dart';
import 'package:datenote/util/api/kakao_local_api.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../util/api/open_ai_api.dart';

class KakaoLocalService extends GetxService {
  final KakaoLocalApi _kakaoLocalApi = KakaoLocalApi();

  Future<Map<String, dynamic>> requestConvertingCoordinatesToAddresses({
    required String x,
    required String y,
    String? inputCoord,
  }) async {
    Response response = await _kakaoLocalApi.requestConvertingCoordinatesToAddresses(
      x: x,
      y: y,
      inputCoord: inputCoord,
    );

    if(response.statusCode == HttpStatus.ok){
      if(response.body['documents'][0]['road_address'] != null) {
        /// 도로명
        return response.body['documents'][0]['road_address'];
      } else {
        /// 지번 주소
        return response.body['documents'][0]['address'];
      }

    } else {
      throw Exception('kakao local api 요청중 에러가 발생하였습니다.${response.body}');
    }
  }

  Future<Map<String, dynamic>> requestConvertingAddressesToCoordinates({
    required String address
  }) async {
    Response response = await _kakaoLocalApi.requestConvertingAddressesToCoordinates(
        address: address
    );

    if(response.statusCode == HttpStatus.ok){
      /// 도로명 리턴
      return response.body['documents'][0];
    } else {
      throw Exception('kakao local api 요청중 에러가 발생하였습니다.${response.body}');
    }
  }
}
