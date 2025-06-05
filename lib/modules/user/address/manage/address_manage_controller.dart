import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/main.dart';
import 'package:datenote/models/address/address_model.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/util/mixin/controller_loading_mix.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:datenote/util/widget/dialog.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AddressManageController extends GetxController with ControllerLoadingMix {
  /// 주소 불러오기로 진입했는지 여부
  final isLoadAddress = Get.parameters['isLoadAddress'] == 'true';

  static const int pageSize = 10;

  final userCtrl = Get.find<UserController>();

  /// 무한 스크롤 페이지 컨트롤러
  late final PagingController<int, AddressModel> pagingController;

  /// 페이지 단위로 로드시 실시간으로 추가되는 데이터 때문에 데이터가 밀리는 문제가 발생할 수 있음
  /// 해당 문제를 해결하기 위해 데이터 가져올 시점(불러온 마지막 문서)을 기록하는 객체
  DocumentSnapshot? lastDocumentSnapshot;

  /// firestore 리스너 객체
  late final StreamSubscription _subscription;

  /// Firestore의 snapshots()는 앱에서 listen이 연결될 때마다 전체 데이터에 대해 최초로 한 번 added 이벤트를 전부 보냄.
  /// 최초 구독 이벤트 무시하기위한 플래그
  bool _isFirstSnapshot = true;

  /// Slidable 의 첫번째 요소를 위한 컨트롤러
  late final SlidableController slidableController;

  @override
  void onInit() {
    super.onInit();

    pagingController = PagingController<int, AddressModel>(
      fetchPage: _fetchPage,
      getNextPageKey: (state) {
        if (state.keys?.isEmpty ?? true) return 0;

        final isLastPage = state.pages?.last.isEmpty ?? true;
        return isLastPage ? null : (state.keys?.last ?? 0) + 1;
      },
    );

    /// 추가된 데이터 실시간 업데이트
    _subscription = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.address)
        .doc(userCtrl.currentUser.uid)
        .collection(FireStoreCollectionName.addresses)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .listen((snapshot) {
          if (_isFirstSnapshot) {
            _isFirstSnapshot = false;
            return; // 최초 이벤트 무시
          }

          for (final documentChange in snapshot.docChanges) {
            if (documentChange.type == DocumentChangeType.added) {
              /// 추가된 경우
              Map<String, dynamic>? data = documentChange.doc.data();

              if (data != null) {
                /// no data 상태에서 새로운 데이터가 들어왔을 경우 리프래쉬
                if (pagingController.pages?.firstOrNull?.isEmpty ?? true) {
                  onRefresh();

                  /// 아래 방법이 안되는 이유는 이미 처음 요청에 대한 키가 추가되어 있기 때문이다.
                  /// 그럼 다음 키로 검색하게 되는데 처음 배열은 당연히 nodata 라 비어있기 때문에
                  /// last page 로 인식하게 되어 더이상 요청되지 않는것이다.
                  /// 그냥 refresh 하는게 편하다.
                  //pagingController.fetchNextPage();
                } else {
                  /// 아니면 제일 상단에 노출시키기 위해 첫번째 배열에 추가
                  pagingController.pages?.firstOrNull?.insert(0, AddressModel.fromJson(data));

                  update([':addressList']);
                }
              }
            } else if (documentChange.type == DocumentChangeType.modified) {
              Map<String, dynamic>? data = documentChange.doc.data();

              if (data != null) {
                outerLoop:
                for (final List<AddressModel> page in pagingController.pages ?? []) {
                  for (var addressModel in page.indexed) {
                    if (addressModel.$2.id == documentChange.doc.id) {
                      page[addressModel.$1] = AddressModel.fromJson(data);
                      break outerLoop;
                    }
                  }
                }

                update([':addressItem:${documentChange.doc.id}']);
              }
            } else if (documentChange.type == DocumentChangeType.removed) {
              List<AddressModel>? containPage;
              AddressModel? findAddressModel;

              outerLoop:
              for (final List<AddressModel> page in pagingController.pages ?? []) {
                for (var addressModel in page.indexed) {
                  if (addressModel.$2.id == documentChange.doc.id) {
                    containPage = page;
                    findAddressModel = addressModel.$2;
                    break outerLoop;
                  }
                }
              }

              /// 요소 삭제
              containPage?.remove(findAddressModel);

              /// 리스트 업데이트
              update([':addressList']);
            }
          }
        });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pagingController.dispose();
    _subscription.cancel();

    super.onClose();
  }

  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 피드(페이징) 로드
  ///
  Future<List<AddressModel>> _fetchPage(int pageKey) async {
    Query query = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.address)
        .doc(userCtrl.currentUser.uid)
        .collection(FireStoreCollectionName.addresses)
        .orderBy('orderDate', descending: true)
        .limit(pageSize);

    if (lastDocumentSnapshot != null) {
      query = query.startAfterDocument(lastDocumentSnapshot!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      lastDocumentSnapshot = snapshot.docs.last;
    }

    final items =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return AddressModel.fromJson(data as Map<String, dynamic>);
        }).toList();
    return items;
  }

  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 새로고침 콜백 함수
  ///
  Future<void> onRefresh() async {
    lastDocumentSnapshot = null;
    pagingController.refresh();
  }

  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 주소 추가 클릭 콜백
  ///
  Future<void> onTapAddressAddBtn() async {
    Get.toNamed(Routes.addressSearch);
  }

  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 수정 버튼 클릭 콜백
  ///
  Future<void> onTapEditBtn(AddressModel addressModel) async {
    Get.toNamed(Routes.addressSearch, parameters: {'isModify': 'true'}, arguments: addressModel);

    /// 수정 된 데이터 반영은 streamSnapshots listen 에서 처리한다.
  }

  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 삭제 버튼 클릭 콜백
  ///
  Future<void> onTapDeleteBtn(AddressModel addressModel) async {
    if (!await showTwoButtonDialog(
      contents: '주소를 삭제하시겠습니까?',
      positiveButton: '확인',
      negativeButton: '취소',
      positiveCallBack: () {
        Get.back(result: true);
      },
    )) {
      return;
    }

    try {
      startLoading();

      await FirebaseFirestore.instance
          .collection(FireStoreCollectionName.address)
          .doc(userCtrl.currentUser.uid)
          .collection(FireStoreCollectionName.addresses)
          .doc(addressModel.id)
          .delete();
    } catch (e) {
      showToast('주소 삭제 도중 오류가 발생하였습니다 잠시 후 다시 시도해주세요.');
    } finally {
      endLoading();
    }
  }

  /// @author 정준형
  /// @since 2025. 4. 30.
  /// @comment 주소록 클릭 콜백
  ///
  void onTapAddress(AddressModel addressModel) {
    if (isLoadAddress) {
      Get.back(result: addressModel);
    } else {
      /// 동작 없음
    }
  }
}

/// dismissible 구현할떄 참고하자
/// 그리고 dismissible 에서 위젯은 따로 설정할 수 없다. 필요하다면 그쪽 스와이프 방향에 SlidableAction 커스텀 하면 된다.
///
//
// void test(AddressModel addressModel) {
//   List<AddressModel>? containPage;
//
//   pagingController.pages?.forEach((page) {
//     for (var feedModel in page.indexed) {
//       if (feedModel.$2.id == addressModel.id) {
//         containPage = page;
//         break;
//       }
//     }
//   });
//   요소 삭제
//   containPage?.remove(addressModel);
//   리스트 업데이트
//   update([':addressList']);
// }
