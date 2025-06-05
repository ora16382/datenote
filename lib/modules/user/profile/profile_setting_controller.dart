import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/models/user/user_model.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/constant/config/fire_store_collection_name.dart';
import 'package:datenote/util/mixin/controller_loading_mix.dart';
import 'package:datenote/util/widget/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileSettingViewController extends GetxController with ControllerLoadingMix {
  final RxString name = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 로딩 상태 표시
  bool isConflictNickname = false;

  /// 이름을 추가하여 최종적으로 저장
  Future<void> registerUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    
    startLoading();

    final user = _auth.currentUser;

    String nickname = name.value.trim();

    if (user == null || nickname.length < 2) {
      Fluttertoast.showToast(msg: '닉네임은 2자 이상으로 입력해주세요.');
      endLoading();

      return;
    }

    /// 중복 검사
    final query = await FirebaseFirestore.instance
        .collection(FireStoreCollectionName.users)
        .where('displayName', isEqualTo: nickname)
        .limit(1)
        .get();

    if(query.docs.isNotEmpty){
      isConflictNickname = true;
      update([':conflictNicknameText']);

      endLoading();
      return;
    }

    try {
      final doc = FirebaseFirestore.instance.collection(FireStoreCollectionName.users).doc(user.uid);

      await doc.set({
        'uid': user.uid,
        'displayName': nickname,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      GetStorage().write('isSignupFinished', true);

      /// 유저 상태 초기화
      await Get.find<UserController>().loadUser();
    } catch (e) {
      showToast('사용자 등록 도중 오류가 발생하였습니다 잠시 후 다시 시도해주세요.');
    } finally {
      endLoading();
    }

  }

  /// 닉네임 변경 콜백
  void onChangeNicknameField(String value) {
    isConflictNickname = false;
    update([':conflictNicknameText']);

    name.value = value;
  }
}
