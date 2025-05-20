// lib/services/openai_service.dart

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../main.dart' show logger;
import '../util/api/open_ai_api.dart';

class OpenAiService extends GetxService {
  final OpenAiAPI _openAiAPI = OpenAiAPI();

  Future<Map<String, dynamic>> requestPlanRecommendResponse({
    required Map<String, dynamic>? weather,
    required String address,
    required String preferredDateType,
    String? dateStyle,
    String? age,
  }) async {
    Response response = await _openAiAPI.requestPlanRecommendResponse(
      weather: weather,
      address: address,
      preferredDateType: preferredDateType,
      dateStyle: dateStyle ?? '',
      age: age ?? '연령대 모름',
    );

    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(
        (response.body
            as Map<String, dynamic>)['output'][0]['content'][0]['text'],
      );
    } else {
      logger.i(response.statusCode);
      logger.i(response.body);
      throw Exception('open api 요청중 에러가 발생하였습니다. ${response.body}');
    }
  }
}
