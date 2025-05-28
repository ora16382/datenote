import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/main.dart';
import 'package:datenote/models/address/address_model.dart';
import 'package:datenote/modules/user/address/daum_post_web/daum_post_web_view.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/services/kakao_local_service.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddressSearchController extends GetxController {
  /// 수정 모드 여부
  final isModify = Get.parameters['isModify'] == 'true';

  /// 수정에서만 사용되는 addressModel
  late final AddressModel addressModel;

  final userCtrl = Get.find<UserController>();

  /// 카카오 local service
  final kakaoLocalService = Get.find<KakaoLocalService>();

  /// 선택된 주소 컨트롤러
  final TextEditingController _addressController = TextEditingController();

  TextEditingController get addressController => _addressController;

  /// 나머지 주소 컨트롤러
  final TextEditingController _detailAddressController =
      TextEditingController();

  TextEditingController get detailAddressController => _detailAddressController;

  /// 나머지 주소 포커스 노드
  final FocusNode _detailAddressFocusNode = FocusNode();

  FocusNode get detailAddressFocusNode => _detailAddressFocusNode;

  /// 주소 저장 이름
  final TextEditingController _addressNameController = TextEditingController();

  TextEditingController get addressNameController => _addressNameController;

  /// 주소 저장 이름 포커스 노드
  final FocusNode _addressNameFocusNode = FocusNode();

  FocusNode get addressNameFocusNode => _addressNameFocusNode;

  /// 위 경도
  Location? location;

  /// 로딩 스핀 위젯 표시 상태
  bool isLoadingProgress = false;

  /// 주소록 저장 여부
  final isSaveAddress = false.obs;

  @override
  void onInit() {
    if (isModify) {
      if (Get.arguments is AddressModel) {
        addressModel = Get.arguments as AddressModel;
        _addressController.text = addressModel.address;
        _detailAddressController.text = addressModel.detailAddress;
        _addressNameController.text = addressModel.addressName;
        location = Location(
          latitude: addressModel.latitude,
          longitude: addressModel.longitude,
          timestamp: DateTime.now(),
        );
      }
    }
    super.onInit();
  }

  @override
  void onReady() {
    if (isModify) {
      if (Get.arguments is! AddressModel) {
        showToast('주소 식별값이 유효하지 않습니다.');
        /// init 에 안 하고 ready 에 한 이유는
        /// init 에서 Get.back 할 경우 해당 컨트롤러가 메모리에서 해제되지 않기 때문
        Get.back();
      }
    }
    super.onReady();
  }

  @override
  void onClose() {
    _addressController.dispose();
    _detailAddressController.dispose();
    _detailAddressFocusNode.dispose();
    _addressNameController.dispose();
    _addressNameFocusNode.dispose();

    super.onClose();
  }

  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 내 위치 정보를 찾아 Position 객체 리턴
  ///
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      showToast('GPS 가 꺼져있습니다. 설정에서 GPS 를 켜주세요.'.tr);

      return null;
    }

    /// 권한 체크 및 요청
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar(
          '[접근 권한 오류] 주소를 불러올 수 없습니다.'.tr,
          '위치에 대한 권한이 없습니다. 위치 권한을 허용으로 변경해주세요.'.tr,
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          onTap: (snack) async {
            /// 알림 권한 설정 페이지로 이동
            await Geolocator.openAppSettings();
          },
        );

        return null;
      }
    }

    /// 현재 위치 얻기
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    );
  }

  /// @author 정준형
  /// @since 2025. 4. 17.
  /// @comment 현재 위치로 주소 불러오기
  ///
  Future<void> fetchCurrentLocation() async {
    try {
      isLoadingProgress = true;
      update([':loading']);

      Position? position = await getCurrentPosition();
      if (position != null) {
        location = Location(
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: DateTime.now(),
        );

        /// kakao local api 활용한 위경도 → 주소 변환
        String? addressName =
            (await kakaoLocalService.requestConvertingCoordinatesToAddresses(
              x: position.longitude.toString(),
              y: position.latitude.toString(),
            ))['address_name'];

        if (addressName == null) {
          showToast('주소를 읽어오는데 실패했습니다. 주소를 다시 설정해주세요');

          isLoadingProgress = false;
          update([':loading']);
          return;
        }

        addressController.text = addressName;

        isLoadingProgress = false;
        update([':loading']);
      }
    } catch (e) {
      isLoadingProgress = false;
      update([':loading']);
      logger.e(e.toString());
      Get.snackbar('오류 발생', '주소를 불러오는 도중 오류가 발생하였습니다.');
    }
  }

  /// @author 정준형
  /// @since 2025. 4. 17.
  /// @comment DaumPost 주소 검색 (외부 라이브러리 연동)
  ///
  Future<void> openDaumPost() async {
    final DataModel? result =
        (await Get.toNamed(Routes.daumPostWeb)) as DataModel?;

    if (result != null) {
      /// 위치 정보 초기화
      location = null;

      isLoadingProgress = true;
      update([':loading']);

      /// 주소로 위경도 변환
      final roadAddressDetailInfo = await kakaoLocalService
          .requestConvertingAddressesToCoordinates(address: result.roadAddress);

      if (roadAddressDetailInfo['x'] != null &&
          roadAddressDetailInfo['y'] != null) {
        location = Location(
          longitude: double.parse(roadAddressDetailInfo['x']!),
          latitude: double.parse(roadAddressDetailInfo['y']!),
          timestamp: DateTime.now(),
        );
      } else {
        showToast('좌표주소를 읽어오는데 실패했습니다. 주소를 다시 설정해주세요');

        isLoadingProgress = false;
        update([':loading']);
        return;
      }

      _addressController.text = '[${result.zonecode}] ${result.roadAddress}';

      isLoadingProgress = false;
      update([':loading']);

      detailAddressFocusNode.requestFocus();
    }
  }

   /// @author 정준형
    /// @since 2025. 4. 30.
    /// @comment 주소록에서 불러오기 콜백, 데이트 플랜 추천에서 사용
    ///
  Future<void> loadAddressFromAddressBook() async {
    final AddressModel? result =
    (await Get.toNamed(Routes.addressManage, parameters: {'isLoadAddress': 'true'})) as AddressModel?;

    if(result != null) {
      location = Location(
        latitude: result.latitude,
        longitude: result.longitude,
        timestamp: DateTime.now(),
      );

      _addressController.text = result.address;
      _detailAddressController.text = result.detailAddress;
      isSaveAddress.value = false;
    }
  }

  bool validateAddress({bool isWithoutAddressName = false}) {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      showToast('주소를 추가해주세요.');
      return false;
    }

    final detailAddress = _detailAddressController.text.trim();

    /// 추가 주소는 없을수도 있음
    // if (detailAddress.isEmpty) {
    //   detailAddressFocusNode.requestFocus();
    //   return;
    // }

    if(!isWithoutAddressName) {
      final addressName = _addressNameController.text.trim();
      if (addressName.isEmpty) {
        showToast('저장될 주소 이름을 입력해주세요');
        addressNameFocusNode.requestFocus();
        return false;
      }
    }

    if (location == null) {
      showToast('위치 정보를 읽어오는데 실패했습니다. 주소를 다시 설정해주세요');
      return false;
    }

    return true;
  }
  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 주소 저장 / 수정
  ///
  Future<void> updateAddress({bool isWithoutAddressName = false}) async {
    if(isWithoutAddressName) {
      _addressNameController.text = '주소_${Uuid().v4().substring(0, 3)}';
    }

    if(!validateAddress()){
      return;
    }

    final address = _addressController.text.trim();

    final detailAddress = _detailAddressController.text.trim();

    final addressName = _addressNameController.text.trim();

    isLoadingProgress = true;
    update([':loading']);

    try {
      if (isModify) {
        String addressId = addressModel.id;

        await FirebaseFirestore.instance
            .collection(FireStoreCollectionName.address)
            .doc(userCtrl.currentUser.uid)
            .collection(FireStoreCollectionName.addresses)
            .doc(addressId)
            .update({
              'address': address,
              'detailAddress': detailAddress,
              'addressName': addressName,
              'latitude': location!.latitude,
              'longitude': location!.longitude,
            });

        showToast('주소 정보가 수정되었습니다.');

        Get.back();
      } else {
        final now = DateTime.now();

        String addressId = const Uuid().v4();

        /// createdAt:
        /// - DateTime.now(): 클라이언트 시간 (빠름, 간편하지만 부정확할 수 있음)
        /// - FieldValue.serverTimestamp(): 서버 시간 (정확하고 신뢰성 높음, 추천)
        /// 둘 다 Firestore에선 Timestamp로 저장됨 = model 에서 converter를 적용했기 때문

        final addressModel = AddressModel(
          id: addressId,
          address: address,
          detailAddress: detailAddress,
          addressName: addressName,
          latitude: location!.latitude,
          longitude: location!.longitude,
          createdAt: now,
          orderDate: now,
        );

        await FirebaseFirestore.instance
            .collection(FireStoreCollectionName.address)
            .doc(userCtrl.currentUser.uid)
            .collection(FireStoreCollectionName.addresses)
            .doc(addressId)
            .set(addressModel.toJson());

        Get.back();
      }
    } catch (e) {
      showToast('주소 정보 업데이트 도중 오류가 발생하였습니다 잠시 후 다시 시도해주세요.');
    } finally {
      isLoadingProgress = false;
      update([':loading']);
    }
  }

  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 나머지 주소 입력 완료 콜백
  ///
  void onEditingCompleteAddressDetail() {
    /// 주소 이름 포커스로 이동
    detailAddressFocusNode.nextFocus();
  }
}

//
// /// @author 정준형
// /// @since 2025. 4. 17.
// /// @comment 전체 주소를 메인, 나머지로 나눈다. (사용하지는 않음
// ///
// Map<String, String> splitAddress(String roadAddress) {
//   final regex = RegExp(r'(.+\d+)(\s.+)?');
//
//   final match = regex.firstMatch(roadAddress.trim());
//
//   if (match != null) {
//     final main = match.group(1)?.trim() ?? '';
//     final detail = match.group(2)?.trim() ?? '';
//     return {'main': main, 'detail': detail};
//   }
//
//   // fallback
//   return {'main': roadAddress.trim(), 'detail': ''};
// }
