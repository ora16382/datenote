import 'dart:math';

/// @author 정준형
/// @since 2025. 5. 26.
/// @comment
/// /// 주어진 DateTime 값을 기반으로 간단한 정수 해시코드를 생성
/// year, month, day 값을 조합하여 동일한 날짜에는 항상 동일한 해시값을 반환
/// 시간 정보는 무시되며, 하루 단위 식별에 사용됨
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// @author 정준형
/// @since 2025. 5. 26.
/// @comment 파일 사이즈 포맷팅
///
String fileSizeMark(int bytes) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return (bytes ~/ pow(1024, i)).toString() + suffixes[i];
}

/// @author 정준형
/// @since 2025. 5. 26.
/// @comment Firebase Storage 경로에서 Storage 내부 경로(path) 추출
String extractStoragePathFromUrl(String url) {
  final uri = Uri.parse(url);
  final encodedPath = uri.pathSegments.contains('o') ? uri.pathSegments[uri.pathSegments.indexOf('o') + 1] : null;
  if (encodedPath == null) return '';

  return Uri.decodeComponent(encodedPath); // %2F → /
}
