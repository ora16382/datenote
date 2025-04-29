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

  static const home = '/home';
}