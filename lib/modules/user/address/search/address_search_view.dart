import 'package:datenote/main.dart';
import 'package:datenote/modules/user/address/search/address_search_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitFadingCircle;
import 'package:get/get.dart';

class AddressSearchView extends StatelessWidget {
  const AddressSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressSearchController());

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        centerTitle: true,
        title: Text(
          controller.isModify ? '주소 수정' : '주소 추가',
          style: Get.textTheme.titleSmall,
        ),

        /// 기본 뒤로가기 없애기 위해 추가
        leading: buildBackBtn(() => Get.back()),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: ElevatedButton.icon(
                                    onPressed: controller.fetchCurrentLocation,
                                    icon: const Icon(
                                      Icons.my_location,
                                      size: 24,
                                    ),
                                    label: Text(
                                      '현재 위치',
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                            color: AppColors.onPrimary,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              // 🏷️ Daum 주소 검색 버튼
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: ElevatedButton.icon(
                                    onPressed: controller.openDaumPost,
                                    icon: const Icon(Icons.search, size: 24),
                                    label: Text(
                                      '주소 검색',
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                            color: AppColors.onPrimary,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ✍️ 텍스트 필드로 직접 수정
                        TextField(
                          controller: controller.addressController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey),
                            ),
                            floatingLabelStyle: Get.textTheme.titleMedium
                                ?.copyWith(color: AppColors.grey),
                            labelStyle: Get.textTheme.titleMedium?.copyWith(
                              color: AppColors.grey,
                            ),
                            labelText: '주소',
                          ),
                          maxLines: 1,
                          readOnly: true,
                        ),
                        // ✍️ 나머지 주소 입력
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: TextField(
                            focusNode: controller.detailAddressFocusNode,
                            controller: controller.detailAddressController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondary,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondary,
                                ),
                              ),
                              floatingLabelStyle: Get.textTheme.titleMedium
                                  ?.copyWith(color: AppColors.secondary),
                              labelStyle: Get.textTheme.titleMedium?.copyWith(
                                color: AppColors.secondary,
                              ),
                              labelText: '나머지 주소 (건물명, 동호수 등)',
                            ),

                            /// onEditingComplete/ onSubmitted 둘 다
                            /// 키보드에서 "완료"/"Enter" 누를 때 동작되는건 동일함
                            /// 근데 onEditingComplete 는 다음 포커스로 이동 등 단순 트리거
                            /// onSubmitted 는 입력값을 바탕으로 서버 전송 등 처리
                            /// onEditingComplete 호출 후 onSubmitted 호출됨
                            onEditingComplete:
                                controller.onEditingCompleteAddressDetail,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: TextField(
                            focusNode: controller.addressNameFocusNode,
                            controller: controller.addressNameController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondary,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondary,
                                ),
                              ),
                              floatingLabelStyle: Get.textTheme.titleMedium
                                  ?.copyWith(color: AppColors.secondary),
                              labelStyle: Get.textTheme.titleMedium?.copyWith(
                                color: AppColors.secondary,
                              ),
                              labelText: '저장될 주소 이름',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ✅ 저장 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.updateAddress,
                      child: Text(
                        controller.isModify ? '주소 수정완료' : '주소 저장하기',
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GetBuilder<AddressSearchController>(
              id: ':loading',
              builder: (ctrl) {
                if (!ctrl.isLoadingProgress) {
                  return const SizedBox();
                } else {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: AppColors.primary,
                      size: 50.0,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
