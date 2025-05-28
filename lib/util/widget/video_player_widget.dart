import 'package:datenote/models/asset/asset_model.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/mixin/controller_with_video_player_mix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../main.dart';

class VideoPlayerWidget extends StatefulWidget {
  final ControllerWithVideoPlayer controller;
  final AssetModel assetModel;

  const VideoPlayerWidget({super.key, required this.assetModel, required this.controller});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  RxBool isMuted = true.obs;
  RxBool isPlaying = true.obs;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.assetModel.url ?? ''))
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0); // 초기 mute
        _controller.play(); // 자동 재생
        _controller.addListener(() {
          /// 상태 변경 감지하여 상태 변수에 저장
          final isPlaying = _controller.value.isPlaying;
          logger.i(isPlaying != this.isPlaying.value);
          if (isPlaying != this.isPlaying.value) {
            this.isPlaying.value = isPlaying;
          }
        },);
      });

    widget.controller.videoPlayerControllerMap.putIfAbsent(widget.assetModel.id, () => _controller);
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    _controller.setVolume(isMuted.value ? 0 : 1);
  }

  void onTapPlay() {
    if (isPlaying.value) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  void dispose() {
    widget.controller.videoPlayerControllerMap.remove(widget.assetModel.id);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: onTapPlay,
              child: AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)),
            ),

            /// ▶️ 중앙 재생/정지 버튼
            Obx(() {
              if (isPlaying.value) {
                return SizedBox.shrink();
              } else {
                return Center(
                  child: GestureDetector(
                    onTap: onTapPlay,
                    child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white70),
                  ),
                );
              }
            }),
            Positioned(
              bottom: 12,
              right: 12,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                icon: Obx(() {
                  return Icon(isMuted.value ? Icons.volume_off : Icons.volume_up, color: Colors.white70, size: 20);
                }),
                onPressed: toggleMute,
                style: IconButton.styleFrom(backgroundColor: Colors.black45, shape: const CircleBorder()),
              ),
            ),
          ],
        )
        : const Center(child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0));
  }
}
