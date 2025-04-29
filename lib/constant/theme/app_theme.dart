import 'package:flutter/material.dart';

import '../../util/app_color.dart';

/// 앱 전체에서 사용하는 테마 정의
/// ColorScheme + TextTheme + AppBarTheme + ButtonTheme 등 포함
ThemeData themeData = ThemeData(
  /// 기본 색상 설정
  colorScheme: const ColorScheme(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    error: AppColors.error,
    onError: AppColors.onError,
    brightness: Brightness.light,
  ),

  /// Scaffold 전체 배경
  scaffoldBackgroundColor: AppColors.background,

  ///  텍스트 스타일 전역 설정
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.secondary),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.secondary),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondary),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.secondary),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.secondary),
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.secondary),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.secondary),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.secondary),
    bodySmall: TextStyle(fontSize: 13, color: AppColors.secondary),
    headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary),
    headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary),
    headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.secondary),
  ),

  /// AppBar 스타일
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackground,
    ),
    iconTheme: IconThemeData(color: AppColors.onBackground),
  ),

  // 🔘 ElevatedButton 스타일
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),

  // 🧪 Material 3 디자인 적용
  useMaterial3: true,
);
