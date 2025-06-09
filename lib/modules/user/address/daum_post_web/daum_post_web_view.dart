import 'package:datenote/main.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DaumPostWebView extends StatefulWidget {
  const DaumPostWebView({super.key});

  @override
  State<DaumPostWebView> createState() => _DaumPostWebViewState();
}

class _DaumPostWebViewState extends State<DaumPostWebView> {
  bool _isError = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    DaumPostcodeSearch daumPostcodeSearch = DaumPostcodeSearch(
      onConsoleMessage: (_, message) => logger.i(message),
      onReceivedError: (controller, request, error) => setState(
            () {
          _isError = true;
          errorMessage = error.description;
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        centerTitle: true,
        leading: buildBackBtn(() => Get.back(),),
      ),
      body: Column(
        children: [
          Expanded(
            child: daumPostcodeSearch,
          ),
          Visibility(
            visible: _isError,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(errorMessage ?? ""),
                ElevatedButton(
                  child: Text("새로고침"),
                  onPressed: () {
                    daumPostcodeSearch.controller?.reload();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}