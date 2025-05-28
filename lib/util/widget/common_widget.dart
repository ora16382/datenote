import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:image_picker/image_picker.dart';

Widget buildCloseBtn(VoidCallback? onPressed) {
  return IconButton(
    icon: Image.asset(
      'assets/images/icon/close.png',
      width: 28,
      height: 28,
      color: const Color(0XFF333333),
    ),
    onPressed: onPressed,
  );
}

Widget buildBackBtn(VoidCallback? onPressed) {
  return IconButton(
    icon: Image.asset(
      'assets/images/icon/chevron_left.png',
      width: 28,
      height: 28,
      color: const Color(0XFF333333),
    ),
    onPressed: onPressed,
  );
}

/// @author 정준형
/// @since 2025. 4. 29.
/// @comment Shimmer+cacheNetworkImage 를 활용한 이미지 위젯
///
Widget buildNetworkImage({
  double width = 80.0,
  double height = 80.0,
  required String imagePath,
  BoxFit boxFit = BoxFit.cover,
  bool isVideoThumbnail = false,
}) {
  return FancyShimmerImage(
    imageUrl: imagePath,
    width: width,
    height: height,
    boxFit: boxFit,
    shimmerBaseColor: Colors.grey.shade300,
    shimmerHighlightColor: Colors.grey.shade100,
    shimmerBackColor: Colors.white,

    errorWidget: defaultThumbnailImage(
      width: width,
      height: height,
      isVideoThumbnail: isVideoThumbnail,
      boxFit: BoxFit.cover,
    ),
  );
}

/// @author 정준형
/// @since 2025. 4. 29.
/// @comment 이미지 에러시 사용되는 기본 썸네일
///
Widget defaultThumbnailImage({
  double width = 80.0,
  double height = 80.0,
  BoxFit boxFit = BoxFit.none,
  bool isVideoThumbnail = false,
}) {
  return Image.asset(
    'assets/images/icon/default_thumbnail_image_icon.png',
    width: width,
    height: height,
    fit: boxFit,
  );
}


// ignore: slash_for_doc_comments
/**
 * @author JungJunHyung
 * @since 2022/08/11
 * @comment 파일 이미지 위젯
 **/
Widget buildFileImage({
  double width = 80.0,
  double height = 80.0,
  required XFile file,
  boxFit = BoxFit.cover,
}) {
  return Image.file(
    File(file.path ?? ''),
    width: width,
    height: height,
    fit: boxFit,
    errorBuilder: (context, error, stackTrace) {
      /// 에러시 이미지 변경 필요
      return defaultThumbnailImage(width: width, height: height);
    },
  );
}