import 'package:datenote/modules/user/collecting_infomation/collecting_information_controller.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CollectingInformationPage { gender, ageGroup, dateStyle, region }

extension CollectingInformationPageExtension on CollectingInformationPage {
  Widget getLeadingWidget(bool isModify) {
    switch (this) {
      case CollectingInformationPage.gender:
        if (isModify) {
          return buildCloseBtn(() {
            Get.find<CollectingInformationController>().onTapModifyBackBtn();
          });
        } else {
          return const SizedBox();
        }
      default:
        return buildBackBtn(() {
          Get.find<CollectingInformationController>().onTapBackBtn();
        });
    }
  }
}
