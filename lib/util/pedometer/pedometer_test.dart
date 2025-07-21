import 'dart:async';
import 'dart:io';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

Future<void> pedometerTest() async {
  print('pedometerTest 시작');
  Stream<StepCount> stepCountStream = Pedometer.stepCountStream;

  if (await Permission.activityRecognition.status != PermissionStatus.granted) {
    await Permission.activityRecognition.request();
  }

  /// first 는 내부적으로 하나만 발행하고 종료시켜준다.
  /// 동시에 요청하면 안된다. 한쪽은 에러가 발생함
  StepCount st = await stepCountStream.first.timeout(const Duration(seconds: 5)).catchError((error) {
    print('pedometerTest timeout');
    if(Platform.isIOS) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        openAppSettings();
      });

      throw Exception('만보기 기능을 이용할 수 없습니다.\n동작 및 피트니스 권한을 허용해주세요.');
    }

    /// android
    if (error.toString().contains("PlatformException(1, StepCount not available, StepCount is not available on this device, null)")) {
      throw Exception("해당 기능을 지원하지 않는 디바이스입니다");
    }
  });

  print(st.steps);
  print(st.timeStamp);
}