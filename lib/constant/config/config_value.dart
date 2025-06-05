class ConfigValue{
  /// 최대 업로드 허용 사진 용량 (10MB)
  static const int maxPhotoSize = 10 * 1024 * 1024;
  static const int maxVideoSize = 50 * 1024 * 1024;

  /// Firebase Storage 버킷 경로
  static const String gcsBucketName = 'gs://datenote-29253.appspot.com';

}