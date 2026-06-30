import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

/// Maps backend [TableStatusEnum] values to display colors.
abstract final class TableStatusColors {
  static Color background(String status) => switch (status) {
        'available' => const Color(0xFFDCFCE7),
        'occupied' => const Color(0xFFFEE2E2),
        'reserved' => const Color(0xFFDBEAFE),
        'billing' => const Color(0xFFFEF3C7),
        'cleaning' => const Color(0xFFE2E8F0),
        _ => const Color(0xFFF1F5F9),
      };

  static Color border(String status) => switch (status) {
        'available' => AppColors.success,
        'occupied' => AppColors.error,
        'reserved' => AppColors.info,
        'billing' => AppColors.warning,
        'cleaning' => AppColors.textSecondary,
        _ => AppColors.border,
      };

  static String label(String status) => switch (status) {
        'available' => 'Available',
        'occupied' => 'Occupied',
        'reserved' => 'Reserved',
        'billing' => 'Billing',
        'cleaning' => 'Cleaning',
        _ => status,
      };
}
