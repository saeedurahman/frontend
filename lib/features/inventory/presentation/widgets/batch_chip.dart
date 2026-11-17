import 'package:flutter/material.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/inventory/domain/batch_picker.dart';

/// Colours for an expiry state: red when expired, amber when close, calm
/// otherwise. Shared by the cart, the expiry report and the batch screens.
({Color fg, Color bg}) expiryColors(ExpiryStatus status) => switch (status) {
      ExpiryStatus.expired => (fg: const Color(0xFFB3261E), bg: const Color(0xFFFDE7E5)),
      ExpiryStatus.near => (fg: const Color(0xFF8A5A00), bg: const Color(0xFFFFF1CC)),
      ExpiryStatus.ok => (fg: const Color(0xFF2E5E3E), bg: const Color(0xFFE4F2E8)),
      ExpiryStatus.none => (fg: const Color(0xFF444444), bg: const Color(0xFFEEEEEE)),
    };

/// "Batch B-12 · Exp 2026-12-31" on a small coloured chip. Red once expired,
/// amber within [nearDays] of expiry.
class BatchChip extends StatelessWidget {
  const BatchChip({
    super.key,
    required this.slice,
    required this.nearDays,
    this.showQty = false,
  });

  final BatchSlice slice;
  final int nearDays;

  /// Print the quantity too (when a line is split over several batches).
  final bool showQty;

  @override
  Widget build(BuildContext context) {
    final status = slice.statusFor(nearDays);
    final colors = expiryColors(status);
    final parts = <String>[
      if (slice.batchNo != null && slice.batchNo!.isNotEmpty) 'Batch ${slice.batchNo}',
      if (slice.expiry != null) 'Exp ${slice.expiry}',
      if (showQty) '× ${DecimalUtils.format(slice.qty)}',
    ];
    if (parts.isEmpty) return const SizedBox.shrink();
    final tag = switch (status) {
      ExpiryStatus.expired => 'EXPIRED',
      ExpiryStatus.near => 'Near expiry',
      _ => null,
    };
    return Container(
      key: Key('batch-chip-${slice.batchNo ?? 'none'}'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.fg.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == ExpiryStatus.expired || status == ExpiryStatus.near) ...[
            Icon(Icons.warning_amber_rounded, size: 13, color: colors.fg),
            const SizedBox(width: 4),
          ],
          // Flexible: a long batch number wraps instead of overflowing the
          // narrow cart column.
          Flexible(
            child: Text(
              [parts.join(' · '), if (tag != null) tag].join(' · '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.fg),
            ),
          ),
        ],
      ),
    );
  }
}
