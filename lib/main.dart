import 'dart:async';

import 'package:datenote/modules/user/auth/auth_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/services/kakao_local_service.dart';
import 'package:datenote/services/open_ai_service.dart';
import 'package:datenote/services/weather_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';

import 'constant/theme/app_theme.dart';
import 'firebase_options.dart';
import 'modules/user/user_controller.dart';

Logger logger = Logger();

Future<void> main() async {
  /// UI 예외 처리 (위젯 에러는 runZonedGuarded 와 별도)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // logger.e(details);
    /// firebase crashlytics 등 처리
  };

  await runZonedGuarded(
    () async {
      /// runZonedGuarded - 전체 앱의 오류를 잡는 안전망 역할.
      /// Isolate.spawn ← 다른 영역 (다른 Zone) 이기 때문에 ReceivePort 로 받던 처리해야함
      /// runZonedGuarded 내에서 처리 못함

      /// 위젯 바인딩
      WidgetsFlutterBinding.ensureInitialized();

      await initializeDateFormatting('ko'); // 한글 요일 쓰려면 꼭 필요

      /// Jiffy - 날짜 및 시간 관련 라이브러리 로케일 설정
      await Jiffy.setLocale(Get.deviceLocale?.languageCode ?? 'ko');

      /// .env 파일 로드
      await dotenv.load(fileName: ".env");

      /// firebase 초기화
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      /// GetStorage 초기화
      await GetStorage.init();

      runApp(const DateNoteApp());
    },
    (error, stack) async {
      /// runZonedGuarded()를 사용하면 Zone.current.handleUncaughtError도 설정 됨.
      /// =>
      /// 이 block 내부에서 발생하는 모든 uncaught Future error는
      /// 자동으로 내부 Zone의 handleUncaughtError로 전달된다.
      /// 따라서 내가 직접 Zone.current.handleUncaughtError = ...처럼 설정할 필요 없음

      logger.e(error);
      stack.printInfo();
      /// firebase crashlytics 등 처리
    },
  );
}

class DateNoteApp extends StatelessWidget {
  const DateNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DATENOTE',
      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('ko', 'KR'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(UserController(), permanent: true);
        Get.put(AuthController(), permanent: true);

        /// service
        Get.put(OpenAiService(), permanent: true);
        Get.put(KakaoLocalService(), permanent: true);
        Get.put(WeatherService(), permanent: true);
      }),
      theme: themeData,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        // FormBuilderLocalizations.delegate,
      ],
    );
  }
}
