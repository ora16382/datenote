import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

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
    'assets/images/image/default_thumbnail_image.png',
    width: width,
    height: height,
    fit: boxFit,
  );
}
