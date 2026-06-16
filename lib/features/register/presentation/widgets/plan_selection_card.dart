import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';

class PlanSelectionCard extends StatelessWidget {
  const PlanSelectionCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  final RegisterPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              if (plan.isRecommended)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'RECOMMENDED',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textOnPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              Text(
                plan.label.toUpperCase(),
                style: AppTextStyles.titleMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                plan.price,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _PlanFeature(icon: Icons.store_rounded, label: plan.branches),
              const SizedBox(height: 4),
              _PlanFeature(icon: Icons.people_rounded, label: plan.users),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanFeature extends StatelessWidget {
  const _PlanFeature({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
