import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/core/tax/tax_settings_store.dart';
import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/utils/settings_value_utils.dart';

/// The worked example card: "a Rs. 100 item at 17%".
class TaxExample {
  const TaxExample({
    required this.price,
    required this.rate,
    required this.tax,
    required this.total,
    required this.inclusive,
    this.fromServer = false,
  });

  final Decimal price;
  final Decimal rate;
  final Decimal tax;
  final Decimal total;
  final bool inclusive;

  /// True when the numbers came from `GET /settings/tax-preview`.
  final bool fromServer;
}

/// Asks the server for the example (`GET /settings/tax-preview`); null when
/// it cannot answer (offline, old server). The screen then uses the same
/// engine locally.
typedef TaxPreviewFetcher = Future<TaxExample?> Function({
  required Decimal price,
  required Decimal qty,
  required Decimal rate,
  required bool inclusive,
});

class TaxPricesState {
  const TaxPricesState({
    this.loading = true,
    this.saving = false,
    this.saved = TaxSettings.defaults,
    this.draft = TaxSettings.defaults,
    this.rates = const [],
    this.example,
    this.error,
    this.justSaved = false,
  });

  final bool loading;
  final bool saving;

  /// What is in force today (last loaded / saved).
  final TaxSettings saved;

  /// What the owner is editing.
  final TaxSettings draft;
  final List<TaxRateModel> rates;
  final TaxExample? example;
  final String? error;
  final bool justSaved;

  bool get dirty => draft != saved;

  /// Changing how prices work or rounding only affects NEW sales; the owner
  /// confirms that before it is saved.
  bool get needsWarning => draft.changesPricingVs(saved);

  TaxPricesState copyWith({
    bool? loading,
    bool? saving,
    TaxSettings? saved,
    TaxSettings? draft,
    List<TaxRateModel>? rates,
    TaxExample? example,
    String? error,
    bool clearError = false,
    bool? justSaved,
  }) =>
      TaxPricesState(
        loading: loading ?? this.loading,
        saving: saving ?? this.saving,
        saved: saved ?? this.saved,
        draft: draft ?? this.draft,
        rates: rates ?? this.rates,
        example: example ?? this.example,
        error: clearError ? null : (error ?? this.error),
        justSaved: justSaved ?? false,
      );
}

class TaxPricesCubit extends Cubit<TaxPricesState> {
  TaxPricesCubit({
    required GetTaxRatesUseCase getTaxRates,
    required BulkUpdateSettingsUseCase bulkUpdate,
    required TaxSettingsStore store,
    TaxPreviewFetcher? previewFetcher,
  })  : _getTaxRates = getTaxRates,
        _bulkUpdate = bulkUpdate,
        _store = store,
        _fetcher = previewFetcher,
        super(const TaxPricesState());

  final GetTaxRatesUseCase _getTaxRates;
  final BulkUpdateSettingsUseCase _bulkUpdate;
  final TaxSettingsStore _store;
  final TaxPreviewFetcher? _fetcher;

  static final examplePrice = Decimal.fromInt(100);
  static final exampleFallbackRate = Decimal.fromInt(17);
  int _previewToken = 0;

  Future<void> load() async {
    final current = _store.current;
    emit(state.copyWith(loading: true, saved: current, draft: current));
    final result = await _getTaxRates();
    if (isClosed) return;
    result.fold(
      // Offline: rates cannot be read, the screen is view-only anyway.
      (_) => emit(state.copyWith(loading: false)),
      (rates) => emit(state.copyWith(
        loading: false,
        rates: rates.where((r) => r.isActive).toList(),
      )),
    );
    _refreshExample();
  }

  /// Rate used in the example: the chosen default rate, else 17%.
  Decimal get exampleRate {
    final id = state.draft.defaultRateId;
    for (final r in state.rates) {
      if (r.id == id) return Decimal.tryParse(r.rate) ?? exampleFallbackRate;
    }
    return exampleFallbackRate;
  }

  void _edit(TaxSettings next) {
    emit(state.copyWith(draft: next, clearError: true));
    _refreshExample();
  }

  void setEnabled(bool v) => _edit(state.draft.copyWith(enabled: v));
  void setIncludeTax(bool v) => _edit(state.draft.copyWith(includeTax: v));
  void setRounding(String v) =>
      _edit(state.draft.copyWith(roundingMode: TaxSettings.normalizeRounding(v)));
  void setLabel(String v) => _edit(state.draft.copyWith(label: v));
  void setDefaultRate(String? id) => _edit(
        id == null
            ? state.draft.copyWith(clearDefaultRate: true)
            : state.draft.copyWith(defaultRateId: id),
      );
  void setShowBreakdown(bool v) =>
      _edit(state.draft.copyWith(showBreakdown: v));
  void setHideZero(bool v) => _edit(state.draft.copyWith(hideZeroDecimals: v));

  /// Tax name: 1-30 characters.
  String? get labelError {
    final t = state.draft.label.trim();
    if (t.isEmpty) return 'Please type a name, for example GST';
    if (t.length > 30) return 'Use 30 letters or fewer';
    return null;
  }

  TaxExample localExample() {
    final draft = state.draft;
    final rate = draft.enabled ? exampleRate : Decimal.zero;
    final a = PricingEngine.calculateLineTotal(
      qty: Decimal.one,
      unitPrice: examplePrice,
      discountPct: Decimal.zero,
      discountAmount: Decimal.zero,
      taxRate: rate,
      inclusive: draft.inclusive,
    );
    return TaxExample(
      price: examplePrice,
      rate: rate,
      tax: a.taxAmount,
      total: a.lineTotal,
      inclusive: draft.inclusive,
    );
  }

  Future<void> _refreshExample() async {
    final token = ++_previewToken;
    final local = localExample();
    emit(state.copyWith(example: local));
    final fetch = _fetcher;
    if (fetch == null || !state.draft.enabled) return;
    final remote = await fetch(
      price: examplePrice,
      qty: Decimal.one,
      rate: exampleRate,
      inclusive: state.draft.inclusive,
    );
    if (isClosed || token != _previewToken || remote == null) return;
    emit(state.copyWith(example: remote));
  }

  /// Saves every tax setting in one request (`settings.manage`). On success the
  /// settings in force change at once: the open cart is re-priced and the
  /// product grid re-rendered through [TaxSettingsStore.apply].
  Future<bool> save() async {
    if (state.saving || labelError != null) return false;
    final draft = state.draft.copyWith(label: state.draft.label.trim());
    emit(state.copyWith(saving: true, clearError: true));
    final values = draft.toValueMap()..removeWhere((_, v) => v == null);
    final result = await _bulkUpdate([
      for (final e in values.entries)
        {
          'setting_key': e.key,
          'setting_value': SettingsValueUtils.wrapValue(e.value),
        },
    ]);
    if (isClosed) return false;
    return result.fold(
      (f) {
        emit(state.copyWith(saving: false, error: f.message));
        return false;
      },
      (_) {
        _store.apply(draft);
        emit(state.copyWith(
          saving: false,
          saved: draft,
          draft: draft,
          justSaved: true,
        ));
        return true;
      },
    );
  }
}
