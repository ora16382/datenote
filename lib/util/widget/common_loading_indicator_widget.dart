import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/mixin/controller_loading_mix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CommonLoadingIndicator<T extends ControllerLoadingMix> extends StatelessWidget {
  final String? tag;
  const CommonLoadingIndicator({super.key, this.tag});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      tag: tag,
      id: ControllerLoadingMix.buildIdName,
      builder: (controller) {
        if (controller.isLoadingProgress) {
          return Center(child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
