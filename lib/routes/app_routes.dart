part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splash = '/splash';

  /// user 관련
  static const auth = '/auth';
  static const profileSetting = '/profile_setting';
  static const collectInformation = '/collect_information';

  /// 주소 관련
  static const addressManage = '/address_manage';
  static const addressSearch = '/address_search';
  static const daumPostWeb = '/daum_post_web';

  /// 메인
  static const home = '/home';

  /// 데이트 플랜
  static const recommendPlan = '/recommend_plan';
  static const recommendPlanDetail = '/recommend_plan_detail';
  static const recommendPlanEdit = '/recommend_plan_edit';
  static const recommendPlanList = '/recommend_plan_list';

  /// 데이트 플랜 - 플레이스 관리
  static const placeSearch = '/place_search';

  /// 데이트 기록
  static const datingHistoryDetail = '/dating_history_detail';
  static const datingHistoryEdit = '/dating_history_edit';
  static const datingHistoryList = '/dating_history_list';

}