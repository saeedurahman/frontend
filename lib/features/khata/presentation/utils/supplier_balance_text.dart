import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';

/// A supplier balance (negative = you owe) in plain words.
abstract final class SupplierBalanceText {
  static ({String text, Color color, bool owed}) of(String? balance) {
    final value = Decimal.tryParse((balance ?? '').trim());
    if (value == null) {
      return (text: '—', color: AppColors.textSecondary, owed: false);
    }
    if (value < Decimal.zero) {
      return (
        text: KhataText.youOwe(formatPKR(-value)),
        color: AppColors.error,
        owed: true,
      );
    }
    if (value > Decimal.zero) {
      return (
        text: KhataText.youHaveAdvance(formatPKR(value)),
        color: AppColors.info,
        owed: false,
      );
    }
    return (text: KhataText.settled, color: AppColors.success, owed: false);
  }
}
