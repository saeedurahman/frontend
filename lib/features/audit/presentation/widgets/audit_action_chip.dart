import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

class AuditActionChip extends StatelessWidget {
  const AuditActionChip({super.key, required this.action});

  final String action;

  static Color colorFor(String action) {
    switch (action.toLowerCase()) {
      case 'create':
        return AppColors.success;
      case 'update':
        return AppColors.info;
      case 'delete':
        return AppColors.error;
      case 'restore':
        return AppColors.warning;
      case 'login':
      case 'logout':
        return AppColors.textSecondary;
      case 'sync':
        return const Color(0xFF805AD5);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(action);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        action,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
