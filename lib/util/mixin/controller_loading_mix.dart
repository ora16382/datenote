import 'package:get/get.dart';

mixin ControllerLoadingMix on GetxController {
  /// api 요청 진행 상태
  bool isLoadingProgress = false;
  static const String buildIdName = ':loading';

  /// @author 정준형
  /// @since 2025. 5. 26.
  /// @comment api 요청 시작
  ///
  void startLoading() {
    isLoadingProgress = true;
    update([buildIdName]);
  }

  /// @author 정준형
  /// @since 2025. 5. 26.
  /// @comment api 요청 종료
  ///
  void endLoading() {
    isLoadingProgress = false;
    update([buildIdName]);
  }
}
