import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';

class JournalStatusChip extends StatelessWidget {
  const JournalStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isPosted = status == JournalEntryStatus.posted;
    final color = isPosted ? AppColors.success : AppColors.warning;
    final label = isPosted ? 'Posted' : 'Draft';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
