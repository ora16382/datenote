import 'package:datenote/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

/// @author 정준형
/// @since 11/28/24
/// @comment 이미지와 관련된 메소드를 모아놓는 클래스
///
class ImageUtil {
  /// @author 정준형
  /// @since 11/28/24
  /// @comment 이미지 크롭
  static Future<CroppedFile?> cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '편집'.tr,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.black,
          activeControlsWidgetColor: AppColors.primary,
          cropFrameColor: Colors.white,
          hideBottomControls: false,
          statusBarColor: null,
          /// 정사각형 고정
          lockAspectRatio: true,

          /// 정사각형 초기 설정
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: '편집'.tr,
          minimumAspectRatio: 1.0, // 최소 비율 설정
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          cancelButtonTitle: '취소'.tr,
        ),
      ],
    );

    return croppedFile;
  }
}
