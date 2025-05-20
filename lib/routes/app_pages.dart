
import 'package:datenote/modules/home/home_view.dart';
import 'package:datenote/modules/main/recommendPlan/detail/recommend_plan_detail_view.dart';
import 'package:datenote/modules/main/recommendPlan/edit/recommend_plan_edit_view.dart';
import 'package:datenote/modules/main/recommendPlan/place/search/place_search_view.dart';
import 'package:datenote/modules/main/recommendPlan/recommend_plan_view.dart';
import 'package:datenote/modules/splash/splash_view.dart';
import 'package:datenote/modules/user/address/daum_post_web/daum_post_web_view.dart';
import 'package:datenote/modules/user/address/manage/address_manage_view.dart';
import 'package:datenote/modules/user/address/search/address_search_view.dart';
import 'package:datenote/modules/user/auth/auth_view.dart';
import 'package:datenote/modules/user/collecting_infomation/collecting_information_view.dart';
import 'package:datenote/modules/user/profile/profile_setting_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: Routes.splash, page: () => const SplashView()),

    /// 로그인 관련
    GetPage(name: Routes.auth, page: () => const AuthView()),
    GetPage(name: Routes.profileSetting, page: () => const ProfileSettingView()),
    GetPage(name: Routes.collectInformation, page: () => const CollectingInformationView()),

    /// 주소 관련
    GetPage(name: Routes.addressManage, page: () => const AddressManageView()),
    GetPage(name: Routes.addressSearch, page: () => const AddressSearchView()),
    GetPage(name: Routes.daumPostWeb, page: () => const DaumPostWebView()),

    /// 메인
    GetPage(name: Routes.home, page: () => HomeView()),

    /// 데이트 플랜
    GetPage(name: Routes.recommendPlan, page: () => const RecommendPlanView()),
    GetPage(name: Routes.recommendPlanDetail, page: () => const RecommendPlanDetailView()),
    GetPage(name: Routes.recommendPlanEdit, page: () => const RecommendPlanEditView()),

    /// 데이트 플랜 - 플레이스
    GetPage(name: Routes.placeSearch, page: () => const PlaceSearchView()),
  ];
}