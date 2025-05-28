import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/models/address/address_model.dart';
import 'package:datenote/models/dating_history/dating_history_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/models/user/user_model.dart';
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

import '../../../../main.dart';

class CommunityController extends GetxController with ControllerLoadingMix {
  static const int pageSize = 10;

  final userCtrl = Get.find<UserController>();

  /// 무한 스크롤 페이지 컨트롤러
  late final PagingController<int, DatingHistoryModel> pagingController;

  /// 페이지 단위로 로드시 실시간으로 추가되는 데이터 때문에 데이터가 밀리는 문제가 발생할 수 있음
  /// 해당 문제를 해결하기 위해 데이터 가져올 시점(불러온 마지막 문서)을 기록하는 객체
  // DocumentSnapshot? lastDocumentSnapshot;

  /// lastDocumentSnapshot 가 삭제되었을 경우를 대비해 그 이전의 데이터를 임시 저장한다.
  List<DocumentSnapshot> lastDocumentSnapshotList = [];

  final Map<String, UserModel> userMap = {};

  /// firestore 리스너 객체
  late final StreamSubscription _subscription;

  /// Firestore의 snapshots()는 앱에서 listen이 연결될 때마다 전체 데이터에 대해 최초로 한 번 added 이벤트를 전부 보냄.
  /// 최초 구독 이벤트 무시하기위한 플래그
  bool _isFirstSnapshot = true;

  /// 피드 좋아요 loading 상태 Map
  final Map<String, bool> favoriteLoadingProgressMap = {};

  /// 커뮤니티 오픈 loading 상태 Map
  final Map<String, bool> isCommunityOpenLoadingProgressMap = {};

  @override
  void onInit() {
    super.onInit();

    pagingController = PagingController<int, DatingHistoryModel>(
      fetchPage: _fetchPage,
      getNextPageKey: (state) {
        if (state.keys?.isEmpty ?? true) return 0;

        final isLastPage = state.pages?.last.isEmpty ?? true;
        return isLastPage ? null : (state.keys?.last ?? 0) + 1;
      },
    );

    /// 추가된 데이터 실시간 업데이트
    _subscription = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.datingHistory)
        .where('isOpenToCommunity', isEqualTo: true)
        /// Firestore는 orderBy()에서 DateTime의 일부만(예: 날짜만) 기준으로 정렬하는 기능을 지원하지 않는다.
        /// 그냥 date 로 정렬해도 같은 데이트 날짜의 추천 플랜은 추가한 순서대로 불러올 것이다.
        .orderBy('createdAt', descending: true)
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
                  pagingController.pages?.firstOrNull?.insert(0, DatingHistoryModel.fromJson(data));

                  update([':communityList']);
                }
              }
            } else if (documentChange.type == DocumentChangeType.modified) {
              Map<String, dynamic>? data = documentChange.doc.data();

              if (data != null) {
                List<DatingHistoryModel>? containPage;
                DatingHistoryModel? findDatingHistoryModel;

                outerLoop:
                for (final List<DatingHistoryModel> page in pagingController.pages ?? []) {
                  for (var datingHistoryModel in page.indexed) {
                    if (datingHistoryModel.$2.id == documentChange.doc.id) {
                      containPage = page;
                      findDatingHistoryModel = datingHistoryModel.$2;

                      page[datingHistoryModel.$1] = DatingHistoryModel.fromJson(data);
                      break outerLoop;
                    }
                  }
                }

                if (findDatingHistoryModel?.isOpenToCommunity == false) {
                  /// 요소 삭제
                  containPage?.remove(findDatingHistoryModel);
                  update([':communityList']);
                } else {
                  update([':datingHistoryItem:${documentChange.doc.id}']);
                }
              }
            } else if (documentChange.type == DocumentChangeType.removed) {
              List<DatingHistoryModel>? containPage;
              DatingHistoryModel? findDatingHistoryModel;

              outerLoop:
              for (final List<DatingHistoryModel> page in pagingController.pages ?? []) {
                for (var datingHistoryModel in page.indexed) {
                  if (datingHistoryModel.$2.id == documentChange.doc.id) {
                    containPage = page;
                    findDatingHistoryModel = datingHistoryModel.$2;
                    break outerLoop;
                  }
                }
              }

              /// 아래같이 해도 된다.
              /// pagingController.items?.remove(findDatingHistoryModel);

              /// 요소 삭제
              containPage?.remove(findDatingHistoryModel);

              /// 리스트 업데이트
              update([':communityList']);
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
  Future<List<DatingHistoryModel>> _fetchPage(int pageKey, {int retryCount = 0}) async {
    Query query = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.datingHistory)
        .where('isOpenToCommunity', isEqualTo: true)
        /// Firestore는 orderBy()에서 DateTime의 일부만(예: 날짜만) 기준으로 정렬하는 기능을 지원하지 않는다.
        /// 그냥 date 로 정렬해도 같은 데이트 날짜의 추천 플랜은 추가한 순서대로 불러올 것이다.
        .orderBy('createdAt', descending: true)
        .limit(pageSize);

    if (lastDocumentSnapshotList.isNotEmpty) {
      /// 다른 유저의 게시글인 경우 삭제시켰을 가능성이 있기 때문에 재시도 요청에 대한 처리가 필요하다.

      final docExists = await lastDocumentSnapshotList.elementAt(retryCount).reference.get().then((doc) => doc.exists);

      if (docExists) {
        query = query.startAfterDocument(lastDocumentSnapshotList.first);
      } else {
        /// 문서가 삭제되었으므로 커서를 사용할 수 없음
        /// 이 경우 마지막 이전 페이지를 커서로 사용
        /// 3번까지만 시도한다.

        /// 재시도 횟수 증가
        ++retryCount;

        if (retryCount < 3 && (lastDocumentSnapshotList.length > retryCount)) {
          return _fetchPage(pageKey, retryCount: retryCount);
        } else {
          showToast('삭제된 데이터가 있어 페이지를 새로고침 합니다.');
          /// 고의적으로 딜레이를 넣어준다.
          Future.delayed(Duration(seconds: 1), () => onRefresh(),);
          return [];
        }
      }
    }

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      lastDocumentSnapshotList.clear();
      lastDocumentSnapshotList.addAll(snapshot.docs.reversed.take(3));
    }

    List<DatingHistoryModel> items =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return DatingHistoryModel.fromJson(data as Map<String, dynamic>);
        }).toList();

    /// 좋아요 로딩 상태값 추가
    favoriteLoadingProgressMap.addAll({for (var e in items) e.id: false});

    /// 커뮤니티 오픈 로딩 상태값 추가
    isCommunityOpenLoadingProgressMap.addAll({for (var e in items) e.id: false});

    /// 조회한적 없는 userId 리스트 추출
    final userIds = items.map((e) => e.userId).where((id) => !userMap.containsKey(id)).toSet().toList();

    if (userIds.isNotEmpty) {
      /// 각 데이터별 사용자 정보 불러오기
      /// userId in 조건으로 사용자 데이터 일괄 조회
      final userSnapshot =
          await FirebaseFirestore.instance
              .collection(FireStoreCollectionName.users)
              .where('uid', whereIn: userIds)
              .get();

      /// 사용자 uid → UserModel 매핑
      for (var doc in userSnapshot.docs) {
        userMap.putIfAbsent(doc['uid'], () => UserModel.fromJson(doc.data()));
      }

      items =
          items.map((history) {
            return history.copyWith(user: userMap[history.userId]);
          }).toList();
    }

    return items;
  }

  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 새로고침 콜백 함수
  ///
  Future<void> onRefresh() async {
    userMap.clear();
    favoriteLoadingProgressMap.clear();
    isCommunityOpenLoadingProgressMap.clear();
    lastDocumentSnapshotList.clear();
    pagingController.refresh();
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 데이팅 기록 작성 버튼 클릭 콜백
  ///
  Future<void> onTapDatingHistoryWriteBtn() async {
    Get.toNamed(Routes.datingHistoryEdit);
  }

  /// @author 정준형
  /// @since 2025. 5. 20.
  /// @comment 데이트 플랜 추천 클릭 콜백
  ///
  void onTapDatingHistory(DatingHistoryModel datingHistoryModel) {
    /// 5. 상세보기로 진입하기
    Get.toNamed(Routes.datingHistoryDetail, arguments: datingHistoryModel);
  }

  /// @author 정준형
  /// @since 2025. 5. 26.
  /// @comment 좋아요 클릭 콜백
  ///
  Future<void> onTapFavorite(DatingHistoryModel datingHistoryModel) async {
    final docRef = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.datingHistory)
        .doc(datingHistoryModel.id);

    final currentUserId = userCtrl.currentUser.uid;

    try {
      favoriteLoadingProgressMap[datingHistoryModel.id] = true;
      update([':favorite:datingHistoryItem:${datingHistoryModel.id}']);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = (await transaction.get(docRef)).data();

        final likedUserIds = List<String>.from(snapshot?['likesUserId'] ?? []);

        transaction.update(docRef, {
          'likesUserId':
              likedUserIds.contains(currentUserId)
                  ? FieldValue.arrayRemove([currentUserId])
                  : FieldValue.arrayUnion([currentUserId]),
        });
      });
    } catch (e) {
      favoriteLoadingProgressMap[datingHistoryModel.id] = false;
      update([':favorite:datingHistoryItem:${datingHistoryModel.id}']);

      showToast('좋아요도중 오류가 발생했습니다.');
    } finally {
      favoriteLoadingProgressMap[datingHistoryModel.id] = false;

      /// rebuild 는 snapshot listener 에서 처리.
      // update([':favorite:datingHistoryItem:${datingHistoryModel.id}']);
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 27.
  /// @comment 커뮤니티 오픈 상태 토글 콜백
  ///
  Future<void> onTapIsCommunityOpen(DatingHistoryModel datingHistoryModel) async {
    if (userCtrl.currentUser.uid != datingHistoryModel.userId) {
      showToast('올바르지 않은 요청입니다.');
      return;
    }

    try {
      isCommunityOpenLoadingProgressMap[datingHistoryModel.id] = true;
      update([':isCommunityOpen:datingHistoryItem:${datingHistoryModel.id}']);

      final docRef = FirebaseFirestore.instance
          .collection(FireStoreCollectionName.datingHistory)
          .doc(datingHistoryModel.id);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = (await transaction.get(docRef)).data();

        final isOpenToCommunity = snapshot?['isOpenToCommunity'] ?? false;

        transaction.update(docRef, {'isOpenToCommunity': !isOpenToCommunity});
      });
    } catch (_) {
      isCommunityOpenLoadingProgressMap[datingHistoryModel.id] = false;
      update([':isCommunityOpen:datingHistoryItem:${datingHistoryModel.id}']);

      showToast('공개상태 변경도중 오류가 발생했습니다.');
    } finally {
      isCommunityOpenLoadingProgressMap[datingHistoryModel.id] = false;

      /// rebuild 는 snapshot listener 에서 처리.
    }
  }
}
