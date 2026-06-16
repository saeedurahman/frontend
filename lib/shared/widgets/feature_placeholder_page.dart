import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';

class FeaturePlaceholderPage extends StatelessWidget {
  const FeaturePlaceholderPage({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_outlined,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.headlineMedium),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }
}
