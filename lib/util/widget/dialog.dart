import 'package:datenote/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';

/// @author JungJunHyung
/// @since 2022/08/08
/// @comment 확인 다이얼로그 발생 메서드 (버튼 2개)
///
Future<bool> showTwoButtonDialog({
  String? title,
  required String contents,
  required String positiveButton,
  required String negativeButton,
  required GestureTapCallback? positiveCallBack,
  GestureTapCallback? negativeCallBack,
  bool isDismissible = true,
  TextAlign textAlign = TextAlign.center,
}) async {
  return await Get.dialog<bool>(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Text(title, style: Get.textTheme.titleMedium),
                  ),
                Text(contents, style: Get.textTheme.titleSmall),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            negativeCallBack ??
                            () {
                              Get.back();
                            },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          backgroundColor: AppColors.onSecondary,
                        ),
                        child: Text(negativeButton),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: positiveCallBack,
                        child: Text(positiveButton),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ) ??
      false;
}

// ignore: slash_for_doc_comments
/**
 * @author JungJunHyung
 * @since 2022/08/08
 * @comment 이미지, 비디오 등 업로드시 프로그래스 다이얼로그를 띄우기 위한 메서드
 **/
Future<void> showUploadProgressDialog({
  required RxString title,
  required RxDouble percent,
  bool isDismissible = true,
}) async {
  return await Get.dialog(
      WillPopScope(
        onWillPop: () async {
          /// 프로그래스 도중 다른 동작 못하게 차단
          return false;
        },
        child: Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 32),
                height: 32,
                child: SpinKitFadingCircle(color: AppColors.primary),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                alignment: Alignment.center,
                child: Obx(() {
                  return Text(title.value,
                      style: Get.textTheme.titleSmall,
                      textAlign: TextAlign.center);
                }),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(() {
                  return GFProgressBar(
                    percentage: percent.value,
                    lineHeight: 16.0,
                    backgroundColor: AppColors.grey,
                    progressBarColor: AppColors.primary,
                    child: Text(
                      "${(percent.value * 100).floor()}%",
                      textAlign: TextAlign.center,
                        style: Get.textTheme.titleSmall?.copyWith(color: Colors.white, height: 1.2),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: isDismissible);
}

// ignore: slash_for_doc_comments
/**
 * @author JungJunHyung
 * @since 2022/08/23
 * @comment 비디오 압축 시 프로그래스 다이얼로그를 띄우기 위한 메서드
 **/
Future<void> showCompressProgressDialog({
  required RxString title,
  required RxDouble percent,
  bool isDismissible = true, required void Function() hideBtnCallback,
}) async {

  return await Get.dialog(
      WillPopScope(
        onWillPop: () async {
          /// 프로그래스 도중 다른 동작 못하게 차단
          return false;
        },
        child: Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 32),
                height: 32,
                child: Image.asset(
                  'assets/images/icon/movie_zip_icon.png',
                  width: 32,
                  height: 32,
                  color: AppColors.primary,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                alignment: Alignment.center,
                child: Obx(() {
                  return Text(title.value,
                      style: Get.textTheme.titleSmall,
                      textAlign: TextAlign.center);
                }),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(() {
                  return GFProgressBar(
                    percentage: (percent.value / 100) > 1.0 ? 1.0 : percent.value / 100,
                    lineHeight: 16.0,
                    backgroundColor: AppColors.grey,
                    progressBarColor: AppColors.primary,
                    child: Text(
                      "${percent.value.floor()}%",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleSmall?.copyWith(color: Colors.white, height: 1.2),
                    ),
                  );
                }),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: hideBtnCallback,
                  child: Text('숨기기'),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: isDismissible);
}
