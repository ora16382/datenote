import 'package:datenote/modules/user/auth/auth_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_loading_indicator_widget.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'profile_setting_controller.dart';

class ProfileSettingView extends StatelessWidget {
  const ProfileSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileSettingViewController());

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        scrolledUnderElevation: 0,

        /// 기본 뒤로가기 없애기 위해 추가
        leading: buildBackBtn(() {
          Get.find<AuthController>().signOut();
        }),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Stack(
              children: [
                ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        '당신의 이름은 무엇인가요?',
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 40.0),
                      child: Text(
                        'DateNote에서 사용할 닉네임을 입력해주세요',
                        style: Get.textTheme.titleSmall?.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0X1415224D),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: controller.onChangeNicknameField,
                        decoration: InputDecoration(
                          hintText: '예: 주농이다',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    GetBuilder<ProfileSettingViewController>(
                      id: ":conflictNicknameText",
                      builder: (_) {
                        if (controller.isConflictNickname) {
                          return Container(
                            margin: EdgeInsets.only(top: 8.0),
                            child: Text(
                              '이미 사용중인 이름입니다.',
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: AppColors.error,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.registerUser,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '닉네임 등록하기',
                          style: Get.textTheme.headlineSmall?.copyWith(color: AppColors.onPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
                CommonLoadingIndicator<ProfileSettingViewController>(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
