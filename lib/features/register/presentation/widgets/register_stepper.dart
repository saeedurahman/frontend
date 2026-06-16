import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/utils/responsive/responsive.dart';

/// Horizontal step indicator for the 5-step registration wizard.
class RegisterStepper extends StatelessWidget {
  const RegisterStepper({
    super.key,
    required this.currentStep,
    this.compactLabels,
  });

  /// 1-based active step index.
  final int currentStep;
  final List<String>? compactLabels;

  static const _desktopLabels = [
    'Business Info',
    'Type',
    'Branch',
    'Owner',
    'Done',
  ];

  static const _desktopIcons = [
    Icons.storefront_rounded,
    Icons.category_rounded,
    Icons.location_on_rounded,
    Icons.person_rounded,
    Icons.flag_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final labels = compactLabels ?? _desktopLabels;
    final isMobile = context.isMobile;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 24,
        vertical: isMobile ? 12 : 20,
      ),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIndex = index ~/ 2;
            final done = stepIndex + 1 < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: done ? AppColors.primary : AppColors.border,
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final stepNumber = stepIndex + 1;
          final isActive = stepNumber == currentStep;
          final isDone = stepNumber < currentStep;

          return _StepNode(
            label: labels[stepIndex],
            icon: _desktopIcons[stepIndex],
            stepNumber: stepNumber,
            isActive: isActive,
            isDone: isDone,
            compact: isMobile,
          );
        }),
      ),
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({
    required this.label,
    required this.icon,
    required this.stepNumber,
    required this.isActive,
    required this.isDone,
    required this.compact,
  });

  final String label;
  final IconData icon;
  final int stepNumber;
  final bool isActive;
  final bool isDone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final circleColor = isDone || isActive ? AppColors.primary : AppColors.border;
    final contentColor =
        isDone || isActive ? AppColors.textOnPrimary : AppColors.textSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 32 : 40,
          height: compact ? 32 : 40,
          decoration: BoxDecoration(
            color: isActive && !isDone ? AppColors.surface : circleColor,
            shape: BoxShape.circle,
            border: isActive && !isDone
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: Center(
            child: isDone
                ? Icon(Icons.check_rounded, color: contentColor, size: compact ? 16 : 20)
                : isActive && !isDone
                    ? Text(
                        '$stepNumber',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: compact ? 12 : 14,
                        ),
                      )
                    : Icon(icon, color: contentColor, size: compact ? 14 : 18),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: compact ? 56 : 72,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: compact ? 9 : 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive || isDone ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
