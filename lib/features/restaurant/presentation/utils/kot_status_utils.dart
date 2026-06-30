import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

/// KOT header status helpers aligned with backend KotStatusEnum.
abstract final class KotStatusUtils {
  static const activeStatuses = {'pending', 'preparing', 'ready'};

  static String label(String status) => switch (status) {
        'pending' => 'New',
        'preparing' => 'Preparing',
        'ready' => 'Ready',
        'served' => 'Served',
        'cancelled' => 'Cancelled',
        _ => status,
      };

  static Color columnColor(String status) => switch (status) {
        'pending' => const Color(0xFFF59E0B),
        'preparing' => const Color(0xFF3B82F6),
        'ready' => const Color(0xFF22C55E),
        _ => AppColors.textSecondary,
      };

  static String? nextStatus(String current) => switch (current) {
        'pending' => 'preparing',
        'preparing' => 'ready',
        'ready' => 'served',
        _ => null,
      };

  static String advanceActionLabel(String current) => switch (current) {
        'pending' => 'Start preparing',
        'preparing' => 'Mark ready',
        'ready' => 'Mark served',
        _ => 'Advance',
      };
}
