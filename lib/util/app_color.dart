import 'package:flutter/material.dart';

/// App에서 사용하는 모든 색상은 이곳에서 관리
/// 컬러 네이밍은 Flutter의 ColorScheme 기준에 맞춤
class AppColors {
  /// 메인 컬러 (버튼, 강조 색상)
  static const primary = Color(0xFFec6853);

  /// 메인 컬러 연한 버전
  static const primarySoft = Color(0xFFfcd6cf);

  /// primary 위에 올라갈 텍스트/아이콘 컬러
  static const onPrimary = Colors.white;

  /// 보조 컬러 (태그, 강조 포인트 등)
  static const secondary = Color(0xFF3C3C43);

  /// secondary 위에 올라갈 텍스트/아이콘 컬러
  static const onSecondary = Colors.white;

  /// 전체 배경 색상 (Scaffold 등)
  static const background = Color(0xFFF9F9F9);

  /// background 위에 올라갈 텍스트 컬러
  static const onBackground = Colors.black;

  /// 카드, 바텀시트, 다이얼로그 등에서 사용될 surface 영역 배경
  static const surface = Colors.white;

  /// surface 위에 올라갈 텍스트/아이콘 컬러
  static const onSurface = Colors.black;

  /// 에러 상황에서 사용될 컬러 (ex. 검증 실패, 토스트 등)
  static const error = Colors.red;

  /// error 배경 위에 올라갈 텍스트/아이콘 컬러
  static const onError = Colors.white;

  static const disabled = Color(0xFFB0B3B8);

  static const grey = Color(0xFF999999);
}