import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datenote/modules/user/user_controller.dart';
import 'package:datenote/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Rxn<User> firebaseUser = Rxn<User>();

  /// 로딩 스핀 위젯 표시 상태
  bool isLoginProgress = false;

  @override
  void onInit() {
    super.onInit();
    /// Splash 와 동작이 겹치는 문제로 인하여 주석 처리
    // firebaseUser.bindStream(_auth.authStateChanges());
    // ever(firebaseUser, _handleAuthChanged);
  }

  /// 로그인 완료 콜백
  void _handleAuthChanged(User? user) async {
    if (user != null) {
      bool isRegistered = await isUserRegistered(user);

      if(isRegistered) {
        await Get.find<UserController>().loadUser();
      } else {
        Get.offAllNamed(Routes.profileSetting);
      }
    } else {
      Get.offAllNamed(Routes.auth);
    }
  }

  /// 구글 로그인
  Future<void> signInWithGoogle() async {
    try {
      isLoginProgress = true;
      update([':loading']);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      _handleAuthChanged(_auth.currentUser);
    } catch (e) {
      Get.snackbar('로그인 실패', e.toString());
    } finally {
      isLoginProgress = false;
      update([':loading']);
    }
  }

  /// 가입 처리
  /// return true : 이미 가입 되어있는 경우
  ///         false : 가입이 되어있지 않은 경우
  Future<bool> isUserRegistered(User user) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await doc.get();

    return snapshot.exists;
  }

  /// 로그아웃 메소드
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _handleAuthChanged(null);
  }
}
