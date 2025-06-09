// lib/services/openai_service.dart

import 'dart:math';

import 'package:datenote/models/address/address_model.dart';
import 'package:datenote/modules/user/address/search/address_search_controller.dart';
import 'package:datenote/util/api/kakao_local_api.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

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

    if (response.statusCode == HttpStatus.ok) {
      if (response.body['documents'][0]['road_address'] != null) {
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

  Future<Map<String, dynamic>> requestConvertingAddressesToCoordinates({required String address}) async {
    Response response = await _kakaoLocalApi.requestConvertingAddressesToCoordinates(address: address);

    if (response.statusCode == HttpStatus.ok) {
      /// 도로명 리턴
      return response.body['documents'][0];
    } else {
      throw Exception('kakao local api 요청중 에러가 발생하였습니다.${response.body}');
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 16.
  /// @comment 키워드와 카테고리를 이용하여 장소 검색 요청
  ///
  Future<Map<String, dynamic>> getDetailPlaceInfoWithKeywordAndCategory(
    Map<String, dynamic> place,
    AddressSearchController addressSearchController,
  ) async {
    Response response = await _kakaoLocalApi.requestPlaceDetailInfoWithKeywordAndCategory(
      place: place,
      x: addressSearchController.location!.longitude.toString(),
      y: addressSearchController.location!.latitude.toString(),
    );

    if (response.statusCode == HttpStatus.ok) {
      List<Map<String, dynamic>> documents =
          (response.body['documents'] as List).map((e) => e as Map<String, dynamic>).toList();

      if (documents.isNotEmpty) {
        /// 결과중 무작위로 추천
        return documents[Random().nextInt(documents.length)];
      } else {
        /// 결과가 없을 경우
        response = await _kakaoLocalApi.requestPlaceDetailInfoWithCategory(
          place: place,
          x: addressSearchController.location!.longitude.toString(),
          y: addressSearchController.location!.latitude.toString(),
        );

        if (response.statusCode == HttpStatus.ok) {
          List<Map<String, dynamic>> documents =
              (response.body['documents'] as List).map((e) => e as Map<String, dynamic>).toList();

          if (documents.isNotEmpty) {
            /// 결과중 무작위로 추천
            return documents[Random().nextInt(documents.length)];
          } else {
            /// 그래도 결과가 없을 경우
            /// 결과 없음 리턴
            return {'noResult': true};
          }
        } else {
          throw Exception('kakao local api 요청중 에러가 발생하였습니다.${response.body}');
        }
      }
    } else {
      throw Exception('kakao local api 요청중 에러가 발생하였습니다.${response.body}');
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 키워드를 이용하여 장소 목록 검색
  ///
  Future<Map<String, dynamic>> getPlaceListWithKeyword({required String keyword, required AddressModel addressModel, required int page}) async {
    Response response = await _kakaoLocalApi.requestPlaceListWithKeyword(
      keyword: keyword,
      x: addressModel.longitude.toString(),
      y: addressModel.latitude.toString(),
      page: page.toString(),
    );

    if (response.statusCode == HttpStatus.ok) {
      return response.body;
    } else {
      throw Exception('kakao local api 요청중 에러가 발생하였습니다.${response.body}');
    }
  }
}
