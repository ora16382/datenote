import 'package:datenote/main.dart';
import 'package:datenote/models/address/address_model.dart';
import 'package:datenote/models/place/place_model.dart';
import 'package:datenote/services/kakao_local_service.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceSearchController extends GetxController {
  /// 검색 기준이되는 주소 모델
  late AddressModel baseAddress;

  /// 카카오 local service
  final kakaoLocalService = Get.find<KakaoLocalService>();

  /// 현재 페이지 index
  int currentPage = 1;

  /// 전체 페이지 수
  int totalPages = 1;

  /// 검색어 컨트롤러
  final TextEditingController _searchController = TextEditingController();

  /// 검색 전 초기 진입 상태 여부
  bool isInit = true;

  /// 로딩 상태
  bool isLoading = false;

  /// 플레이스 목록 보관 Map<pageIndex,  placeList>
  Map<int, List<PlaceModel>> placeListMap = {};

  TextEditingController get searchController => _searchController;

  @override
  void onInit() {
    if (Get.arguments is AddressModel) {
      baseAddress = Get.arguments;
    }

    super.onInit();
  }

  @override
  void onReady() {
    if (Get.arguments is! AddressModel) {
      showToast('좌표 데이터가 유효하지 않습니다.');

      /// init 에 안 하고 ready 에 한 이유는
      /// init 에서 Get.back 할 경우 해당 컨트롤러가 메모리에서 해제되지 않기 때문
      Get.back();
    }
    super.onReady();
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 검색 클릭 콜백
  ///
  Future<void> onSearch() async {
    if (_searchController.text.isEmpty) {
      showToast('검색어를 입력해주세요.');
      return;
    }

    /// 초기 상태 해제
    if (isInit) {
      isInit = false;
    }

    /// 기존 데이터 삭제
    placeListMap.clear();
    currentPage = 1;
    totalPages = 1;

    isLoading = true;
    update([':searchResult']);

    FocusManager.instance.primaryFocus?.unfocus();
    /// 검색 로직 실행
    searchPlaceWithKeyword(_searchController.text);
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 장소 선택 콜백
  ///
  Future<void> onSelectPlace(PlaceModel place) async {
    Get.back(result: place);
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 장소 검색 API 실행
  ///
  Future<void> searchPlaceWithKeyword(String text) async {
    Map<String, dynamic> resultMap = await kakaoLocalService.getPlaceListWithKeyword(
      addressModel: baseAddress,
      keyword: text,
      page: currentPage,
    );

    totalPages = (((resultMap['meta']?['pageable_count'] as int?) ?? 1) / 10).ceil().toInt();

    List<PlaceModel> placeList = (resultMap['documents'] as List).map((e) => PlaceModel.fromJson(e),).toList();

    if(placeList.isNotEmpty) {
      placeListMap.putIfAbsent(currentPage, () => placeList);
    }

    isLoading = false;
    update([':searchResult', ':pagination']);
  }

  /// @author 정준형
  /// @since 2025. 5. 19.
  /// @comment 페이지 선택 클릭 콜백
  ///
  Future<void> onPageSelected(int page) async {
    if(currentPage == page) {
      /// 같은 페이지일 경우 동작 안함
      return;
    }

    currentPage = page;

    if(placeListMap.containsKey(page)) {
      update([':searchResult', ':pagination']);
      return;
    }

    isLoading = true;
    update([':searchResult']);

    /// 검색 로직 실행
    searchPlaceWithKeyword(_searchController.text);
  }
}
