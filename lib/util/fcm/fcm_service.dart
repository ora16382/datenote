import 'dart:convert';
import 'dart:io';

import 'package:datenote/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

/// 백그라운드 메시지 수신 콜백
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("background 수신");
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  /// TODO 걸음수 가져오는지 확인
  Map<String, dynamic> data = message.data;

  /// Notification title 과 body 를 설정 할 경우 FCM 에서 push 를 만들어 주기때문에 푸시가 보여지며,
  /// 만약 Notification 정보 없이 data 만 보낼 경우에는 푸시는 보여지지 않는다.

  /// 콜백 내에서 FlutterLocalNotification 을 통하여 push 를 생성 할 수는 있지만
  /// 굳이 그렇게 할 필요 없이 자동으로 생성된 FCM Push 를 사용한다.

  // /// isolate sendPort 포트 네임
  // String? portName = data['portName'];
  //
  // if (portName != null) {
  //
  //   final SendPort? send = IsolateNameServer.lookupPortByName(':$portName');
  //
  //   /// ReceiverPort 로 data 전송
  //   send?.send(data);
  // }
}

@pragma('vm:entry-point')
Future<void> foregroundFcmInitAndCallbackInit() async {
  final firebaseMessaging = FirebaseMessaging.instance;

  /// 백그라운드, 또는 종료 상태에서 메시지 수신 콜백 등록
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel('high_importance_channel', 'high_importance_notification', importance: Importance.max));

  /// 포그라운드 기본 알림 설정
  const InitializationSettings initializationSettings =
  InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings(), macOS: DarwinInitializationSettings());

  /// IOS 포그라운드 알림 설정
  await firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  /// 포그라운드 메시지 클릭 시 콜백
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: fcmOnClickMessage, onDidReceiveBackgroundNotificationResponse: fcmOnClickMessage);

  /// 포그라운드 FCM 수신 콜백
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          "high_importance_channel",
          "high_importance_notification",
        ),
        iOS: DarwinNotificationDetails());

    RemoteNotification? notification = message.notification;

    /// TODO 데이터 검사해보자.
    AndroidNotification? android = message.notification?.android;

    /// TODO 데이터 검사해보자.
    AppleNotification? apple = message.notification?.apple;

    /// TODO 기존 IOS 에서도 foreground 에서 표시가 됐던 이유는 단지 android 가 null이 아니여서 그랬던것 뿐
    /// IOS 에서도 foreground 에서 표시되게 하려면 apple 이 null 이 아닐때 표시하도록 수정해야함
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: json.encode(message.data),
      );
    }
  });

  /// 앱이 종료된 상태에서 푸시 알림 클릭하여 앱을 실행 할 경우 메세지 가져옴
  firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
    if (message != null) {
      pushTouchEvent(message.data);
    }
  });

  /// 앱이 백그라운드 상태에서 푸시 알림 클릭하여 앱이 열릴 경우 콜백
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    pushTouchEvent(message.data);
  });

  /// 알림 권한 및 설정 요청
  final settings = await firebaseMessaging.requestPermission(alert: true, announcement: true, badge: true, carPlay: true, criticalAlert: true, provisional: true, sound: true);

  /// 알림 권한 요청 및 설정 완료됨
  if (settings.authorizationStatus != AuthorizationStatus.authorized) {
    /// 알림 권한이 없을 경우
    //   Get.snackbar(
    //     '접근 권한 오류'.tr,
    //     Platform.isAndroid ? '알림에 대한 권한이 없습니다. 애플리케이션 정보 - 권한 - 알림 권한을 허용으로 변경해주세요.'.tr : '알림에 대한 권한이 없습니다. 알림 권한을 허용으로 변경해주세요.'.tr,
    //     backgroundColor: Colors.white,
    //     snackPosition: SnackPosition.BOTTOM,
    //     onTap: (snack) {
    //       /// 터치시 알림 권한 설정 페이지로 이동
    //       openAppSettings();
    //     },
    //   );
  }

  /// APNS Token 을 불러오지 못하는 문제 때문에 고의적으로 지연시킴
  if (Platform.isIOS) {
    await Future.delayed(3.seconds);
  }

  /// FCM 초기화
  await initFcmToken(firebaseMessaging);
}

/// FCM TOKEN 초기화, 및 변경 시 저장
/// IOS 의 경우 알림 거절 했을 경우 ApnsToken 이 없다는 에러가 발생한다.
/// 안드로이드는 알림 권한 거절해도 토큰 발행된다.
Future<void> initFcmToken(FirebaseMessaging messaging) async {
  /// FCM TOKEN 수신
  messaging.getToken(vapidKey: "BCY78GQ1vbsq0hP_XR8eCXF86L8bgBIUs4IzExwlZWIXUibulFDl1QhJ5hRZlMz-JhUwDpGqw-92BfGSIpOoYL0").then((token) {
    logger.i(token);
  });

  /// FCM 토큰 변경 콜백 등록, 한번에 여러번 반복 실행되는 문제 존재
  messaging.onTokenRefresh.listen((token) {
    logger.i("onTokenRefresh : "+token);
  });
}

/// 앱이 실행된 상태에서 포그라운드 푸시 알림 클릭 시 콜백
@pragma('vm:entry-point')
Future<void> fcmOnClickMessage(NotificationResponse details) async {
  if (details.payload != null) {
    Map<String, dynamic> data = jsonDecode(details.payload!);

    pushTouchEvent(data);
  }
}

/// 푸시 클릭 시 터치 이벤트
@pragma('vm:entry-point')
Future<void> pushTouchEvent(Map<String, dynamic> pushData) async {
  logger.d('pushTouchEvent');
  // User? user = Pot.user;

  /// 로그인 된 상태일 경우에만 터치 콜백 실행
  // if (user != null) {
  //   String type = pushData['Type'] ?? 'empty';
  //
  //   PushTypeEnum pushType = type.getPushType;
  //
  //   pushType.callbackFunc(pushData);
  // }
}
