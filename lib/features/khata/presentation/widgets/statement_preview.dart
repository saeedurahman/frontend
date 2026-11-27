/// The statement drawn on screen with the same look as the server's PDF.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/statement_wording.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/domain/text/statement_text.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';

/// The PDF's navy band.
const statementBand = Color(0xFF1F3A5F);

const _paperWidth = 820.0;
const _compactBelow = 700.0;
const _side = AppDimensions.spacingLg;
const _tint = Color(0xFFF3F6FA);

/// A scrolling statement on its own.
class StatementPreview extends StatelessWidget {
  const StatementPreview({super.key, required this.statement});

  final Statement statement;

  @override
  Widget build(BuildContext context) =>
      CustomScrollView(slivers: [StatementSliver(statement: statement)]);
}

/// The statement as a sliver: thousands of lines build only as they are seen.
class StatementSliver extends StatelessWidget {
  const StatementSliver({super.key, required this.statement});

  final Statement statement;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.crossAxisExtent < _paperWidth
              ? constraints.crossAxisExtent
              : _paperWidth;
          final blocks = _Paper(statement, width < _compactBelow).blocks();
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Center(
                child: _Sheet(
                  width: width,
                  first: i == 0,
                  last: i == blocks.length - 1,
                  child: blocks[i](),
                ),
              ),
              childCount: blocks.length,
            ),
          );
        },
      );
}

/// One strip of the white page.
class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.width,
    required this.first,
    required this.last,
    required this.child,
  });

  final double width;
  final bool first;
  final bool last;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const round = Radius.circular(AppDimensions.radiusMd);
    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: first ? round : Radius.zero,
          bottom: last ? round : Radius.zero,
        ),
      ),
      child: child,
    );
  }
}

class _Paper {
  _Paper(this.s, this.compact);

  final Statement s;
  final bool compact;

  static const _label = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  static const _body = TextStyle(
    fontSize: 13,
    height: 1.35,
    color: AppColors.textPrimary,
  );
  static const _heading = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: statementBand,
  );
  static final _money = KhataStyle.money.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  /// Money as the PDF writes it: the statement's currency, always to the
  /// cent.
  String _amount(Decimal value) => StatementWording.money(s.currency, value);

  String _running(Decimal due) => StatementWording.balance(s.currency, due);

  static String _day(DateTime? date) => StatementWording.day(date);

  Widget _padded(Widget child, {double top = 0, double bottom = 0}) => Padding(
        padding: EdgeInsets.fromLTRB(_side, top, _side, bottom),
        child: child,
      );

  List<Widget Function()> blocks() => [
        _header,
        () => _padded(_party(), top: AppDimensions.spacingMd),
        () => _padded(_cards(), top: AppDimensions.spacingMd),
        if (s.buckets.total > Decimal.zero)
          () => _padded(_aging(), top: AppDimensions.spacingMd),
        () => _padded(_tableTop(), top: AppDimensions.spacingMd),
        () => _balanceRow(StatementText.openingRow, s.openingDue),
        if (s.rows.isEmpty)
          () => _padded(
                const Text(StatementText.noRows, style: _label),
                top: AppDimensions.spacing12,
                bottom: AppDimensions.spacing12,
              )
        else
          for (var i = 0; i < s.rows.length; i++) () => _row(s.rows[i], i),
        () => _balanceRow(StatementText.closingRow, s.closingDue),
        () => _padded(
              const Text(StatementText.pendingBills, style: _heading),
              top: AppDimensions.spacingLg,
              bottom: AppDimensions.spacingSm,
            ),
        if (s.openItems.isEmpty)
          () => _padded(const Text(StatementText.noBills, style: _label))
        else ...[
          if (!compact) _billsTop,
          for (final bill in s.openItems) () => _bill(bill.item, bill.label),
          _billsTotal,
          () => _padded(
                const Text(StatementText.oldestFirst, style: _label),
                top: AppDimensions.spacingSm,
              ),
        ],
        if (s.advance != Decimal.zero)
          () => _padded(
                Text(
                  StatementText.advanceHeld(_amount(s.advance)),
                  style: _body.copyWith(fontWeight: FontWeight.w700),
                ),
                top: AppDimensions.spacingSm,
              ),
        if (s.paymentInstructions.isNotEmpty)
          () => _padded(_payVia(), top: AppDimensions.spacingLg),
        if (s.promiseDate != null)
          () => _padded(_promise(), top: AppDimensions.spacingMd),
        _footer,
      ];

  // ── top ────────────────────────────────────────────────────────────────

  static Uint8List? _logo(String? encoded) {
    if (encoded == null) return null;
    try {
      return base64Decode(encoded.split(',').last);
    } on FormatException {
      return null;
    }
  }

  Widget _header() {
    final logo = _logo(s.logoBase64);
    final numbers = [
      if (s.businessPhone != null) StatementText.phone(s.businessPhone!),
      if (s.businessNtn != null) StatementText.taxNumber(s.businessNtn!),
    ].join('  |  ');
    final contact = [
      if (s.businessAddress != null) s.businessAddress!,
      if (numbers.isNotEmpty) numbers,
    ].join('\n');
    final business = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          s.businessName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        if (contact.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.spacingXs),
            child: Text(
              contact,
              style: const TextStyle(fontSize: 12, color: Color(0xFFD5DEEA)),
            ),
          ),
      ],
    );
    final title = Column(
      crossAxisAlignment:
          compact ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          StatementText.paperTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        Text(
          StatementText.periodLine(s.periodLabel),
          style: const TextStyle(fontSize: 12, color: Color(0xFFD5DEEA)),
        ),
      ],
    );
    return ColoredBox(
      key: const Key('statement-header'),
      color: statementBand,
      child: Padding(
        padding: const EdgeInsets.all(_side),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (logo != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                child: Image.memory(
                  logo,
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
            ],
            Expanded(
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        business,
                        const SizedBox(height: AppDimensions.spacing12),
                        title,
                      ],
                    )
                  : business,
            ),
            if (!compact) ...[
              const SizedBox(width: AppDimensions.spacingMd),
              title,
            ],
          ],
        ),
      ),
    );
  }

  Widget _party() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(StatementText.statementFor(s.partyType), style: _label),
          Text(
            s.partyName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          if (s.partyPhone != null)
            Text(StatementText.phone(s.partyPhone!), style: _label),
          if (s.partyAddress != null) Text(s.partyAddress!, style: _label),
        ],
      );

  Widget _cards() {
    final sign = s.closingDue.compareTo(Decimal.zero);
    final cards = [
      (StatementText.opening, _running(s.openingDue), false),
      (StatementText.charges, _amount(s.charges), false),
      (StatementText.payments, _amount(s.payments), false),
      (
        StatementText.closingLabel(s.partyType, sign),
        _amount(s.closingDue.abs()),
        true,
      ),
    ];
    final across = compact ? 2 : 4;
    return LayoutBuilder(
      builder: (context, box) {
        const gap = AppDimensions.spacingSm;
        final width = (box.maxWidth - gap * (across - 1)) / across;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final (label, value, strong) in cards)
              Container(
                width: width,
                padding: const EdgeInsets.all(AppDimensions.spacing12),
                decoration: BoxDecoration(
                  color: strong ? statementBand : _tint,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: _label.copyWith(
                        color: strong ? const Color(0xFFD5DEEA) : null,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: KhataStyle.money.copyWith(
                          fontSize: 16,
                          color: strong ? Colors.white : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _aging() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(StatementText.aging, style: _heading),
          const SizedBox(height: AppDimensions.spacingSm),
          AgingBar(type: s.partyType, buckets: s.buckets),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingMd,
            runSpacing: AppDimensions.spacingXs,
            children: [
              for (final b in AgeBucket.values)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: KhataStyle.agingColor(s.partyType, b),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingXs),
                    Text(
                      '${KhataUiText.bucketLabel(b.apiValue)}: '
                      '${_amount(s.buckets[b])}',
                      style: _label,
                    ),
                  ],
                ),
            ],
          ),
        ],
      );

  // ── entries ────────────────────────────────────────────────────────────

  /// Date, document, details, debit, credit, balance.
  Widget _columns(List<Widget> cells) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 88, child: cells[0]),
          SizedBox(width: 104, child: cells[1]),
          Expanded(child: cells[2]),
          SizedBox(width: 104, child: cells[3]),
          SizedBox(width: 104, child: cells[4]),
          SizedBox(width: 116, child: cells[5]),
        ],
      );

  /// Right aligned; a figure too wide is drawn smaller, never cut or broken.
  static Widget _right(String text, TextStyle style) => Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(left: AppDimensions.spacingXs),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(text, maxLines: 1, style: style),
          ),
        ),
      );

  Widget _tableTop() {
    final style = _label.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );
    return Container(
      color: statementBand,
      padding: const EdgeInsets.all(AppDimensions.spacingSm),
      child: compact
          ? Row(
              children: [
                Expanded(child: Text(StatementText.details, style: style)),
                Text(StatementText.balance, style: style),
              ],
            )
          : _columns([
              Text(StatementText.date, style: style),
              Text(StatementText.document, style: style),
              Text(StatementText.details, style: style),
              _right(StatementText.debit, style),
              _right(StatementText.credit, style),
              _right(StatementText.balance, style),
            ]),
    );
  }

  Widget _line({required Widget child, bool shaded = false}) => _padded(
        Container(
          color: shaded ? _tint : null,
          padding: const EdgeInsets.all(AppDimensions.spacingSm),
          child: child,
        ),
      );

  Widget _balanceRow(String label, Decimal due) {
    final style = _body.copyWith(fontWeight: FontWeight.w700);
    return _line(
      shaded: true,
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(_running(due), style: _money.merge(style)),
        ],
      ),
    );
  }

  Widget _details(StatementRow row) {
    final struck = row.reversed ? TextDecoration.lineThrough : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StatementWording.details(row),
          style: _body.copyWith(decoration: struck),
        ),
        for (final item in row.items)
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.spacing12,
              top: AppDimensions.spacingXs,
            ),
            child: Text(
              StatementWording.item(item),
              style: _label.copyWith(decoration: struck),
            ),
          ),
      ],
    );
  }

  Widget _row(StatementRow row, int index) {
    final debit = row.debit == Decimal.zero ? '' : _amount(row.debit);
    final credit = row.credit == Decimal.zero ? '' : _amount(row.credit);
    final Widget content = compact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      [
                        _day(row.date),
                        if (row.documentNumber != null) row.documentNumber!,
                      ].join('  ·  '),
                      style: _label,
                    ),
                  ),
                  Text(_running(row.amountDue), style: _money),
                ],
              ),
              _details(row),
              Text(
                [
                  if (debit.isNotEmpty) '${StatementText.debit} $debit',
                  if (credit.isNotEmpty) '${StatementText.credit} $credit',
                ].join('  ·  '),
                style: _money,
              ),
            ],
          )
        : _columns([
            Text(_day(row.date), style: _body),
            Text(row.documentNumber ?? '', style: _body),
            Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacingSm),
              child: _details(row),
            ),
            _right(debit, _money),
            _right(credit, _money),
            _right(_running(row.amountDue), _money),
          ]);
    return DecoratedBox(
      key: ValueKey('statement-row-${row.id}'),
      decoration: const BoxDecoration(),
      child: _padded(
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          padding: const EdgeInsets.all(AppDimensions.spacingSm),
          child: content,
        ),
      ),
    );
  }

  // ── pending bills ──────────────────────────────────────────────────────

  Widget _billColumns(List<Widget> cells) => Row(
        children: [
          Expanded(flex: 3, child: cells[0]),
          Expanded(flex: 2, child: cells[1]),
          Expanded(flex: 2, child: cells[2]),
          Expanded(flex: 2, child: cells[3]),
          Expanded(flex: 2, child: cells[4]),
          Expanded(flex: 2, child: cells[5]),
        ],
      );

  Widget _billsTop() {
    final style = _label.copyWith(fontWeight: FontWeight.w700);
    return _line(
      shaded: true,
      child: _billColumns([
        Text(StatementText.billNo, style: style),
        Text(StatementText.date, style: style),
        _right(StatementText.total, style),
        _right(StatementText.paid, style),
        _right(StatementText.remaining, style),
        _right(StatementText.age, style),
      ]),
    );
  }

  Widget _billsTotal() {
    final total = s.openItems.fold(
      Decimal.zero,
      (sum, bill) => sum + bill.item.remaining,
    );
    final style = _body.copyWith(fontWeight: FontWeight.w700);
    return _line(
      shaded: true,
      child: Row(
        children: [
          Expanded(child: Text(StatementText.totalPending, style: style)),
          Text(_amount(total), style: _money.merge(style)),
        ],
      ),
    );
  }

  Widget _bill(OpenItem item, String label) {
    final name = item.number ?? label;
    final age = '${item.ageDays}';
    return _padded(
      Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.all(AppDimensions.spacingSm),
        child: compact
            ? Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: _body),
                        Text(
                          '${_day(item.date)}  ·  '
                          '${StatementText.age}: $age  ·  '
                          '${StatementText.total} ${_amount(item.total)}  ·  '
                          '${StatementText.paid} ${_amount(item.allocated)}',
                          style: _label,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Text(_amount(item.remaining), style: _money),
                ],
              )
            : _billColumns([
                Text(name, style: _body),
                Text(_day(item.date), style: _body),
                _right(_amount(item.total), _money),
                _right(_amount(item.allocated), _money),
                _right(
                  _amount(item.remaining),
                  _money.copyWith(fontWeight: FontWeight.w700),
                ),
                _right(
                  age,
                  _body.copyWith(color: KhataStyle.bucketText(item.bucket)),
                ),
              ]),
      ),
    );
  }

  // ── bottom ─────────────────────────────────────────────────────────────

  Widget _payVia() => Container(
        padding: const EdgeInsets.all(AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: _tint,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(StatementText.payVia, style: _heading),
            for (final p in s.paymentInstructions)
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.spacingXs),
                child: Text(p.line, style: _body),
              ),
          ],
        ),
      );

  Widget _promise() => Text(
        StatementText.promise(
          s.promiseAmount == null ? null : _amount(s.promiseAmount!),
          _day(s.promiseDate),
        ),
        style: _body.copyWith(fontWeight: FontWeight.w700),
      );

  Widget _footer() {
    final note = [
      if (s.generatedAt != null) StatementWording.generated(s.generatedAt!),
      if (s.showPoweredBy) StatementText.poweredBy,
    ].join('  ·  ');
    return Padding(
      padding: const EdgeInsets.all(_side),
      child: note.isEmpty
          ? const SizedBox.shrink()
          : Text(note, textAlign: TextAlign.center, style: _label),
    );
  }
}
