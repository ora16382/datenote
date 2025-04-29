import 'dart:async';

import 'package:datenote/modules/user/auth/auth_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/services/kakao_local_service.dart';
import 'package:datenote/services/open_ai_service.dart';
import 'package:datenote/services/weather_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import 'constant/theme/app_theme.dart';
import 'firebase_options.dart';
import 'modules/user/user_controller.dart';

Logger logger = Logger();

Future<void> main() async {
  await runZonedGuarded(
    () async {
      /// runZonedGuarded - 전체 앱의 오류를 잡는 안전망 역할.

      /// 위젯 바인딩
      WidgetsFlutterBinding.ensureInitialized();

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
      logger.e(error);
      stack.printInfo();
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
    );
  }
}
