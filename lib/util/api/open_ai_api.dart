// lib/services/openai_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../../main.dart' show logger;

class OpenAiAPI extends GetConnect {
  static const String _baseUrl = 'https://api.openai.com/v1';
  final defaultHeader = {
    'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
    'Content-Type': 'application/json',
  };

  OpenAiAPI() {
    httpClient.baseUrl = _baseUrl;
  }

  Future<Response> requestPlanRecommendResponse({
    required Map<String, dynamic>? weather,
    required String address,
    required String preferredDateType,
    required String age,
    String? dateStyle,
  }) {
    final body = {
      "model": "gpt-4o",
      "instructions":
      "당신은 사용자의 기분과 상황, 날씨를 바탕으로 적절한 데이트 플랜을 추천해주는 현지 맞춤형 데이트 큐레이터입니다. 응답은 json으로 반환하며, 각 value에는 따옴표나 하이픈은 제거해주세요",
      "input":
      "다음 정보를 바탕으로 하루 동안의 데이트 코스를 추천해주세요.\n\n"
          "${weather != null ? '- 날씨: ${weather['weather_description']}, 기온 ${weather['temperature']}도, 체감 ${weather['feels_like']}도, 습도 ${weather['humidity']}%, 풍속 ${weather['wind_speed']}m/s, 구름량 ${weather['cloud_percentage']}%\n' : ''}"
          "- 지역: $address\n"
          "- 데이트 타입: $preferredDateType\n"
          "- 연령대: $age\n"
          "- 평소 선호하는 데이트 스타일: $dateStyle\n\n"
          "※ 아래 조건에 따라 장소 추천 시 사용할 키워드를 생성해주세요.\n"
          "- 장소 이름은 필요하지 않습니다. 카테고리 코드와 검색 키워드만 생성해주세요.\n"
          "- 키워드는 반드시 **한 단어만 사용**해주세요. (예: 초밥, 커피, 산책 등)\n"
          "- 장소 수는 2~5개로 제한해주세요.\n"
          "- 추천 장소는 가급적 **다음 카테고리 중심(우선순위 순)**으로 선택해주세요: AT4, CT1, FD6, CE7\n"
          "- 날씨가 나쁠 경우(흐림, 비, 눈 등) 실내 장소만 추천해주세요. 예: 영화관, 전시, 공연\n"
          "- 날씨가 좋을 경우(맑음, 구름 적음 등) 야외 장소도 포함해도 됩니다. 예: 산책, 전망, 공원\n\n"
          "[키워드 제한 목록]\n"
          "- 음식점 (FD6): 파스타, 고기, 초밥, 분식, 샐러드, 디저트\n"
          "- 카페 (CE7): 커피, 쥬스, 베이커리, 디저트\n"
          "- 문화시설 (CT1): 영화, 전시, 공연\n"
          "- 관광명소 (AT4): 공원, 산책, 전망\n\n"
          "카테고리 코드는 Kakao Local API의 분류 코드를 사용하며, 아래 표를 참고해주세요:\n"
          "MT1: 대형마트\n"
          "CS2: 편의점\n"
          "PS3: 어린이집, 유치원\n"
          "SC4: 학교\n"
          "AC5: 학원\n"
          "PK6: 주차장\n"
          "OL7: 주유소, 충전소\n"
          "SW8: 지하철역\n"
          "BK9: 은행\n"
          "CT1: 문화시설\n"
          "AG2: 중개업소\n"
          "PO3: 공공기관\n"
          "AT4: 관광명소\n"
          "AD5: 숙박\n"
          "FD6: 음식점\n"
          "CE7: 카페\n"
          "HP8: 병원\n"
          "PM9: 약국\n",
      "text": {
        "format": {
          "type": "json_schema",
          "name": "date_plan_recommend",
          "schema": {
            "type": "object",
            "properties": {
              "date_plan_title": {"type": "string"},
              "why_recommend_dating_plans": {"type": "string"},
              "date_places": {
                "type": "array",
                "items": {
                  "type": "object",
                  "properties": {
                    "index" : {"type": "integer"},
                    "keyword": {"type": "string"},
                    "category_code": {"type": "string"},
                  },
                  "required": ["index","keyword", "category_code"],
                  "additionalProperties": false,
                },
              },
            },
            "required": [
              "date_plan_title",
              "why_recommend_dating_plans",
              "date_places",
            ],
            "additionalProperties": false,
          },
        },
      },
    };

    return post('/responses', body, headers: defaultHeader);
  }
}
