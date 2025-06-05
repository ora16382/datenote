import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/models/address/address_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/util/functions/common_functions.dart';
import 'package:datenote/util/mixin/controller_loading_mix.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:datenote/util/widget/dialog.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../main.dart';

class RecommendPlanListController extends GetxController with ControllerLoadingMix {
  /// 선택모드 여부(데이트 기록 작성에서 사용)
  final isSelectMode = Get.parameters['isSelectMode'] == 'true';

  static const int pageSize = 10;

  final userCtrl = Get.find<UserController>();

  /// 무한 스크롤 페이지 컨트롤러
  late final PagingController<int, RecommendPlanModel> pagingController;

  /// 페이지 단위로 로드시 실시간으로 추가되는 데이터 때문에 데이터가 밀리는 문제가 발생할 수 있음
  /// 해당 문제를 해결하기 위해 데이터 가져올 시점(불러온 마지막 문서)을 기록하는 객체
  DocumentSnapshot? lastDocumentSnapshot;

  /// firestore 리스너 객체
  late final StreamSubscription _subscription;

  /// Firestore의 snapshots()는 앱에서 listen이 연결될 때마다 전체 데이터에 대해 최초로 한 번 added 이벤트를 전부 보냄.
  /// 최초 구독 이벤트 무시하기위한 플래그
  bool _isFirstSnapshot = true;

  /// 현재 조회한 날짜 리스트
  HashSet<DateTime> selectedDateList = HashSet(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  @override
  void onInit() {
    super.onInit();

    pagingController = PagingController<int, RecommendPlanModel>(
      fetchPage: _fetchPage,
      getNextPageKey: (state) {
        if (state.keys?.isEmpty ?? true) return 0;

        final isLastPage = state.pages?.last.isEmpty ?? true;
        return isLastPage ? null : (state.keys?.last ?? 0) + 1;
      },
    );

    /// 추가된 데이터 실시간 업데이트
    _subscription = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.recommendDatePlan)
        .where('userId', isEqualTo: userCtrl.currentUser.uid)
        /// Firestore는 orderBy()에서 DateTime의 일부만(예: 날짜만) 기준으로 정렬하는 기능을 지원하지 않는다.
        /// 그냥 date 로 정렬해도 같은 데이트 날짜의 추천 플랜은 추가한 순서대로 불러올 것이다.
        .orderBy('date', descending: true)
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
                  pagingController.pages?.firstOrNull?.insert(0, RecommendPlanModel.fromJson(data));

                  update([':recommendPlanList']);
                }
              }
            } else if (documentChange.type == DocumentChangeType.modified) {
              Map<String, dynamic>? data = documentChange.doc.data();

              if (data != null) {
                outerLoop:
                for (final List<RecommendPlanModel> page in pagingController.pages ?? []) {
                  for (var recommendPlanModel in page.indexed) {
                    if (recommendPlanModel.$2.id == documentChange.doc.id) {
                      page[recommendPlanModel.$1] = RecommendPlanModel.fromJson(data);
                      break outerLoop;
                    }
                  }
                }

                update([':recommendPlanItem:${documentChange.doc.id}']);
              }
            } else if (documentChange.type == DocumentChangeType.removed) {
              List<RecommendPlanModel>? containPage;
              RecommendPlanModel? findRecommendPlanModel;

              outerLoop:
              for (final List<RecommendPlanModel> page in pagingController.pages ?? []) {
                for (var recommendPlanModel in page.indexed) {
                  if (recommendPlanModel.$2.id == documentChange.doc.id) {
                    containPage = page;
                    findRecommendPlanModel = recommendPlanModel.$2;
                    break outerLoop;
                  }
                }
              }

              /// 요소 삭제
              containPage?.remove(findRecommendPlanModel);

              /// 리스트 업데이트
              update([':recommendPlanList']);
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
  Future<List<RecommendPlanModel>> _fetchPage(int pageKey) async {
    Query query = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.recommendDatePlan)
        .where('userId', isEqualTo: userCtrl.currentUser.uid)
        /// Firestore는 orderBy()에서 DateTime의 일부만(예: 날짜만) 기준으로 정렬하는 기능을 지원하지 않는다.
        /// 그냥 date 로 정렬해도 같은 데이트 날짜의 추천 플랜은 추가한 순서대로 불러올 것이다.
        .orderBy('date', descending: true)
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
          return RecommendPlanModel.fromJson(data as Map<String, dynamic>);
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
  Future<void> onTapDatePlanRecommendBtn() async {
    Get.toNamed(Routes.recommendPlan);
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment 데이트 플랜 추천 클릭 콜백
  ///
  void onTapRecommendPlan(RecommendPlanModel recommendPlanModel) {
    if(isSelectMode){
      /// 데이트 기록 작성 - 선택 모드일 경우
      Get.back(result: recommendPlanModel);
    } else {
      /// 5. 상세보기로 진입하기
      Get.toNamed(
        Routes.recommendPlanDetail,
        arguments: recommendPlanModel,
      );
    }
  }
}
