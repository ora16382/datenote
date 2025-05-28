import 'package:datenote/main.dart';
import 'package:datenote/models/address/address_model.dart';
import 'package:datenote/modules/user/address/manage/address_manage_controller.dart';
import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class AddressManageView extends StatefulWidget {
  const AddressManageView({super.key});

  @override
  State<AddressManageView> createState() => _AddressManageViewState();
}

class _AddressManageViewState extends State<AddressManageView> with SingleTickerProviderStateMixin {
  final controller = Get.put(AddressManageController());

  @override
  void initState() {
    controller.slidableController = SlidableController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.transparent),
        centerTitle: true,
        title: GestureDetector(
          child: Text('주소 관리', style: Get.textTheme.titleSmall),
          onTap: () {
            controller.slidableController.openEndActionPane();
            Future.delayed(Duration(seconds: 2), () {
              controller.slidableController.close();
            });
          },
        ),

        /// 기본 뒤로가기 없애기 위해 추가
        leading: buildBackBtn(() => Get.back()),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: GetBuilder<AddressManageController>(
              id: ':addressList',
              builder: (controller) {
                return PagingListener(
                  controller: controller.pagingController,
                  builder: (context, state, fetchNextPage) {
                    return RefreshIndicator(
                      onRefresh: controller.onRefresh,
                      child: PagedListView<int, AddressModel>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate: PagedChildBuilderDelegate<AddressModel>(
                          itemBuilder: (context, addressModel, index) {
                            // Slidable(
                            //     controller:
                            //     index == 0
                            //         ? controller.slidableController
                            //         : null,
                            //     key: ValueKey(addressModel.id),
                            //     endActionPane: ActionPane(
                            //       motion: StretchMotion(),
                            //       extentRatio: 0.4,
                            //
                            //       children: [
                            //         SlidableAction(
                            //           borderRadius: BorderRadius.circular(12),
                            //           onPressed: (context) {
                            //             controller.onTapEditBtn(addressModel);
                            //           },
                            //           backgroundColor: AppColors.primary,
                            //           foregroundColor: AppColors.onPrimary,
                            //           icon: Icons.edit,
                            //           label: '수정',
                            //         ),
                            //         SlidableAction(
                            //           borderRadius: BorderRadius.circular(12),
                            //           spacing: 8,
                            //           onPressed: (context) {
                            //             controller.onTapDeleteBtn(addressModel);
                            //           },
                            //           backgroundColor: AppColors.error,
                            //           foregroundColor: AppColors.onError,
                            //           icon: Icons.delete,
                            //           label: '삭제',
                            //         ),
                            //       ],
                            //     ),
                            return _buildAddressItem(index, addressModel);
                          },
                          newPageErrorIndicatorBuilder: (context) {
                            return Text('오류가 발생하였습니다. 잠시 후 다시 시도해주세요.', style: Get.textTheme.bodyMedium);
                          },
                          noItemsFoundIndicatorBuilder: (context) {
                            return Column(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset('assets/images/address/no_data_address_image.png', width: 200, height: 200)]);
                          },
                          firstPageErrorIndicatorBuilder: (context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(margin: const EdgeInsets.only(bottom: 16), child: Image.asset('assets/images/address/error_address_image.png', width: 200, height: 200)),
                                ElevatedButton(
                                  onPressed: controller.onRefresh,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text('새로고침', style: Get.textTheme.headlineSmall?.copyWith(color: AppColors.onPrimary)),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          GetBuilder<AddressManageController>(
            id: ':loading',
            builder: (ctrl) {
              if (!ctrl.isLoadingProgress) {
                return const SizedBox();
              } else {
                return Center(child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0));
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.onTapAddressAddBtn,
        icon: const Icon(Icons.post_add_outlined),
        label: Text('주소 추가', style: Get.textTheme.headlineSmall?.copyWith(color: AppColors.onPrimary)),
      ),
    );
  }

   /// @author 정준형
    /// @since 2025. 5. 20.
    /// @comment 주소 card item widget
    ///
  Widget _buildAddressItem(int index, AddressModel addressModel) {
    return GetBuilder<AddressManageController>(
      id: ':addressItem:${addressModel.id}',
      builder: (context) {
        addressModel = controller.pagingController.items?[index] ?? addressModel;

        return GestureDetector(
          onTap: () {
            controller.onTapAddress(addressModel);
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 주소 이름
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text(addressModel.addressName, style: Get.textTheme.headlineMedium)]),
                  ),

                  /// 기본 주소
                  Container(margin: const EdgeInsets.only(bottom: 4.0), child: Text(addressModel.address, style: Get.textTheme.bodyMedium)),

                  /// 상세 주소 (있을 경우만 표시)
                  if (addressModel.detailAddress.isNotEmpty) Text(addressModel.detailAddress, style: Get.textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),

                  Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('생성일 : ${DateFormat('yyyy.MM.dd').format(addressModel.createdAt)}', style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey)),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.onTapEditBtn(addressModel);
                              },
                              child: Text('수정', style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey)),
                            ),
                            Container(margin: const EdgeInsets.symmetric(horizontal: 4.0), child: Text('|', style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey))),
                            GestureDetector(
                              onTap: () {
                                controller.onTapDeleteBtn(addressModel);
                              },
                              child: Text('삭제', style: Get.textTheme.bodySmall?.copyWith(color: AppColors.grey)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
