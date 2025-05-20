import 'package:datenote/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  return await Get.dialog<bool>(
        Dialog(
          child: Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0XFF333333),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Text(
                    contents,
                    textAlign: textAlign,
                    style: const TextStyle(
                      color: Color(0XFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap:
                            negativeCallBack ??
                            () {
                              Get.back();
                            },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                            ),
                            border: Border(
                              left: BorderSide(color: Color(0XFFE6E6E6)),
                              top: BorderSide(color: Color(0XFFE6E6E6)),
                              right: BorderSide(
                                width: 1,
                                color: Color(0XFFE6E6E6),
                              ),
                              bottom: BorderSide(color: Color(0XFFE6E6E6)),
                            ),
                          ),
                          child: Text(
                            negativeButton,
                            style: const TextStyle(
                              color: Color(0XFFEE0000),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: positiveCallBack,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                            ),
                            border: Border(
                              left: BorderSide(color: Color(0XFFE6E6E6)),
                              top: BorderSide(color: Color(0XFFE6E6E6)),
                              right: BorderSide(
                                width: 1,
                                color: Color(0XFFE6E6E6),
                              ),
                              bottom: BorderSide(color: Color(0XFFE6E6E6)),
                            ),
                          ),
                          child: Text(
                            positiveButton,
                            style: const TextStyle(
                              color: Color(0XFF007AFF),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: isDismissible,
      ) ??
      false;
}
