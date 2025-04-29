// lib/services/openai_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class OpenAiAPI extends GetConnect {
  static const String _baseUrl = 'https://api.openai.com/v1';
  final defaultHeader = {
    'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
    'Content-Type': 'application/json',
  };

  OpenAiAPI(){
    httpClient.baseUrl = _baseUrl;
  }

  Future<Response> requestResponse({
    required String prompt,
    required String mood,
    required String age,
    required String musicGenre,
  }) {
    final body = {
      "model": "gpt-4o",
      "instructions": "당신은 주어진 내용을 바탕으로 사용자의 기분을 파악하여 그에 알맞는 음악과 명언을 추천해주는 심리 치유사입니다.응답 json 각 value 에는 따옴표나 하이픈은 제거해줘",
      "input": "다음은 사용자가 작성한 일기 내용과 정보야. 이 정보를 바탕으로 감정에 맞는 음악과 위로가 되는 명언을 추천해줘."
          "\n- 일기 본문: $prompt}"
          "\n- 연령대: $age"
          "\n- 음악 취향: $musicGenre"
          "\n- 기분: $mood}",
      "text": {
        "format" : {
          "type": "json_schema",
          "name": "music_recommend",
          "schema": {
            "type": "object",
            "properties": {
              "recommendMusic": {
                "type": "string",
                "description": "추천 음악 제목"
              },
              "recommendMusicArtist": {
                "type": "string",
                "description": "추천 음악의 가수 이름"
              },
              "recommendWise": {
                "type": "string",
                "description": "위로가 되는 명언"
              },
              "recommendWiseWriter": {
                "type": "string",
                "description": "명언을 말한 사람의 이름"
              }
            },
            "required": [
              "recommendMusic",
              "recommendMusicArtist",
              "recommendWise",
              "recommendWiseWriter"
            ],
            "additionalProperties": false
          }
        }
      }
    };

    return post('/responses', body, headers: defaultHeader);
  }
}
