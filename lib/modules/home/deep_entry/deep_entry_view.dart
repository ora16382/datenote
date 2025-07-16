import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/util/link/deep_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../util/app_color.dart';

class DeepEntryView extends StatelessWidget {
  const DeepEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      final ctrl = Get.find<DeepLinkController>();

      logger.i('test');
      // 앱이 cold start 상태일 경우
      if (ctrl.isColdStart) {
        Get.offAllNamed(Routes.splash);
      } else {
        /// 앱이 warm start 상태일 경우
        /// 현재 페이지 뒤로가기, DeepLinkController 의 resume 에서 라우팅 처리한다.
        Get.back();
      }
    });

    return const Scaffold(body: Center(child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0)));
  }
}
