import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/constant/config/config_value.dart';
import 'package:datenote/constant/config/fire_storage_folder_name.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/constant/enum/assets_type.dart';
import 'package:datenote/constant/enum/mood_type.dart';
import 'package:datenote/main.dart';
import 'package:datenote/models/asset/asset_model.dart';
import 'package:datenote/models/dating_history/dating_history_model.dart';
import 'package:datenote/models/recommend_plan/recommend_plan_model.dart';
import 'package:datenote/modules/main/main_controller.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:datenote/util/file/fileUtils.dart';
import 'package:datenote/util/functions/common_functions.dart';
import 'package:datenote/util/image/image_util.dart';
import 'package:datenote/util/mixin/controller_loading_mix.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:datenote/util/widget/dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class DatingHistoryEditController extends GetxController with ControllerLoadingMix {
  /// 수정 모드 여부
  final isModify = Get.parameters['isModify'] == 'true';

  /// 수정에서만 사용되는 DatingHistoryModel
  late final DatingHistoryModel datingHistoryModel;

  final userCtrl = Get.find<UserController>();

  /// 이미지 / 영상 선택기
  final picker = ImagePicker();

  /// 본문 텍스트 컨트롤러
  final descriptionController = TextEditingController();

  /// 본문 텍스트 포커스 노드
  FocusNode descriptionFocusNode = FocusNode();

  /// 태그 텍스트 컨트롤러
  final tagController = TextEditingController();

  /// 데이트 기분
  Rx<MoodType> selectedMood = Rx<MoodType>(MoodType.happy);

  /// 데이트 날짜
  final selectedDate = DateTime.now().obs;

  /// 추가된 태그 목록
  final List<String> tags = [];

  /// 이미지, 영상 첨부파일 목록
  final List<AssetModel> assetList = [];

  /// asset id : [image 혹은 video, video 일 경우 thumbnail] 형식으로 저장되는 파일 맵
  final Map<String, List<XFile>> assetFileMap = {};

  /// 삭제된 asset list (수정에서 사용)
  final List<AssetModel> removedAssetList = [];

  /// 관련된 데이트 플랜
  Rxn<RecommendPlanModel> selectedRecommendPlan = Rxn(null);

  /// 첨부파일 관련 처리 로딩 상태
  bool isImageAssetFileLoadingProgress = false;

  /// 비디오 파일 압축 관련 처리 로딩 상태
  bool isVideoAssetFileLoadingProgress = false;

  /// 게시글 업로드 상태
  bool isPostingProgress = false;

  /// google cloud storage
  final storage = FirebaseStorage.instanceFor(bucket: ConfigValue.gcsBucketName).ref();

  /// 커뮤니티 공개 여부
  RxBool isOpenToCommunity = true.obs;

  @override
  void onInit() {
    if (isModify) {
      if (Get.arguments is DatingHistoryModel) {
        datingHistoryModel = Get.arguments as DatingHistoryModel;

        /// 데이터 초기화
        descriptionController.text = datingHistoryModel.description;
        tags.addAll(datingHistoryModel.tags);
        selectedMood.value = datingHistoryModel.mood;
        selectedDate.value = datingHistoryModel.date;

        assetList.addAll(datingHistoryModel.assets);

        if (datingHistoryModel.recommendPlanId != null) {
          selectRecommendPlanDetail(datingHistoryModel.recommendPlanId!);
        }

        isOpenToCommunity.value = datingHistoryModel.isOpenToCommunity;
      }
    }
    super.onInit();
  }

  @override
  void onReady() {
    if (isModify) {
      if (Get.arguments is! DatingHistoryModel) {
        showToast('데이트 기록 데이터가 유효하지 않습니다.');

        /// init 에 안 하고 ready 에 한 이유는
        /// init 에서 Get.back 할 경우 해당 컨트롤러가 메모리에서 해제되지 않기 때문
        Get.back();
      }
    }
    super.onReady();
  }

  @override
  void onClose() {
    /// 임시 파일 제거
    FileUtils.deleteTempFileStorage();

    descriptionController.dispose();
    tagController.dispose();
    super.onClose();
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 뒤로가기 버튼 콜백
  ///
  Future<void> onTapBackBtn() async {
    if (await showTwoButtonDialog(
      contents: '데이트 기록 ${isModify ? '수정' : '저장'}을 취소하시겠습니까?',
      positiveButton: '확인',
      negativeButton: '취소',
      positiveCallBack: () {
        Get.back(result: true);
      },
    )) {
      if (isPostingProgress) {
        showToast('데이트 기록 업로드중입니다.');
        return;
      }

      /// PopScope 때문에 result 를 주지만 실제로 값이 사용되지는 않는다.
      Get.back(result: false);
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 저장 콜백
  ///
  Future<void> onTapSave() async {
    /// 압축 중에는 저장 불가능하도록 처리
    if (isImageAssetFileLoadingProgress || isVideoAssetFileLoadingProgress) {
      showToast('첨부파일 처리중입니다. 잠시만 기다려주세요');
      return;
    }

    if (descriptionController.text.isEmpty) {
      showToast('본문 내용은 필수입니다.');
      descriptionFocusNode.requestFocus();
      return;
    }

    isPostingProgress = true;

    startLoading();

    /// 사진/영상 우선 업로드
    if (assetList.isNotEmpty) {
      int uploadedCount = 0;

      /// Race condition 을 위한 Lock 객체
      /// Race condition : 여러 작업(쓰레드, async 함수 등)이 동시에 같은 자원(데이터, 변수 등)에 접근해서, 실행 순서에 따라 결과가 달라지는 현상
      final uploadedCountLock = Lock();

      RxDouble progressPercent = 0.0.obs;
      RxString uploadProgressDialogTitle = '$uploadedCount/${assetList.length} 번째 파일 업로드 완료'.obs;

      showUploadProgressDialog(title: uploadProgressDialogTitle, percent: progressPercent, isDismissible: false);

      /// 병렬로 업로드 실행
      List<AssetModel> uploadedAssetList = await Future.wait(
        assetList.map((assetModel) async {
          String? downloadUrl;
          String? thumbnailDownloadUrl;

          try {
            XFile? assetFile = assetFileMap[assetModel.id]?.firstOrNull;

            /// 파일 업로드
            if (assetFile != null) {
              final fileRef = storage.child('${FireStorageFolderName.datingHistory}${assetFile.name}');

              UploadTask uploadTask = fileRef.putFile(File(assetFile.path));
              final snapshot = await uploadTask;
              downloadUrl = await (snapshot).ref.getDownloadURL();
            }

            /// 비디오일 경우에만 썸네일까지 업로드
            if (assetModel.type == AssetType.video) {
              XFile? thumbnailAssetFile = assetFileMap[assetModel.id]?[1];

              if (thumbnailAssetFile != null) {
                final fileRef = storage.child('${FireStorageFolderName.datingHistory}${thumbnailAssetFile.name}');

                UploadTask uploadTask = fileRef.putFile(File(thumbnailAssetFile.path));
                final snapshot = await uploadTask;
                thumbnailDownloadUrl = await (snapshot).ref.getDownloadURL();
              }
            }

            await uploadedCountLock.synchronized(() async {
              /// 이 블록은 동시에 하나의 task만 실행됨
              uploadProgressDialogTitle.value = '${++uploadedCount}/${assetList.length} 번째 파일 업로드 완료';
              progressPercent.value = uploadedCount / assetList.length;
            });
          } catch (e) {
            /// 모종의 이유로 업로드 되지 않은 이미지도 있을텐데,
            /// => AssetModel 은 저장시키고, 이미지는 그냥 표시할때 에러 이미지로 표시한다.
          }

          return assetModel.copyWith(url: downloadUrl, thumbnailUrl: thumbnailDownloadUrl);
        }),
      );

      /// url 이 추가된 새로운 assetModelList
      List<AssetModel> newSortedAssetList = [];

      for (var assetModel in assetList) {
        try {
          newSortedAssetList.add(uploadedAssetList.firstWhere((element) => element.id == assetModel.id));
        } catch (e) {
          /// 오류가 생겼을 경우 해당 asset 은 패스한다.
        }
      }

      /// 변경된 데이터로 update
      assetList.clear();
      assetList.addAll(newSortedAssetList);

      Get.back();
    }

    try {
      String datingHistoryId = const Uuid().v4();

      datingHistoryModel = DatingHistoryModel(
        id: datingHistoryId,
        description: descriptionController.text.trim(),
        mood: selectedMood.value,
        tags: tags,
        assets: assetList,
        recommendPlanId: selectedRecommendPlan.value?.id,
        userId: userCtrl.currentUser.uid,
        isOpenToCommunity: isOpenToCommunity.value,
        createdAt: DateTime.now(),
        modifiedAt: DateTime.now(),
        date: selectedDate.value,
      );

      await FirebaseFirestore.instance
          .collection(FireStoreCollectionName.datingHistory)
          .doc(datingHistoryId)
          .set(datingHistoryModel.toJson());

      /// 메인-캘린더 업데이트
      try {
        final mainCtrl = Get.find<MainController>();
        mainCtrl.updateDatingHistoryData(selectedDate.value);
      } catch (e) {
        /// 별다른 동작 없음
      }

      showToast('데이트 기록이 추가되었습니다.');

      /// result 의미 없음
      Get.back(result: false);

      /// 상세 페이지로 이동
      Get.toNamed(Routes.datingHistoryDetail, arguments: datingHistoryModel);
    } catch (e) {
      showToast('데이트 기록 업로드중 오류가 발생하였습니다. 잠시 후 다시 시도해주세요');
    } finally {
      isPostingProgress = false;
      endLoading();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 수정 콜백
  ///
  Future<void> onTapModify() async {
    /// 압축 중에는 저장 불가능하도록 처리
    if (isImageAssetFileLoadingProgress || isVideoAssetFileLoadingProgress) {
      showToast('첨부파일 처리중입니다. 잠시만 기다려주세요');
      return;
    }

    if (descriptionController.text.isEmpty) {
      showToast('본문 내용은 필수입니다.');
      descriptionFocusNode.requestFocus();
      return;
    }

    isPostingProgress = true;

    startLoading();

    /// 새롭게 추가된 파일 목록
    List<AssetModel> newlyAddedAssetList = assetList.where((element) => element.url == null).toList();

    /// 사진/영상 우선 업로드
    if (newlyAddedAssetList.isNotEmpty) {
      int uploadedCount = 0;

      /// Race condition 을 위한 Lock 객체
      /// Race condition : 여러 작업(쓰레드, async 함수 등)이 동시에 같은 자원(데이터, 변수 등)에 접근해서, 실행 순서에 따라 결과가 달라지는 현상
      final uploadedCountLock = Lock();

      RxDouble progressPercent = 0.0.obs;
      RxString uploadProgressDialogTitle = '$uploadedCount/${newlyAddedAssetList.length} 번째 파일 업로드 완료'.obs;

      showUploadProgressDialog(title: uploadProgressDialogTitle, percent: progressPercent, isDismissible: false);

      /// 병렬로 업로드 실행
      List<AssetModel> uploadedAssetList = await Future.wait(
        newlyAddedAssetList.map((assetModel) async {
          String? downloadUrl;
          String? thumbnailDownloadUrl;

          try {
            XFile? assetFile = assetFileMap[assetModel.id]?.firstOrNull;

            /// 파일 업로드
            if (assetFile != null) {
              final fileRef = storage.child('${FireStorageFolderName.datingHistory}${assetFile.name}');

              UploadTask uploadTask = fileRef.putFile(File(assetFile.path));
              final snapshot = await uploadTask;
              downloadUrl = await (snapshot).ref.getDownloadURL();
            }

            /// 비디오일 경우에만 썸네일까지 업로드
            if (assetModel.type == AssetType.video) {
              XFile? thumbnailAssetFile = assetFileMap[assetModel.id]?[1];

              if (thumbnailAssetFile != null) {
                final fileRef = storage.child('${FireStorageFolderName.datingHistory}${thumbnailAssetFile.name}');

                UploadTask uploadTask = fileRef.putFile(File(thumbnailAssetFile.path));
                final snapshot = await uploadTask;
                thumbnailDownloadUrl = await (snapshot).ref.getDownloadURL();
              }
            }

            await uploadedCountLock.synchronized(() async {
              /// 이 블록은 동시에 하나의 task만 실행됨
              uploadProgressDialogTitle.value = '${++uploadedCount}/${newlyAddedAssetList.length} 번째 파일 업로드 완료';
              progressPercent.value = uploadedCount / newlyAddedAssetList.length;
            });
          } catch (e) {
            /// 모종의 이유로 업로드 되지 않은 이미지도 있을텐데,
            /// => AssetModel 은 저장시키고, 이미지는 그냥 표시할때 에러 이미지로 표시한다.
          }

          return assetModel.copyWith(url: downloadUrl, thumbnailUrl: thumbnailDownloadUrl);
        }),
      );

      /// url 이 추가된 새로운 assetModelList
      newlyAddedAssetList =
          newlyAddedAssetList
              .map((assetModel) => uploadedAssetList.firstWhere((element) => element.id == assetModel.id))
              .toList();

      /// assetList 를 기존에 추가된 파일과 새롭게 추가된 파일 순서에 맞춰서 재구성
      List<AssetModel> newAssetList =
          assetList.map<AssetModel>((assetModel) {
            if (assetModel.url != null) {
              /// 기존에 추가되어있었던 파일의 경우
              /// 바로 추가
              return assetModel;
            } else {
              /// 새롭게 추가한 파일의 경우
              return newlyAddedAssetList.firstWhere((element) => element.id == assetModel.id);
            }
          }).toList();

      assetList.clear();
      assetList.addAll(newAssetList);

      /// 삭제된 asset 파일 제거
      await Future.wait(
        removedAssetList.map((asset) async {
          try {
            if (asset.url != null) {
              await storage.child(extractStoragePathFromUrl(asset.url!)).delete();
            }

            /// 비디오일 경우 썸네일도 제거
            if (asset.type == AssetType.video) {
              if (asset.thumbnailUrl != null) {
                await storage.child(extractStoragePathFromUrl(asset.thumbnailUrl!)).delete();
              }
            }
          } catch (_) {
            /// 삭제 실패시 별다른 처리하지 않는다.
          }

          return;
        }),
      );

      Get.back();
    }

    try {
      String datingHistoryId = datingHistoryModel.id;

      await FirebaseFirestore.instance
          .collection(FireStoreCollectionName.datingHistory)
          .doc(datingHistoryId)
          .update(
            datingHistoryModel
                .copyWith(
                  description: descriptionController.text.trim(),
                  mood: selectedMood.value,
                  date: selectedDate.value,
                  isOpenToCommunity: isOpenToCommunity.value,
                  modifiedAt: DateTime.now(),
                  tags: tags,
                  assets: assetList,
                  recommendPlanId: selectedRecommendPlan.value?.id,
                )
                .toJson(),
          );

      showToast('데이트 기록이 수정되었습니다.');

      Get.back(result: true);
    } catch (e) {
      showToast('데이트 기록 수정중 오류가 발생하였습니다. 잠시 후 다시 시도해주세요');
    } finally {
      isPostingProgress = false;
      endLoading();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 이미지 추가 콜백
  ///
  Future<void> onTapAddPhoto() async {
    try {
      List<XFile> pickedImageList = await picker.pickMultiImage();

      /// 안드로이드에서는 아래에 대한 처리를 해줘야 한다. 필수는 아님
      /// retrieveLostData()는 내부적으로 이미지 선택 후 앱이 강제 종료됐거나 재시작된 경우, Flutter로 전달되지 못했던 파일을 복구한다.
      /// 근데 복구된 데이터가 어느 파일인지 식별하긴 어려우니 그냥 끝에 추가하고 기존거는 삭제하도록 하는게 좋을듯
      // final LostDataResponse response = await picker.retrieveLostData();
      // if (response.isEmpty) {
      //   return;
      // }
      // final List<XFile>? files = response.files;
      // if (files != null) {
      //   _handleLostFiles(files);
      // } else {
      //   _handleError(response.exception);
      // }
      if (pickedImageList.isNotEmpty) {
        isImageAssetFileLoadingProgress = true;
        startLoading();

        await Future.wait(
          pickedImageList.map((pickedImage) async {
            /// iOS 에서는 webp로 변경시 지나치게 오래걸리는 문제때문에 압축하지 않는다.
            if (Platform.isAndroid) {
              pickedImage = await FileUtils.getCompressImage(pickedImage);
            }

            if (await pickedImage.length() > ConfigValue.maxPhotoSize) {
              /// 파일 용량이 초과됐을 경우

              showToast('사진 파일 용량은 ${fileSizeMark(ConfigValue.maxVideoSize)}를 초과할 수 없습니다.');
              return;
            }

            String assetId = Uuid().v4();

            assetFileMap[assetId] = [pickedImage];

            /// 첨부 파일 목록에 데이터 추가
            assetList.add(AssetModel(id: assetId, type: AssetType.image, createdAt: DateTime.now()));

            update([':assetFileList']);
          }),
        );
      }
    } on PlatformException catch (e) {
      /// iOS / Android 카메라 권한 error
      if (await Permission.photos.status != PermissionStatus.granted) {
        showToast("사진에 대한 접근 권한이 없습니다. 권한을 허용해주세요".tr);

        Future.delayed(const Duration(seconds: 3)).then((value) {
          openAppSettings();
        });
      } else {
        showToast(e.toString());
      }
    } catch (e) {
      /// 이미지 선택 / 크롭중 오류가 발생한 경우
      showToast('이미지 추가중 오류가 발생하였습니다.'.tr);
    } finally {
      isImageAssetFileLoadingProgress = false;
      endLoading();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 동영상 추가 콜백
  ///
  Future<void> onTapAddVideo() async {
    try {
      XFile? pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

      if (pickedVideo != null) {
        if (await pickedVideo.length() == 0) {
          /// 유효하지 않은 파일이 첨부되었을 경우 제외
          showToast('유효하지 않은 파일입니다.');
          return;
        }

        XFile? thumbnailFile;

        /// 숨기기 버튼 클릭 여부
        bool isHideBtnClicked = false;

        isVideoAssetFileLoadingProgress = true;

        String assetId = Uuid().v4();
        AssetModel videoAssetModel = AssetModel(id: assetId, type: AssetType.video, createdAt: DateTime.now());

        /// ### 동영상 압축 시작
        try {
          /// 다이얼로그에서 사용될 변수
          RxDouble progressPercent = 0.0.obs;
          RxString compressProgressDialogTitle = ''.obs;

          Subscription? subscription;

          showCompressProgressDialog(
            title: compressProgressDialogTitle,
            percent: progressPercent,
            isDismissible: false,
            hideBtnCallback: () async {
              isHideBtnClicked = true;
              subscription?.unsubscribe();

              /// 첨부 파일 목록에 데이터 추가
              assetList.add(videoAssetModel);

              /// 로딩 표시를 위한 프로그래스 파일 추가
              assetFileMap[assetId] = [XFile(''), await FileUtils.assetToXFile('assets/images/icon/loading.gif')];
              update([':assetFileList']);

              Get.back();
            },
          );

          try {
            progressPercent.value = 0.0;
            compressProgressDialogTitle.value = '동영상 파일을 압축하는중...';

            subscription = VideoCompress.compressProgress$.subscribe((progress) {
              progressPercent.value = progress;
            });

            MediaInfo? mediaInfo = await VideoCompress.compressVideo(
              pickedVideo.path,

              /// 추후 퀄리티 변경 필요시 변경
              quality: VideoQuality.DefaultQuality,

              /// 압축 실패시 기본거 사용해야함
              deleteOrigin: false,
            );

            if (mediaInfo != null && mediaInfo.file != null) {
              pickedVideo = XFile(
                mediaInfo.path ?? '',
                name: mediaInfo.file!.path.split('/').last,
                length: mediaInfo.filesize,
              );

              logger.i(pickedVideo.path);
            } else {
              /// 압축이 실패했을 경우 기존 파일 그대로 업로드
            }

            /// 비디오 파일 사이즈 검사 로직 추가
            if (await pickedVideo.length() > ConfigValue.maxVideoSize) {
              /// 파일 용량이 초과됐을 경우
              showToast('동영상 파일 용량은 ${fileSizeMark(ConfigValue.maxVideoSize)}를 초과할 수 없습니다.');
              return;
            }
          } catch (_) {
            showToast('비디오 파일을 압축하는 도중 오류가 발생하였습니다.');

            /// 비디오 압축 과정에서 오류 발생시 별다른 조치 하지 않는다.
          } finally {
            subscription?.unsubscribe();
          }

          /// ### 동영상 압축 종료

          /// ### 동영상 썸네일 추출 시작
          try {
            final tempDir = await FileUtils.tempDirectoryCheck();

            /// 동영상 파일 추가 전 썸네일 이미지 추가
            final thumbnailFilePath = await VideoThumbnail.thumbnailFile(
              video: pickedVideo!.path,
              thumbnailPath: tempDir.path,
              imageFormat: ImageFormat.WEBP,
              maxHeight: 480,
              // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
              quality: 90,
            );

            if (thumbnailFilePath == null) {
              /// 썸네일 이미지 생성 실패일 경우 빈 경로의 파일을 추가
              /// errorBuilder 를 통해서 에러 이미지 표시
              throw Exception();
            } else {
              var tempThumbnailFile = File(thumbnailFilePath);

              thumbnailFile = XFile(
                tempThumbnailFile.path,
                name: tempThumbnailFile.path.split('/').last,
                length: tempThumbnailFile.lengthSync(),
              );
            }
          } catch (_) {
            /// 썸네일 추출 실패시 에러 이미지로 처리
            thumbnailFile = XFile('');
          }

          /// ### 동영상 썸네일 추출 종료
        } catch (_) {
          showToast("동영상 추가중 오류가 발생하였습니다.");
        } finally {
          isVideoAssetFileLoadingProgress = false;

          /// dialog 닫기 처리
          if (!isHideBtnClicked) {
            Get.back();
          }
        }

        assetFileMap[assetId] = [pickedVideo!, thumbnailFile!];

        /// 숨기기 하지 않았을 경우에만
        if (!isHideBtnClicked) {
          /// 첨부 파일 목록에 데이터 추가
          assetList.add(videoAssetModel);
        }

        update([':assetFileList']);
      }
    } on PlatformException catch (e) {
      /// iOS / Android 카메라 권한 error
      if (await Permission.videos.status != PermissionStatus.granted) {
        showToast("동영상에 대한 접근 권한이 없습니다. 권한을 허용해주세요");

        Future.delayed(const Duration(seconds: 3)).then((value) {
          openAppSettings();
        });
      } else {
        showToast(e.toString());
      }
    } catch (e) {
      showToast('동영상 추가중 오류가 발생하였습니다.'.tr);
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 첨부파일 삭제 콜백
  ///
  void onTapDeleteMedia(AssetModel asset) {
    assetFileMap.remove(asset.id);
    assetList.remove(asset);
    update([':assetFileList']);

    if (isModify) {
      removedAssetList.add(asset);
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 첨부파일 순서 변경 콜백
  ///
  void onReorderMedia(int oldIndex, int newIndex) {
    AssetModel oldAsset = assetList.removeAt(oldIndex);
    assetList.insert(newIndex, oldAsset);
    update([':assetFileList']);
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 관련된 데이트 플랜 선택/변경 콜백
  ///
  Future<void> onTapRecommendPlanEdit() async {
    RecommendPlanModel? recommendPlanModel =
        (await Get.toNamed(Routes.recommendPlanList, parameters: {'isSelectMode': 'true'})) as RecommendPlanModel?;

    if (recommendPlanModel != null) {
      selectedRecommendPlan.value = recommendPlanModel;
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 관련된 데이트 플랜 삭제 콜백
  ///
  void onTapRecommendPlanDelete() {
    selectedRecommendPlan.value = null;
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 기분 선택 콜백
  ///
  void onSelectedMood(MoodType mood) {
    selectedMood.value = mood;
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 태그 입력 완료 콜백
  ///
  void onChangedTagInput(value, {bool isOnSubmitted = false}) {
    if (value.endsWith(' ') || isOnSubmitted) {
      final input = value.trim();
      if (input.isNotEmpty && !tags.contains(input)) {
        tags.add(input);
        update([':tagChips']);
      }

      tagController.clear();
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 21.
  /// @comment 태그 삭제 콜백
  ///
  void onDeleteTagChip(String tag) {
    tags.remove(tag);
    update([':tagChips']);
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 첨부파일 클릭 콜백
  ///
  Future<void> onTapMedia(AssetModel asset) async {
    /// 동영상은 별다른 처리 없음
    if (asset.type == AssetType.image) {
      if (assetFileMap[asset.id]?[0] != null) {
        XFile imageFile = assetFileMap[asset.id]![0];
        final croupImage = await ImageUtil.cropImage(imageFile.path);

        /// 이미지를 잘랐을 경우에만
        if (croupImage != null) {
          assetFileMap[asset.id]![0] = XFile(croupImage.path);
          update([':assetPreview:${asset.id}']);
        }
      }
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 데이트 날짜 선택 콜백
  ///
  Future<void> onTapDatePicker() async {
    if(isModify) {
      /// date 순서로 불러오는 목록에서 정렬이 깨지는 문제때문에 date 는 수정 불가능하게 막는다.
      showToast('데이트 날짜는 수정이 불가능합니다.');
      return;
    }

    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now(),
      cancelText: '닫기',
      confirmText: '확인',
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 커뮤니티 공개 체크박스 클릭 콜백
  ///
  void onTapOpenToCommunity(bool? v) {
    isOpenToCommunity.value = !isOpenToCommunity.value;
  }

  /// @author 정준형
  /// @since 2025. 5. 22.
  /// @comment 데이트 플랜 데이터 상세 정보 조회
  ///
  Future<void> selectRecommendPlanDetail(String recommendPlanId) async {
    Map<String, dynamic>? recommendPlanModelMap =
        (await FirebaseFirestore.instance
                .collection(FireStoreCollectionName.recommendDatePlan)
                .doc(recommendPlanId)
                .get())
            .data();

    if (recommendPlanModelMap != null) {
      selectedRecommendPlan.value = RecommendPlanModel.fromJson(recommendPlanModelMap);
    }
  }
}
