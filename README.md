# 📔 DateNote

> Flutter · Firebase · OpenAI · GetX 기반 AI 데이트 플래너 & 기록 앱
> 

---

## ✨ 주요 기능

| # | 기능 | 설명 |
| --- | --- | --- |
| 1 | **AI 데이트 코스 추천** | 위치·날씨·취향(나이·데이트 스타일 등)을 GPT 프롬프트로 전송해 맞춤 코스를 생성합니다. |
| 3 | **주소 관리** | 자주 가는 장소를 현재 위치, 또는 다음 주소 API 를 이용하여 추가,
무한 스크롤로 관리하며 코스 생성 시 바로 선택 가능. |
| 4 | **데이트 히스토리** | 다녀온 데이트를 사진, 영상·메모와 함께 기록 |
| 5 | **오프라인 캐싱 & 페이징** | Firestore + `infinite_scroll_pagination`로 부드러운 무한 스크롤 구현. |
| 6 | **모듈형 GPT 프롬프트 구조** | 코어 로직과 UI를 분리하여 프롬프트만 교체해도 기능 확장이 가능하도록 설계. |

---

## 🏗️ 기술 스택

- **Flutter 3.x / Dart 3.x** : 멀티 플랫폼 UI
- **GetX** : 상태·라우트·DI·페이징
- **Firebase** : Auth(구글), Cloud Firestore, Cloud Functions, Storage
- **OpenAI API** : Chat/Responses API (JSON response format)
- **Model** : freezed, build_runner, json_serializable
- **Other Packages** : geolocator, get_storage, reorderables, video_player 외 상세 목록은 [`pubspec.yaml`](https://chatgpt.com/c/pubspec.yaml) 참고

---

## 🗂️ 폴더 구조

```
lib/
 ├─ app/            # 공통 위젯·유틸·theme
 ├─ modules/
 │   ├─ auth/       # 로그인 & 프로필
 │   ├─ address/    # 주소 CRUD + 검색
 │   ├─ planner/    # GPT 데이트 플래너
 │   ├─ history/    # 데이트 기록(히스토리)
 │   └─ common/     # 공용 모델 & service
 ├─ data/
 │   ├─ models/     # freezed 데이터 모델
 │   ├─ services/   # Firestore, OpenAI, Kakao Local API 등
 │   └─ repositories/
 └─ main.dart       # Firebase 초기화 & GetMaterialApp
functions/          # TypeScript Cloud Functions (OpenAI Proxy 등)
assets/             # 이미지 · 번들 리소스

```

---

## 🛠️ 구현 핵심 포인트

| 카테고리 | 구현 요약 | 대표 파일(예시) |
| --- | --- | --- |
| **동시성 제어 (업로드 Progress)** | `synchronized` 패키지의 `Lock.synchronized` 블록으로 다중 파일 업로드 진행률 race condition 방지 | `lib/modules/history/controller/dating_history_edit_controller.dart` |
| **Firebase 트랜잭션 관리** | Firestore `runTransaction` 안에서 `arrayUnion / arrayRemove`로 좋아요 토글, 원자적 데이터 업데이트 | `lib/modules/community/controller/community_controller.dart` |
| **이미지·영상 압축 & 상태 모달** | `image_compress` / `video_compress` 로 용량 축소 → Storage 업로드, 진행률 다이얼로그 & 썸네일 미리보기 | `lib/modules/history/controller/dating_history_edit_controller.dart` |
| **최소 UI 리빌드** | `GetBuilder(id)` + `controller.update(['id'])` 와 `Obx` 로 필요한 위젯만 갱신해 렌더 비용 최소화 | `lib/modules/history/view/dating_history_edit_view.dart` |

---

## 🔧 로컬 실행 방법

1. **환경 준비**
    
    ```bash
    # Flutter 3.x (stable)
    flutter --version
    
    ```
    
2. **레포 클론 & 의존성 설치**
    
    ```bash
    git clone https://github.com/ora16382/datenote.git
    cd datenote
    flutter pub get
    
    ```
    
3. **Firebase 설정**
    - Firebase 콘솔에서 iOS/Android 앱 등록 후 `google-services.json`, `GoogleService-Info.plist`를 각 플랫폼 폴더에 복사
    - 환경 변수 (.env 예시)
        
        ```
        OPENAI_API_KEY=your_openapi_key
        KAKAO_API_KEY=your_kakao_api_key
        WEATHER_API_KEY=your_weather_api_key
        ```
        
4. **Cloud Functions (선택)**
    
    ```bash
    cd functions
    npm install
    npm run serve   # 로컬 에뮬레이터
    
    ```
    
5. **런 & 빌드**
    
    ```bash
    flutter run   # 디바이스 선택
    flutter build apk --release
    
    ```
    

---

## 📸 스크린샷

---

## 🛣️ 로드맵

| 버전 | 목표 시기* | 핵심 항목 | 상세 |
| --- | --- | --- | --- |
| **v1.0.1** | 2025‑05 (완료) | 🎉 초기 릴리스 | - AI 데이트 코스/대화·음악·명언 추천- 주소 관리 CRUD & 무한 스크롤- 데이트 히스토리 기록 & YouTube 자동 재생- 오프라인 캐싱 & 페이징- 모듈형 GPT 프롬프트 구조- 구글 로그인 & Firestore 보안 규칙 |
| **v1.0.1** | 2025‑05 (완료) | Kakao Local 통합 | - 현 위치 기반 맛집/카페 자동 추천- Kakao 지도 좌표 변환 & 거리 계산 |
| **v1.0.2 (현재)** | 2025‑05 (완료) | 커뮤니티 탭 | - 데이트 코스, 기록 공유/좋아요/북마크- Firestore 트랜잭션 |
| v1.3 | 2025‑06 | 기능 확장 | 커뮤니티 댓글 기능 추가, 지도 관련 기능 추가(즐겨찾는 플레이스, 장소 검색 등) |
| v1.4 | 2025‑06 | 기능 개선 | 커뮤니티 기능 관련 FCM & Cloud Functions 알림 |

---

## 🙋‍♂️ 개발자

- GitHub: [@ora16382](https://github.com/ora16382)
- Email: [ora16382@email.com](mailto:ora16382@email.com)