import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/sales/presentation/utils/sale_line_display.dart';

class SaleListProductsCell extends StatelessWidget {
  const SaleListProductsCell({
    super.key,
    required this.productNames,
    this.itemCount,
  });

  final List<String> productNames;
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    if (productNames.isEmpty) {
      final fallback = itemCount != null ? '$itemCount items' : '—';
      return Text(
        fallback,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return Tooltip(
      message: productNames.join(', '),
      child: Text(
        SaleLineDisplay.summaryFromNames(productNames),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
