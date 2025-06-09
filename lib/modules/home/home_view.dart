import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:datenote/modules/community/community_view.dart';
import 'package:datenote/modules/main/main_view.dart';
import 'package:datenote/modules/user/my_info/my_info_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import '../../../util/app_color.dart';
import '../../constant/enum/home_type.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      body: Obx(() {
        switch (controller.homeType.value) {
          case HomeType.main:
            return MainView();
          case HomeType.community:
            return CommunityView();
          default:
            return MyInfoView();
        }
      }),
      bottomNavigationBar: Obx(() {
        return ConvexAppBar(
          style: TabStyle.react,
          // 기본 스타일 외에도 fixed, react, flip 등 있음
          backgroundColor: Colors.white,
          activeColor: AppColors.primary,
          color: Colors.grey,
          items: const [
            TabItem(icon: Icons.favorite_border_rounded, title: '메인'),
            TabItem(icon: Icons.people_outline_rounded, title: '커뮤니티'),
            TabItem(icon: Icons.person_rounded, title: '내 정보'),
          ],
          initialActiveIndex: controller.homeType.value.index,
          onTap: controller.onTapBottomNavi,
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.homeType.value != HomeType.main) {
          return const SizedBox();
        } else {
          return SpeedDial(
            activeIcon: Icons.close_rounded,
            icon: Icons.add_rounded,
            spacing: 12,
            backgroundColor: AppColors.primary,
            overlayColor: Colors.black,
            overlayOpacity: 0.3,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.edit_note_rounded, color: AppColors.primary,),
                label: '데이트 기록 작성',
                onTap: controller.onTapDateHistoryWriteBtn,
              ),
              SpeedDialChild(
                child: const Icon(Icons.favorite_rounded, color: AppColors.primary,),
                label: '데이트 플랜 추천',
                onTap: controller.onTapDatePlanRecommendBtn,
              ),
            ],
          );
        }
      }),
    );
  }
}
