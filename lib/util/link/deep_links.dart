import 'dart:async';
import 'package:datenote/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';

import '../../main.dart';

/// 딥링크 및 앱링크 처리 전용 컨트롤러
/// - cold start / warm resume 상태에 따라 분기 처리
/// - 앱이 켜질 때 또는 백그라운드에서 돌아올 때 URI를 해석해서 라우팅
class DeepLinkController extends GetxController with WidgetsBindingObserver {
  final AppLinks _appLinks = AppLinks(); /// app_links 패키지 인스턴스
  Uri? _pendingUri; /// 아직 처리되지 않은 URI (초기화 전 도착한 경우 저장됨)
  bool _isInitialized = false; /// 앱 초기화 완료 여부
  late StreamSubscription<Uri> _sub; /// 라이브 링크 스트림 구독용 변수

  Uri? _initialUri; /// cold start 시 최초 전달받은 URI

  /// cold start 여부 확인용 (초기 URI가 있다면 cold start로 판단)
  bool get isColdStart => _initialUri != null;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this); // 앱 생명주기 감지 등록
    _checkInitialUri(); // cold start 시 URI 체크
    _listenForLiveLinks(); // 앱 실행 중 수신되는 딥링크 스트림 리스닝 시작
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this); // 생명주기 옵저버 제거
    _sub.cancel(); // 스트림 구독 해제
    super.onClose();
  }

  /// 앱 생명주기 감지 콜백
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onAppResumed(); // 앱이 포그라운드로 돌아올 때 처리
    }
  }

  /// 앱이 다시 활성화(warm resume)될 때 호출되는 메서드
  void onAppResumed() {
    debugPrint('🔁 resumed!');
    markAppInitialized(); // 앱 초기화 처리 (warm start 기준)
  }

  /// 앱 초기화 완료 시 호출되는 메서드
  void markAppInitialized() {
    debugPrint('✅ markAppInitialized called');
    _isInitialized = true;
    _initialUri = null; // cold start로 인식하지 않도록 초기화
    _tryHandlePendingUri(); // 대기 중인 URI가 있으면 처리 시도
  }

  /// 앱이 실행 중일 때 딥링크를 수신하는 스트림 리스너 설정
  void _listenForLiveLinks() {
    _sub = _appLinks.uriLinkStream.listen((Uri uri) {
      debugPrint('📡 live URI: $uri');
      _pendingUri = uri; // 아직 초기화가 안 되었을 수 있으므로 pending에 저장
    }, onError: (err) {
      debugPrint('❌ app_links stream error: $err');
    });
  }

  /// 앱 cold start 시 최초 URI를 수신하는 메서드
  Future<void> _checkInitialUri() async {
    try {
      final uri = await _appLinks.getInitialLink(); // 앱 시작 시 전달된 링크 확인
      if (uri != null) {
        debugPrint('🧊 cold start URI: $uri');
        _initialUri = uri;
        _pendingUri = uri; // pending에도 넣어두고 초기화 후 처리될 수 있도록
      }
    } catch (e) {
      debugPrint('❌ getInitialAppLink error: $e');
    }
  }

  /// 초기화 이후 처리되지 않은 URI가 있다면 처리
  void _tryHandlePendingUri() {
    if (_isInitialized && _pendingUri != null) {
      _handleUri(_pendingUri!);
      _pendingUri = null; // 처리 후 비움
    }
  }

  /// URI를 해석하고 라우팅을 수행하는 메서드
  void _handleUri(Uri uri) {
    final path = uri.path;
    final params = uri.queryParameters;

    logger.i(path);

    switch (path) {
      /// 쿼리 값에 따라 원하는 라우팅 동작
      default:
        Get.toNamed(Routes.addressSearch, arguments: params);
    }
  }
}
