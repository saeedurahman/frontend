import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_line.dart';
import 'package:intl/intl.dart';

/// A customer or supplier account as a list of rows with a running balance.
///
/// A reversed payment is struck through and points to its reversal; the
/// reversal row points back to the payment. "Reverse payment" shows only on
/// payments that can still be reversed and only when [onReverse] is given.
class KhataLedgerTable extends StatefulWidget {
  const KhataLedgerTable({
    super.key,
    required this.lines,
    this.onReverse,
    this.emptyText = KhataText.noEntries,
    this.reverseTooltip,
  });

  final List<LedgerLine> lines;
  final void Function(LedgerLine line)? onReverse;
  final String emptyText;

  /// Shown on the disabled reverse button when the user lacks permission.
  final String? reverseTooltip;

  @override
  State<KhataLedgerTable> createState() => _KhataLedgerTableState();
}

class _KhataLedgerTableState extends State<KhataLedgerTable> {
  final _keys = <String, GlobalKey>{};
  String? _highlight;

  GlobalKey _key(String id) => _keys.putIfAbsent(id, GlobalKey.new);

  Future<void> _jumpTo(String id) async {
    final ctx = _keys[id]?.currentContext;
    if (ctx == null) return;
    setState(() => _highlight = id);
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 250),
      alignment: 0.3,
    );
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _highlight = null);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lines.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            widget.emptyText,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    final byId = {for (final l in widget.lines) l.id: l};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _HeaderRow(),
        for (final line in widget.lines)
          _LedgerRow(
            key: _key(line.id),
            line: line,
            highlighted: _highlight == line.id,
            reversalOf: line.reversalOfId == null ? null : byId[line.reversalOfId],
            reversedBy: line.reversedById == null ? null : byId[line.reversedById],
            onJump: _jumpTo,
            onReverse: widget.onReverse,
            reverseTooltip: widget.reverseTooltip,
          ),
      ],
    );
  }
}

const double _amountWidth = 160;
const double _balanceWidth = 180;

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: const Row(
        children: [
          SizedBox(width: 120, child: Text('Date', style: style)),
          Expanded(flex: 3, child: Text(KhataText.whatHappened, style: style)),
          Expanded(flex: 3, child: Text(KhataText.paidFrom, style: style)),
          SizedBox(
            width: _amountWidth,
            child: Text('Amount', textAlign: TextAlign.right, style: style),
          ),
          SizedBox(
            width: _balanceWidth,
            child: Text(
              KhataText.runningBalance,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(width: 150),
        ],
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({
    super.key,
    required this.line,
    required this.highlighted,
    required this.onJump,
    this.reversalOf,
    this.reversedBy,
    this.onReverse,
    this.reverseTooltip,
  });

  final LedgerLine line;
  final bool highlighted;
  final LedgerLine? reversalOf;
  final LedgerLine? reversedBy;
  final void Function(String id) onJump;
  final void Function(LedgerLine line)? onReverse;
  final String? reverseTooltip;

  @override
  Widget build(BuildContext context) {
    final struck = line.isReversed;
    final muted = struck ? AppColors.textSecondary : AppColors.textPrimary;
    final amount = line.amountView;
    final balance = line.balanceView;
    final amountColor = struck ? AppColors.textSecondary : amount.color;
    final decoration = struck ? TextDecoration.lineThrough : null;
    final when = line.when;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.accent.withValues(alpha: 0.25)
            : (line.isReversal ? AppColors.warning.withValues(alpha: 0.05) : null),
        border: const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              when == null ? '—' : DateFormat('dd MMM yyyy\nh:mm a').format(when),
              style: TextStyle(fontSize: 12, color: muted, decoration: decoration),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      line.typeLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: muted,
                        decoration: decoration,
                      ),
                    ),
                    if (struck)
                      const _Tag(
                        label: KhataText.reversedTag,
                        color: AppColors.warning,
                      ),
                    if (line.isReversal)
                      const _Tag(
                        label: KhataText.reversalTag,
                        color: AppColors.info,
                      ),
                  ],
                ),
                if (line.note != null && line.note!.isNotEmpty)
                  Text(
                    line.note!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (struck && line.reversedById != null)
                  _Link(
                    key: ValueKey('jump_${line.id}'),
                    label: reversedBy != null
                        ? 'Reversed on ${_day(reversedBy!.when)} · see reversal'
                        : 'Reversed · see reversal',
                    onTap: reversedBy == null ? null : () => onJump(reversedBy!.id),
                  ),
                if (line.isReversal && line.reversalOfId != null)
                  _Link(
                    key: ValueKey('jump_${line.id}'),
                    label: reversalOf != null
                        ? 'Undoes the payment of ${formatPKR(reversalOf!.amount.abs())} on ${_day(reversalOf!.when)}'
                        : 'Undoes an earlier payment',
                    onTap: reversalOf == null ? null : () => onJump(reversalOf!.id),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.detail.isEmpty ? '—' : line.detail,
                  style: TextStyle(fontSize: 13, color: muted, decoration: decoration),
                ),
                if (line.shiftId != null)
                  const Text(
                    'In a shift',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: _amountWidth,
            child: Text(
              amount.text,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: amountColor,
                decoration: decoration,
              ),
            ),
          ),
          SizedBox(
            width: _balanceWidth,
            child: Text(
              balance?.text ?? '—',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: balance?.color ?? AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: line.canReverse && onReverse != null
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Tooltip(
                      message: reverseTooltip ?? '',
                      child: TextButton.icon(
                        key: ValueKey('reverse_${line.id}'),
                        onPressed: () => onReverse!(line),
                        icon: const Icon(Icons.undo, size: 16),
                        label: const Text(KhataText.reversePayment),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.warning,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  static String _day(DateTime? d) =>
      d == null ? '' : DateFormat('dd MMM').format(d);
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
        ),
      );
}

class _Link extends StatelessWidget {
  const _Link({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: onTap == null ? AppColors.textSecondary : AppColors.info,
              decoration: onTap == null ? null : TextDecoration.underline,
            ),
          ),
        ),
      );
}
