import 'package:decimal/decimal.dart';

import 'price_suggestion.dart';

/// The Quick Add / price suggestion settings (backend keys `quick_add.*`,
/// `pricing.*`, `inventory.require_batch`), read from the pulled settings so
/// they work offline. A missing or malformed value falls back to the server's
/// default.
class QuickAddSettings {
  QuickAddSettings({
    this.askCost = true,
    this.askExpiry = false,
    Decimal? defaultMarginPercent,
    this.rounding = 'nearest_1',
    this.requireBatch = false,
  }) : defaultMarginPercent = defaultMarginPercent ?? Decimal.fromInt(15);

  static final defaults = QuickAddSettings();

  static const keyAskCost = 'quick_add.ask_cost';
  static const keyAskExpiry = 'quick_add.ask_expiry';
  static const keyMargin = 'pricing.default_margin_percent';
  static const keyRounding = 'pricing.suggested_price_rounding';
  static const keyRequireBatch = 'inventory.require_batch';

  /// Cost is part of the Enter flow.
  final bool askCost;

  /// Batch and expiry are part of the flow (pharmacies by default).
  final bool askExpiry;
  final Decimal defaultMarginPercent;
  final String rounding;

  /// A stock line without a batch number is refused by the server.
  final bool requireBatch;

  /// Parses the `app_settings` map of the pulled settings (values may be
  /// wrapped as `{"value": v}`) or a `{key: value}` map built from GET /settings.
  factory QuickAddSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return defaults;
    Object? raw(String key) {
      final v = map[key];
      return v is Map && v.containsKey('value') ? v['value'] : v;
    }

    bool boolOf(String key, bool fallback) {
      final v = raw(key);
      return v is bool ? v : fallback;
    }

    Decimal margin() {
      final v = raw(keyMargin);
      final parsed = v is num || v is String ? Decimal.tryParse('$v') : null;
      if (parsed == null || parsed < Decimal.zero || parsed > Decimal.fromInt(1000)) {
        return defaults.defaultMarginPercent;
      }
      return parsed;
    }

    return QuickAddSettings(
      askCost: boolOf(keyAskCost, defaults.askCost),
      askExpiry: boolOf(keyAskExpiry, defaults.askExpiry),
      defaultMarginPercent: margin(),
      rounding: PriceRounding.normalize(raw(keyRounding)),
      requireBatch: boolOf(keyRequireBatch, defaults.requireBatch),
    );
  }

  /// `{setting_key: value}` for the settings API.
  Map<String, Object?> toValueMap() => {
        keyAskCost: askCost,
        keyAskExpiry: askExpiry,
        keyMargin: _marginJson(),
        keyRounding: rounding,
      };

  Object _marginJson() {
    final m = defaultMarginPercent;
    return m.isInteger ? m.toBigInt().toInt() : m.toDouble();
  }

  QuickAddSettings copyWith({
    bool? askCost,
    bool? askExpiry,
    Decimal? defaultMarginPercent,
    String? rounding,
    bool? requireBatch,
  }) =>
      QuickAddSettings(
        askCost: askCost ?? this.askCost,
        askExpiry: askExpiry ?? this.askExpiry,
        defaultMarginPercent: defaultMarginPercent ?? this.defaultMarginPercent,
        rounding: rounding ?? this.rounding,
        requireBatch: requireBatch ?? this.requireBatch,
      );

  Decimal? suggest({Decimal? mrp, Decimal? cost}) => PriceSuggestion.forRow(
        mrp: mrp,
        cost: cost,
        marginPercent: defaultMarginPercent,
        rounding: rounding,
      );

  @override
  bool operator ==(Object other) =>
      other is QuickAddSettings &&
      other.askCost == askCost &&
      other.askExpiry == askExpiry &&
      other.defaultMarginPercent == defaultMarginPercent &&
      other.rounding == rounding &&
      other.requireBatch == requireBatch;

  @override
  int get hashCode =>
      Object.hash(askCost, askExpiry, defaultMarginPercent, rounding, requireBatch);
}
