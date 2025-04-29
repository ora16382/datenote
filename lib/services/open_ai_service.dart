// lib/services/openai_service.dart


import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../util/api/open_ai_api.dart';

class OpenAiService extends GetxService {
  final OpenAiAPI _openAiAPI = OpenAiAPI();

  Future<Map<String, dynamic>> recommendMusicAndWise({
    required String prompt,
    required String mood,
    required String age,
    required String musicGenre,
  }) async {
    Response response = await _openAiAPI.requestResponse(prompt: prompt, mood: mood, age: age, musicGenre: musicGenre);

    if(response.statusCode == HttpStatus.ok){
      return jsonDecode((response.body as Map<String, dynamic>)['output'][0]['content'][0]['text']);
    } else {
      throw Exception('open api 요청중 에러가 발생하였습니다.${response.body}');
    }
  }
}
