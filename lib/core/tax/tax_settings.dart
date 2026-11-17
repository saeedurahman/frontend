/// Business-wide tax and price settings (backend keys `tax.*`, `ui.*`).
///
/// Read from the pulled `settings` entity (`app_settings` map), so they are
/// available offline. Missing or malformed values fall back to the same
/// defaults the server uses for old businesses: tax on, prices exclusive of
/// tax, no rounding, label "GST".
class TaxSettings {
  const TaxSettings({
    this.enabled = true,
    this.includeTax = false,
    this.roundingMode = 'none',
    this.label = 'GST',
    this.defaultRateId,
    this.showBreakdown = true,
    this.hideZeroDecimals = false,
  });

  static const defaults = TaxSettings();

  static const keyEnabled = 'tax.enabled';
  static const keyInclusive = 'tax.prices_include_tax';
  static const keyRounding = 'tax.rounding_mode';
  static const keyBreakdown = 'tax.show_breakdown_on_receipt';
  static const keyLabel = 'tax.label';
  static const keyDefaultRate = 'tax.default_rate_id';
  static const keyHideZero = 'ui.hide_zero_decimals';

  static const roundingModes = ['none', 'nearest_1', 'nearest_5', 'nearest_10'];

  final bool enabled;

  /// "Prices on my items already include tax" (`tax.prices_include_tax`).
  final bool includeTax;
  final String roundingMode;
  final String label;
  final String? defaultRateId;
  final bool showBreakdown;
  final bool hideZeroDecimals;

  /// Inclusive pricing only means something while tax is on (server rule).
  bool get inclusive => enabled && includeTax;

  /// Step of the grand-total rounding, or null for rounding mode `none`.
  static int? roundingStep(String? mode) => switch (mode) {
        'nearest_1' => 1,
        'nearest_5' => 5,
        'nearest_10' => 10,
        _ => null,
      };

  static String normalizeRounding(String? mode) =>
      roundingModes.contains(mode) ? mode! : 'none';

  /// Parses the `app_settings` map of the pulled settings entity, or a
  /// `{setting_key: value}` map built from `GET /settings`. Values may be
  /// wrapped as `{"value": v}`.
  factory TaxSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return defaults;
    Object? raw(String key) {
      final v = map[key];
      return v is Map && v.containsKey('value') ? v['value'] : v;
    }

    bool boolOf(String key, bool fallback) {
      final v = raw(key);
      return v is bool ? v : fallback;
    }

    String? labelOf() {
      final v = raw(keyLabel);
      if (v is String && v.trim().isNotEmpty) return v.trim();
      return null;
    }

    final rounding = raw(keyRounding);
    final rate = raw(keyDefaultRate);
    return TaxSettings(
      enabled: boolOf(keyEnabled, defaults.enabled),
      includeTax: boolOf(keyInclusive, defaults.includeTax),
      roundingMode: normalizeRounding(rounding is String ? rounding : null),
      label: labelOf() ?? defaults.label,
      defaultRateId: rate is String && rate.isNotEmpty ? rate : null,
      showBreakdown: boolOf(keyBreakdown, defaults.showBreakdown),
      hideZeroDecimals: boolOf(keyHideZero, defaults.hideZeroDecimals),
    );
  }

  /// `{setting_key: value}` for the settings API.
  Map<String, Object?> toValueMap() => {
        keyEnabled: enabled,
        keyInclusive: includeTax,
        keyRounding: roundingMode,
        keyBreakdown: showBreakdown,
        keyLabel: label,
        keyDefaultRate: defaultRateId,
        keyHideZero: hideZeroDecimals,
      };

  TaxSettings copyWith({
    bool? enabled,
    bool? includeTax,
    String? roundingMode,
    String? label,
    String? defaultRateId,
    bool clearDefaultRate = false,
    bool? showBreakdown,
    bool? hideZeroDecimals,
  }) =>
      TaxSettings(
        enabled: enabled ?? this.enabled,
        includeTax: includeTax ?? this.includeTax,
        roundingMode: roundingMode ?? this.roundingMode,
        label: label ?? this.label,
        defaultRateId:
            clearDefaultRate ? null : (defaultRateId ?? this.defaultRateId),
        showBreakdown: showBreakdown ?? this.showBreakdown,
        hideZeroDecimals: hideZeroDecimals ?? this.hideZeroDecimals,
      );

  /// True when a change affects how NEW sales are priced (needs the
  /// "applies to new sales only" confirmation).
  bool changesPricingVs(TaxSettings other) =>
      enabled != other.enabled ||
      includeTax != other.includeTax ||
      roundingMode != other.roundingMode;

  @override
  bool operator ==(Object other) =>
      other is TaxSettings &&
      other.enabled == enabled &&
      other.includeTax == includeTax &&
      other.roundingMode == roundingMode &&
      other.label == label &&
      other.defaultRateId == defaultRateId &&
      other.showBreakdown == showBreakdown &&
      other.hideZeroDecimals == hideZeroDecimals;

  @override
  int get hashCode => Object.hash(enabled, includeTax, roundingMode, label,
      defaultRateId, showBreakdown, hideZeroDecimals);

  @override
  String toString() => 'TaxSettings(enabled: $enabled, includeTax: $includeTax, '
      'rounding: $roundingMode, label: $label)';
}

/// The settings in force on this device. Pricing getters on cart lines and the
/// money formatter (which have no BuildContext) read [current]; the
/// TaxSettingsStore keeps it in step with the pulled settings.
abstract final class TaxSettingsHolder {
  static TaxSettings current = TaxSettings.defaults;
}
