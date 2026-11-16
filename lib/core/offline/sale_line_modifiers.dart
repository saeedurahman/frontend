import 'dart:convert';

import 'package:decimal/decimal.dart';

/// One modifier chosen for a sale line, as the **sync contract** carries it
/// (`sale.create` line `modifiers[]`: `modifier_id`, `name`, `price`, `qty`).
///
/// This file is the single place that knows that shape and the
/// `restaurant:{...}` encoding the server stores in `sale_lines.notes`, so a
/// contract change is a change here only.
class SaleLineModifier {
  const SaleLineModifier({
    this.modifierId,
    required this.name,
    required this.price,
    this.qty = 1,
  });

  final String? modifierId;
  final String name;

  /// Price per unit of the item for this modifier (`price_delta`).
  final Decimal price;
  final int qty;

  /// What this modifier adds to the price of ONE unit of the line.
  Decimal get perUnit => price * Decimal.fromInt(qty);

  /// Wire shape for the `sale.create` op.
  Map<String, dynamic> toPayload() => {
        'modifier_id': modifierId,
        'name': name,
        'price': price.toStringAsFixed(2),
        'qty': '$qty',
      };

  /// Shape kept on the local sale line (receipts, reprints).
  Map<String, dynamic> toLocal() => toPayload();

  static SaleLineModifier? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final name = '${raw['name'] ?? raw['modifier_name'] ?? ''}'.trim();
    if (name.isEmpty) return null;
    final price = Decimal.tryParse(
            '${raw['price'] ?? raw['price_delta'] ?? '0'}') ??
        Decimal.zero;
    final qtyValue = Decimal.tryParse('${raw['qty'] ?? '1'}') ?? Decimal.one;
    final qty = qtyValue.toBigInt().toInt();
    return SaleLineModifier(
      modifierId: raw['modifier_id']?.toString(),
      name: name,
      price: price,
      qty: qty < 1 ? 1 : qty,
    );
  }

  static List<SaleLineModifier> listFrom(Object? raw) => [
        if (raw is List)
          for (final m in raw) ?tryFromJson(m),
      ];

  /// Sum of [SaleLineModifier.perUnit].
  static Decimal totalPerUnit(Iterable<SaleLineModifier> modifiers) =>
      modifiers.fold(Decimal.zero, (sum, m) => sum + m.perUnit);

  // ── `restaurant:{...}` line notes ──────────────────────────────────────

  static const notesPrefix = 'restaurant:';

  /// The server's encoding of a line's kitchen note + modifiers.
  static String? encodeNotes(String? note, List<SaleLineModifier> modifiers) {
    if (modifiers.isEmpty) return note;
    return '$notesPrefix${jsonEncode({
      'kitchen_notes': note,
      'modifiers': [
        for (final m in modifiers)
          {
            'modifier_id': m.modifierId,
            'name': m.name,
            'price_delta': m.price.toStringAsFixed(2),
            'price': m.price.toStringAsFixed(2),
            'qty': '${m.qty}',
          },
      ],
    })}';
  }

  /// Splits stored line notes into (plain note, modifiers). Plain notes pass
  /// through untouched, so this is safe for every sale line.
  static ({String? note, List<SaleLineModifier> modifiers}) decodeNotes(
    String? notes,
  ) {
    if (notes == null || !notes.startsWith(notesPrefix)) {
      return (note: notes, modifiers: const <SaleLineModifier>[]);
    }
    try {
      final json = jsonDecode(notes.substring(notesPrefix.length)) as Map;
      final note = json['kitchen_notes']?.toString();
      return (
        note: note == null || note.isEmpty ? null : note,
        modifiers: listFrom(json['modifiers']),
      );
    } catch (_) {
      return (note: null, modifiers: const <SaleLineModifier>[]);
    }
  }
}
