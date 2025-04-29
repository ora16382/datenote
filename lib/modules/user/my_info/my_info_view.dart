import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'my_info_controller.dart';

class MyInfoView extends StatelessWidget {
  const MyInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyInfoController());
    final userController = Get.find<UserController>();

    return Container(
      color: AppColors.background,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          /// 프로필 정보
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 4.0),
                child: Text('프로필', style: Get.textTheme.headlineSmall),
              ),
              GestureDetector(
                onTap: controller.onTapEditProfile,
                child: const Icon(
                  Icons.edit,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              Spacer(),
              ElevatedButton.icon(
                onPressed: controller.onTapLogout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
              ),
            ],
          ),
          GetBuilder<MyInfoController>(
            id: ':myInfoCard',
            builder: (_) {
              final user = userController.currentUser;

              return Container(
                margin: const EdgeInsets.only(bottom: 32.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow('👤 이름', user.displayName ?? ''),
                        _infoRow('🧑‍🤝‍🧑 성별', user.gender?.label ?? '-'),
                        _infoRow('🎂 연령대', user.ageGroup?.label ?? '-'),
                        _infoRow(
                          '💘 데이트 취향',
                          user.dateStyle?.map((e) => e.label).join(', ') ?? '-',
                        ),
                        _infoRow('📍 지역', user.region?.label ?? '-'),
                        // _infoRow(
                        //   '🎧 선호 장르',
                        //   user.musicGenres?.map((e) => e.label).join(', ') ?? '-',
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Text('내 데이터', style: Get.textTheme.headlineSmall),
          Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('주소 관리'),
                  leading: const Icon(Icons.location_on_outlined),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.onTapManageAddress,
                ),
              ],
            ),
          ),
          /// 앱 정보
          Text('앱 정보', style: Get.textTheme.headlineSmall),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: FutureBuilder<PackageInfo>(
              future: controller.loadPackageInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '현재 버전 : @version'.trParams({
                            'version': snapshot.data?.version ?? 'unknown',
                          }),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            leading: const Icon(Icons.info_outline),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('오픈소스 라이선스'),
            leading: const Icon(Icons.article_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(context: context),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(title, style: Get.textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: Get.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
