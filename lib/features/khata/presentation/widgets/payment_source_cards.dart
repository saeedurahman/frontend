import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';

IconData paymentSourceIcon(PaymentSource source) => switch (source) {
      PaymentSource.drawer => Icons.point_of_sale_outlined,
      PaymentSource.ownerPocket => Icons.account_balance_wallet_outlined,
      PaymentSource.bank => Icons.account_balance_outlined,
      PaymentSource.easypaisa => Icons.phone_android_outlined,
      PaymentSource.jazzcash => Icons.smartphone_outlined,
      PaymentSource.cheque => Icons.edit_note_outlined,
    };

/// Large selectable cards: "Where is the money coming from?"
class PaymentSourceCards extends StatelessWidget {
  const PaymentSourceCards({
    super.key,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
    this.cardWidth = 150,
  });

  final PaymentSource selected;
  final ValueChanged<PaymentSource> onSelected;
  final bool enabled;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final source in PaymentSource.values)
          _SourceCard(
            key: ValueKey('source_${source.apiValue}'),
            source: source,
            selected: source == selected,
            width: cardWidth,
            onTap: enabled ? () => onSelected(source) : null,
          ),
      ],
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    super.key,
    required this.source,
    required this.selected,
    required this.width,
    required this.onTap,
  });

  final PaymentSource source;
  final bool selected;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return Semantics(
      button: true,
      selected: selected,
      label: source.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(paymentSourceIcon(source), size: 24, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      source.hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, size: 18, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

/// A soft coloured notice used for "open your shift", "advance", "offline".
class KhataNotice extends StatelessWidget {
  const KhataNotice({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.color = AppColors.warning,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(height: 10),
                  action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
