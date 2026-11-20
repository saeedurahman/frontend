import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_settings.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/utils/settings_value_utils.dart';

class QuickAddSettingsState extends Equatable {
  const QuickAddSettingsState({
    this.loading = true,
    this.saving = false,
    required this.saved,
    required this.draft,
    this.marginText = '15',
    this.error,
    this.justSaved = false,
  });

  final bool loading;
  final bool saving;
  final QuickAddSettings saved;
  final QuickAddSettings draft;

  /// What is typed in the margin box (may not be a valid number yet).
  final String marginText;
  final String? error;
  final bool justSaved;

  /// The margin box holds a number from 0 to 1000.
  bool get marginValid => QuickAddSettingsCubit.parseMargin(marginText) != null;

  bool get dirty => draft != saved;

  /// "Cost 80, margin 15% -> suggested price 92"
  String get example {
    final suggested = draft.suggest(cost: Decimal.fromInt(80));
    final margin = _plain(draft.defaultMarginPercent);
    if (suggested == null) return 'Cost 80, margin $margin%';
    return 'Cost 80, margin $margin% -> suggested price ${_plain(suggested)}';
  }

  static String _plain(Decimal d) => d.isInteger ? d.toBigInt().toString() : d.toString();

  QuickAddSettingsState copyWith({
    bool? loading,
    bool? saving,
    QuickAddSettings? saved,
    QuickAddSettings? draft,
    String? marginText,
    String? error,
    bool clearError = false,
    bool? justSaved,
  }) =>
      QuickAddSettingsState(
        loading: loading ?? this.loading,
        saving: saving ?? this.saving,
        saved: saved ?? this.saved,
        draft: draft ?? this.draft,
        marginText: marginText ?? this.marginText,
        error: clearError ? null : (error ?? this.error),
        justSaved: justSaved ?? false,
      );

  @override
  List<Object?> get props => [loading, saving, saved, draft, marginText, error, justSaved];
}

/// Settings > Quick Add: ask cost, ask expiry, default margin and rounding.
/// (The beep on/off switch is a per-computer preference, handled by the page.)
class QuickAddSettingsCubit extends Cubit<QuickAddSettingsState> {
  QuickAddSettingsCubit({
    required QuickAddRepository repository,
    required BulkUpdateSettingsUseCase bulkUpdate,
  })  : _repo = repository,
        _bulkUpdate = bulkUpdate,
        super(QuickAddSettingsState(
          saved: QuickAddSettings.defaults,
          draft: QuickAddSettings.defaults,
        ));

  final QuickAddRepository _repo;
  final BulkUpdateSettingsUseCase _bulkUpdate;

  static Decimal? parseMargin(String text) {
    final d = Decimal.tryParse(text.trim());
    if (d == null || d < Decimal.zero || d > Decimal.fromInt(1000)) return null;
    return d;
  }

  Future<void> load() async {
    final s = await _repo.settings();
    if (isClosed) return;
    emit(state.copyWith(
      loading: false,
      saved: s,
      draft: s,
      marginText: QuickAddSettingsState._plain(s.defaultMarginPercent),
    ));
  }

  void setAskCost(bool v) =>
      emit(state.copyWith(draft: state.draft.copyWith(askCost: v), clearError: true));

  void setAskExpiry(bool v) =>
      emit(state.copyWith(draft: state.draft.copyWith(askExpiry: v), clearError: true));

  void setRounding(String v) =>
      emit(state.copyWith(draft: state.draft.copyWith(rounding: v), clearError: true));

  void setMargin(String text) {
    final m = parseMargin(text);
    emit(state.copyWith(
      marginText: text,
      draft: m == null ? state.draft : state.draft.copyWith(defaultMarginPercent: m),
      clearError: true,
    ));
  }

  Future<bool> save() async {
    if (state.saving || !state.marginValid) return false;
    emit(state.copyWith(saving: true, clearError: true));
    final values = state.draft.toValueMap();
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
        emit(state.copyWith(saving: false, saved: state.draft, justSaved: true));
        return true;
      },
    );
  }
}
