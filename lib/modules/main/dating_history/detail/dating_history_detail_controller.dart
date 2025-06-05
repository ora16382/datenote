import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/constant/enum/comment_page_type.dart';
import 'package:datenote/models/comment/comment_model.dart';
import 'package:datenote/models/dating_history/dating_history_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/models/user/user_model.dart';
import 'package:datenote/modules/main/main_controller.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/util/mixin/controller_loading_mix.dart';
import 'package:datenote/util/mixin/controller_with_video_player_mix.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:datenote/util/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:uuid/uuid.dart';

import '../../../../main.dart';

class DatingHistoryDetailController extends GetxController with ControllerLoadingMix, ControllerWithVideoPlayer {
  /// 커뮤니티로 진입했는지 여부
  // final isCommunity = Get.parameters['isCommunity'] == 'true';

  /// 유저 컨트롤러
  final userCtrl = Get.find<UserController>();

  /// 이미지 스크롤을 위한 페이지 컨트롤러
  final pageController = PageController(viewportFraction: 1);

  /// 데이트 기록 모델
  late DatingHistoryModel model;

  /// 데이트 플랜 로딩 상태
  bool isRecommendPlanLoading = true;

  /// 데이트 플랜 상세 기록
  RecommendPlanModel? recommendPlanModel;

  /// 데이터 로딩 상태
  bool isDataLoadingProgress = false;

  /// 좋아요 로딩 상태
  bool favoriteLoadingProgress = false;

  /// ##### 댓글 관련 필드
  ///
  /// 댓글 무한 스크롤 페이지 컨트롤러
  late final PagingController<int, CommentModel> commentPagingController;

  static const int pageSize = 10;

  /// lastDocumentSnapshot 가 삭제되었을 경우를 대비해 그 이전의 데이터를 임시 저장한다.
  List<DocumentSnapshot> lastDocumentSnapshotList = [];

  /// 댓글 텍스트 컨트롤러
  TextEditingController commentTextController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  /// 현재 답글 작성중인 댓글
  Rxn<CommentModel> replyCommentModel = Rxn();

  /// 답글이 달릴 최상위 댓글
  CommentModel? replyParentCommentModel;

  /// 현재 수정중인 댓글
  Rxn<CommentModel> editCommentModel = Rxn();

  /// 수정중인 댓글의 최상위 댓글
  CommentModel? editParentCommentModel;

  /// firestore 리스너 객체
  late final StreamSubscription _subscription;

  /// Firestore의 snapshots()는 앱에서 listen이 연결될 때마다 전체 데이터에 대해 최초로 한 번 added 이벤트를 전부 보냄.
  /// 최초 구독 이벤트 무시하기위한 플래그
  bool _isFirstSnapshot = true;

  /// 사용자 데이터 Map
  final Map<String, UserModel> userMap = {};

  @override
  void onInit() {
    if (Get.arguments is DatingHistoryModel) {
      model = Get.arguments;

      selectRecommendPlanDetail();
    }

    commentPagingController = PagingController<int, CommentModel>(
      fetchPage: _fetchCommentPage,
      getNextPageKey: (state) {
        if (state.keys?.isEmpty ?? true) return 0;

        final isLastPage = state.pages?.last.isEmpty ?? true;
        return isLastPage ? null : (state.keys?.last ?? 0) + 1;
      },
    );

    /// 추가된 데이터 실시간 업데이트
    _subscription = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.comment)
        .where('articleId', isEqualTo: model.id)
        .where('commentPageType', isEqualTo: CommentPageType.datingHistory.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) async {
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
                if (commentPagingController.pages?.firstOrNull?.isEmpty ?? true) {
                  onCommentRefresh();

                  /// 아래 방법이 안되는 이유는 이미 처음 요청에 대한 키가 추가되어 있기 때문이다.
                  /// 그럼 다음 키로 검색하게 되는데 처음 배열은 당연히 nodata 라 비어있기 때문에
                  /// last page 로 인식하게 되어 더이상 요청되지 않는것이다.
                  /// 그냥 refresh 하는게 편하다.
                  //pagingController.fetchNextPage();
                } else {
                  /// 아니면 제일 상단에 노출시키기 위해 첫번째 배열에 추가
                  commentPagingController.pages?.firstOrNull?.insert(0, CommentModel.fromJson(data));

                  update([':commentList']);
                }
              }
            } else if (documentChange.type == DocumentChangeType.modified) {
              Map<String, dynamic>? data = documentChange.doc.data();

              if (data != null) {
                outerLoop:
                for (final List<CommentModel> page in commentPagingController.pages ?? []) {
                  for (var commentModel in page.indexed) {
                    if (commentModel.$2.id == documentChange.doc.id) {
                      CommentModel findCommentModel = CommentModel.fromJson(data);

                      final userIds =
                          [
                                findCommentModel.userId,
                                ...findCommentModel.replies.map((r) => r.userId),
                                ...findCommentModel.replies.map((r) => r.parentUserId),
                              ]
                              .whereType<String>() // null 제거
                              .where((id) => !userMap.containsKey(id)) // 이미 조회된 유저 제거
                              .toSet()
                              .toList();

                      if (userIds.isNotEmpty) {
                        /// whereIn 30개 넘어가면 에러가 뜨니 배치처리한다.
                        for (int i = 0; i < userIds.length; i += 30) {
                          final batch = userIds.sublist(i, (i + 30).clamp(0, userIds.length));

                          final userSnapshot =
                              await FirebaseFirestore.instance
                                  .collection(FireStoreCollectionName.users)
                                  .where('uid', whereIn: batch)
                                  .get();

                          /// 사용자 uid → UserModel 매핑
                          for (var doc in userSnapshot.docs) {
                            userMap.putIfAbsent(doc['uid'], () => UserModel.fromJson(doc.data()));
                          }
                        }
                      }

                      /// 사용자 정보 추가
                      findCommentModel = findCommentModel.copyWith(
                        user: userMap[findCommentModel.userId],
                        replies:
                            findCommentModel.replies.map((replyComment) {
                              return replyComment.copyWith(
                                user: userMap[replyComment.userId],
                                parentUser: userMap[replyComment.parentUserId],
                              );
                            }).toList(),
                      );

                      page[commentModel.$1] = findCommentModel;
                      break outerLoop;
                    }
                  }
                }

                update([':comment:${documentChange.doc.id}']);
              }
            } else if (documentChange.type == DocumentChangeType.removed) {
              List<CommentModel>? containPage;
              CommentModel? findCommentModel;

              outerLoop:
              for (final List<CommentModel> page in commentPagingController.pages ?? []) {
                for (var commentModel in page.indexed) {
                  if (commentModel.$2.id == documentChange.doc.id) {
                    containPage = page;
                    findCommentModel = commentModel.$2;
                    break outerLoop;
                  }
                }
              }

              /// 아래같이 해도 된다.
              /// pagingController.items?.remove(findCommentModel);

              /// 요소 삭제
              containPage?.remove(findCommentModel);

              /// 리스트 업데이트
              update([':commentList']);
            }
          }
        });

    super.onInit();
  }

  @override
  void onReady() {
    if (Get.arguments is! DatingHistoryModel) {
      showToast('데이트 기록 데이터가 유효하지 않습니다.');

      /// init 에 안 하고 ready 에 한 이유는
      /// init 에서 Get.back 할 경우 해당 컨트롤러가 메모리에서 해제되지 않기 때문
      Get.back();
    }
    super.onReady();
  }

  @override
  void onClose() {
    commentPagingController.dispose();
    pageController.dispose();
    commentTextController.dispose();
    _subscription.cancel();

    super.onClose();
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 데이트 기록 수정 콜백
  ///
  Future<void> onTapEditBtn() async {
    /// 비디오 일시 정지
    pauseCurrentVideoPlayer(pageController, model.assets);

    /// else 수정으로 이동
    final bool result =
        ((await Get.toNamed(Routes.datingHistoryEdit, arguments: model, parameters: {'isModify': 'true'})) as bool?) ??
        false;

    if (result) {
      isDataLoadingProgress = true;
      update([':datingHistoryBody']);

      try {
        /// 수정 되었을 경우 데이터 다시 로드하기
        Map<String, dynamic>? datingHistoryModelMap =
            (await FirebaseFirestore.instance.collection(FireStoreCollectionName.datingHistory).doc(model.id).get())
                .data();

        if (datingHistoryModelMap != null) {
          model = DatingHistoryModel.fromJson(datingHistoryModelMap);
          selectRecommendPlanDetail();

          /// 메인-캘린더 업데이트
          try {
            final mainCtrl = Get.find<MainController>();
            mainCtrl.updateDatingHistoryData(model.date);
          } catch (e) {
            /// 별다른 동작 없음
            logger.e(e);
          }
        }
      } catch (e) {
        showToast('데이트 기록 조회에 실패했습니다. 잠시 후 다시 시도해 주세요.');
        return;
      } finally {
        isDataLoadingProgress = false;
        update([':datingHistoryBody']);
      }
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 데이트 기록 삭제 콜백
  ///
  Future<void> onTapDeleteBtn() async {
    try {
      if (!await showTwoButtonDialog(
        contents: '데이트 기록을 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        return;
      }

      startLoading();

      await FirebaseFirestore.instance.collection(FireStoreCollectionName.datingHistory).doc(model.id).delete();

      /// 메인-캘린더 업데이트
      try {
        final mainCtrl = Get.find<MainController>();
        mainCtrl.updateDatingHistoryData(model.date);
      } catch (e) {
        /// 별다른 동작 없음
      }

      showToast('데이트 기록 삭제가 완료되었습니다.');
      Get.back();
    } catch (_) {
      showToast('오류가 발생하였습니다. 잠시 후 다시 시도해주세요');
    } finally {
      endLoading();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 데이트 플랜 데이터 상세 정보 조회
  ///
  Future<void> selectRecommendPlanDetail() async {
    Map<String, dynamic>? recommendPlanModelMap =
        (await FirebaseFirestore.instance
                .collection(FireStoreCollectionName.recommendDatePlan)
                .doc(model.recommendPlanId)
                .get())
            .data();

    if (recommendPlanModelMap != null) {
      recommendPlanModel = RecommendPlanModel.fromJson(recommendPlanModelMap);
    }

    isRecommendPlanLoading = false;
    update([':recommendPlan']);
  }

  /// @author 정준형
  /// @since 2025. 5. 26.
  /// @comment 데이트 플랜 상세 페이지로 이동
  ///
  void onTapRecommendPlan() {
    if (recommendPlanModel != null) {
      pauseCurrentVideoPlayer(pageController, model.assets);

      Get.toNamed(Routes.recommendPlanDetail, arguments: recommendPlanModel, parameters: {'isCommunity': 'true'});
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 26.
  /// @comment 커뮤니티 공개 모드 수정 콜백
  ///
  Future<void> toggleCommunityOpen() async {
    try {
      if (!await showTwoButtonDialog(
        contents: '커뮤니티에 ${model.isOpenToCommunity ? '비' : ''}공개 하시겠습니까?',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        return;
      }

      startLoading();

      await FirebaseFirestore.instance.collection(FireStoreCollectionName.datingHistory).doc(model.id).update({
        'isOpenToCommunity': !model.isOpenToCommunity,
      });

      model = model.copyWith(isOpenToCommunity: !model.isOpenToCommunity);
      update([':isCommunityOpen']);
    } catch (_) {
      showToast('오류가 발생하였습니다. 잠시 후 다시 시도해주세요');
    } finally {
      endLoading();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 26.
  /// @comment 좋아요 클릭 콜백
  ///
  Future<void> onTapFavorite() async {
    final docRef = FirebaseFirestore.instance.collection(FireStoreCollectionName.datingHistory).doc(model.id);

    final currentUserId = userCtrl.currentUser.uid;

    try {
      favoriteLoadingProgress = true;
      update([':favorite']);

      late List<String> updatedLikedUserIds;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = (await transaction.get(docRef)).data();

        final likedUserIds = List<String>.from(snapshot?['likesUserId'] ?? []);

        updatedLikedUserIds =
            likedUserIds.contains(currentUserId)
                ? likedUserIds.where((e) => e != currentUserId).toList()
                : [...likedUserIds, currentUserId];

        transaction.update(docRef, {
          'likesUserId':
              likedUserIds.contains(currentUserId)
                  ? FieldValue.arrayRemove([currentUserId])
                  : FieldValue.arrayUnion([currentUserId]),
        });
      });

      /// 트랜잭션 안에서 업데이트된 데이터를 로컬에도 반영
      model = model.copyWith(likesUserId: updatedLikedUserIds);
    } catch (e) {
      showToast('좋아요도중 오류가 발생했습니다.');
    } finally {
      favoriteLoadingProgress = false;
      update([':favorite']);
    }
  }

  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 새로고침 콜백 함수
  ///
  void onCommentRefresh() {
    userMap.clear();
    commentPagingController.refresh();
  }

  /// @author 정준형
  /// @since 2025. 4. 18.
  /// @comment 피드(페이징) 로드
  ///
  Future<List<CommentModel>> _fetchCommentPage(int pageKey, {int retryCount = 0}) async {
    Query query = FirebaseFirestore.instance
        .collection(FireStoreCollectionName.comment)
        .where('articleId', isEqualTo: model.id)
        .where('commentPageType', isEqualTo: CommentPageType.datingHistory.name)
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
          return _fetchCommentPage(pageKey, retryCount: retryCount);
        } else {
          showToast('삭제된 데이터가 있어 페이지를 새로고침 합니다.');

          /// 고의적으로 딜레이를 넣어준다.
          Future.delayed(Duration(seconds: 1), () => onCommentRefresh());
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

    List<CommentModel> items =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return CommentModel.fromJson(data as Map<String, dynamic>);
        }).toList();

    /// 조회한적 없는 userId 리스트 추출
    ///  대댓글 까지 모든 닉네임 가져온다.
    final userIds =
        items
            .expand((e) => [e.userId, ...e.replies.map((r) => r.userId), ...e.replies.map((r) => r.parentUserId)])
            .whereType<String>() // null 제거
            .where((id) => !userMap.containsKey(id)) // 이미 조회된 유저 제거
            .toSet()
            .toList();

    if (userIds.isNotEmpty) {
      /// whereIn 30개 넘어가면 에러가 뜨니 배치처리한다.
      for (int i = 0; i < userIds.length; i += 30) {
        final batch = userIds.sublist(i, (i + 30).clamp(0, userIds.length));

        /// 각 데이터별 사용자 정보 불러오기
        /// userId in 조건으로 사용자 데이터 일괄 조회
        final userSnapshot =
            await FirebaseFirestore.instance
                .collection(FireStoreCollectionName.users)
                .where('uid', whereIn: batch)
                .get();

        /// 사용자 uid → UserModel 매핑
        for (var doc in userSnapshot.docs) {
          userMap.putIfAbsent(doc['uid'], () => UserModel.fromJson(doc.data()));
        }
      }

      /// 사용자 정보 추가
      items =
          items.map((comment) {
            return comment.copyWith(
              user: userMap[comment.userId],
              replies:
                  comment.replies.map((replyComment) {
                    return replyComment.copyWith(
                      user: userMap[replyComment.userId],
                      parentUser: userMap[replyComment.parentUserId],
                    );
                  }).toList(),
            );
          }).toList();
    }

    return items;
  }

  /// @author 정준형
  /// @since 2025. 5. 26.
  /// @comment 댓글 전송
  ///
  Future<void> onTapCommentSendBtn() async {
    try {
      startLoading();

      if (commentTextController.text.trim().isEmpty) {
        showToast('댓글을 입력해주세요');
        return;
      }

      String id = Uuid().v4();

      CommentModel commentModel = CommentModel(
        id: id,
        comment: commentTextController.text.trim(),
        userId: userCtrl.currentUser.uid,
        commentPageType: CommentPageType.datingHistory,
        articleId: model.id,
        createdAt: DateTime.now(),
        modifiedAt: DateTime.now(),
      );

      if (replyCommentModel.value != null) {
        /// 답글 작성인 경우

        if (replyParentCommentModel == null) {
          showToast('상위 댓글 데이터가 유효하지 않습니다. 잠시 후 다시 시도해주세요');
          return;
        }

        /// 답글 대상 사용자 유저 id 저장
        commentModel = commentModel.copyWith(parentUserId: replyCommentModel.value!.userId);

        await FirebaseFirestore.instance
            .collection(FireStoreCollectionName.comment)
            .doc(replyParentCommentModel!.id)
            .update({
              'replies': FieldValue.arrayUnion([commentModel.toJson()]),
              'modifiedAt': DateTime.now(),
            });

        commentTextController.text = '';
        cancelReply();
      } else if (editCommentModel.value != null) {
        /// 댓글 수정인 경우

        if (editParentCommentModel == null) {
          showToast('상위 댓글 데이터가 유효하지 않습니다. 잠시 후 다시 시도해주세요');
          return;
        }

        if (editParentCommentModel!.id == editCommentModel.value!.id) {
          /// 최상위 댓글 수정일 경우
          await FirebaseFirestore.instance
              .collection(FireStoreCollectionName.comment)
              .doc(editParentCommentModel!.id)
              .update(
                editParentCommentModel!
                    .copyWith(comment: commentTextController.text.trim(), isModify: true, modifiedAt: DateTime.now())
                    .toJson(),
              );
        } else {
          /// 답글 수정일 경우
          await FirebaseFirestore.instance
              .collection(FireStoreCollectionName.comment)
              .doc(editParentCommentModel!.id)
              .update({
                'replies':
                    editParentCommentModel!.replies.map((e) {
                      if (e.id == editCommentModel.value!.id) {
                        ///  수정할 데이터일 경우 텍스트 변경
                        return e
                            .copyWith(
                              comment: commentTextController.text.trim(),
                              isModify: true,
                              modifiedAt: DateTime.now(),
                            )
                            .toJson();
                      }
                      return e.toJson();
                    }).toList(),
                'modifiedAt': DateTime.now(),
              });
        }

        commentTextController.text = '';
        cancelEdit();
      } else {
        /// 그냥 댓글 작성일 경우
        await FirebaseFirestore.instance.collection(FireStoreCollectionName.comment).doc(id).set(commentModel.toJson());
      }
    } catch (e) {
      logger.e(e.toString());
      showToast('오류가 발생하였습니다. 잠시 후 다시 시도해주세요');
    } finally {
      endLoading();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 29.
  /// @comment 댓글 수정 콜백
  ///
  Future<void> onTapEditComment(CommentModel comment, bool isReply, CommentModel? parentComment) async {
    if (replyCommentModel.value != null) {
      if (!await showTwoButtonDialog(
        contents: '답글 작성중입니다. 취소하시겠습니까?',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        return;
      }

      /// 답글다는 중이었다면 초기화
      cancelReply();
    }

    commentTextController.text = comment.comment;
    commentFocusNode.requestFocus();

    editCommentModel.value = comment;
    editParentCommentModel = parentComment;
    update([':commentTile:${comment.id}']);
  }

  /// @author 정준형
  /// @since 2025. 5. 29.
  /// @comment 답글 달기 콜백
  ///
  Future<void> onTapReplyToComment(CommentModel comment, CommentModel? parentComment) async {
    if (editCommentModel.value != null) {
      if (!await showTwoButtonDialog(
        contents: '댓글 수정중입니다. 취소하시겠습니까?',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        return;
      }

      /// 수정중이었다면 초기화
      commentTextController.text = '';
      cancelEdit();
    }

    replyParentCommentModel = parentComment;
    replyCommentModel.value = comment;
    commentFocusNode.requestFocus();
  }

  /// @author 정준형
  /// @since 2025. 5. 29.
  /// @comment 댓글 삭제 콜백
  ///
  Future<void> onTapDeleteComment(CommentModel comment, bool isReply, CommentModel? parentComment) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      if (!await showTwoButtonDialog(
        contents: '댓글을 삭제하시겠습니까?',
        positiveButton: '확인',
        negativeButton: '취소',
        positiveCallBack: () {
          Get.back(result: true);
        },
      )) {
        return;
      }

      startLoading();

      if (isReply) {
        if (parentComment == null) {
          showToast('상위 댓글의 정보가 유효하지 않습니다.');
          return;
        }

        await FirebaseFirestore.instance.collection(FireStoreCollectionName.comment).doc(parentComment.id).update({
          ///  FieldValue.arrayRemove([comment.toJson()]), 이걸로 하면 완전 똑같지 않을경우 삭제가 무시되는 증상이 있음
          'replies': parentComment.replies.where((e) => e.id != comment.id).map((e) => e.toJson()).toList(),
          'modifiedAt': DateTime.now(),
        });
      } else {
        await FirebaseFirestore.instance.collection(FireStoreCollectionName.comment).doc(comment.id).delete();
      }

      showToast('댓글이 삭제되었습니다.');
    } catch (_) {
      showToast('오류가 발생하였습니다. 잠시 후 다시 시도해주세요');
    } finally {
      endLoading();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 29.
  /// @comment 코멘트 답글 취소 콜백
  ///
  void cancelReply() {
    replyCommentModel.value = null;
    replyParentCommentModel = null;
  }

  /// @author 정준형
  /// @since 2025. 5. 29.
  /// @comment 코멘트 수정 취소 콜백
  ///
  void cancelEdit() {
    if (editCommentModel.value != null) {
      update([':commentTile:${editCommentModel.value!.id}']);
      editCommentModel.value = null;
      editParentCommentModel = null;
      commentTextController.text = '';
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
