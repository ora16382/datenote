import 'package:datenote/models/asset/asset_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

mixin ControllerWithVideoPlayer on GetxController {
  /// asset id : video player controller 맵
  final Map<String, VideoPlayerController> videoPlayerControllerMap = {};

  /// @author 정준형
  /// @since 2025. 5. 27.
  /// @comment 현재 asset 이 비디오일 경우 일시 정지
  ///
  void pauseCurrentVideoPlayer(PageController pageController, List<AssetModel> assets) {
    int currentPage = pageController.page?.round() ?? 0;

    videoPlayerControllerMap[assets[currentPage].id]?.pause();
  }
}
