

import 'package:fluttertoast/fluttertoast.dart';

Future<void> showToast(String msg) async {
  Fluttertoast.cancel();
  Fluttertoast.showToast(msg: msg);
}