import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle body = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    height: 1.6,
  );

  static const TextStyle bodyMuted = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    height: 1.6,
  );
  static const TextStyle label = TextStyle(
    color: AppColors.textMuted,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static const TextStyle caption = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
  );
  static const TextStyle cardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle movieTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle accentBold = TextStyle(
    color: AppColors.accent,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle tagline = TextStyle(
    color: AppColors.accent,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 2.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}