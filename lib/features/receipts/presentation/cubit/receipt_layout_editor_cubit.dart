import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_switches.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layouts_cubit.dart';

class ReceiptLayoutEditorState {
  const ReceiptLayoutEditorState({
    required this.draft,
    required this.saved,
    this.saving = false,
    this.error,
    this.justSaved = false,
    this.revision = 0,
  });

  /// What the screen shows and the preview draws.
  final ReceiptLayout draft;

  /// What the server (and the device) currently has.
  final ReceiptLayout saved;
  final bool saving;
  final String? error;
  final bool justSaved;

  /// Bumped when the whole draft is replaced (reset, preset, discard, save),
  /// so text fields rebuild with the new values.
  final int revision;

  bool get dirty =>
      draft.name != saved.name ||
      draft.paper != saved.paper ||
      draft.config != saved.config;

  ReceiptLayoutEditorState copyWith({
    ReceiptLayout? draft,
    ReceiptLayout? saved,
    bool? saving,
    String? error,
    bool clearError = false,
    bool? justSaved,
    bool bumpRevision = false,
  }) =>
      ReceiptLayoutEditorState(
        draft: draft ?? this.draft,
        saved: saved ?? this.saved,
        saving: saving ?? this.saving,
        error: clearError ? null : (error ?? this.error),
        justSaved: justSaved ?? this.justSaved,
        revision: bumpRevision ? revision + 1 : revision,
      );
}

/// Edits one layout. Every change is local until [save]; the preview reads
/// [ReceiptLayoutEditorState.draft], so it moves with each switch.
class ReceiptLayoutEditorCubit extends Cubit<ReceiptLayoutEditorState> {
  ReceiptLayoutEditorCubit({
    required ReceiptLayout layout,
    required ReceiptLayoutApi api,
    required ReceiptLayoutStore store,
    required bool Function() isOnline,
  })  : _api = api,
        _store = store,
        _isOnline = isOnline,
        super(ReceiptLayoutEditorState(draft: layout, saved: layout));

  final ReceiptLayoutApi _api;
  final ReceiptLayoutStore _store;
  final bool Function() _isOnline;

  void _edit(ReceiptLayout Function(ReceiptLayout d) change, {bool replaceAll = false}) =>
      emit(state.copyWith(
        draft: change(state.draft),
        clearError: true,
        justSaved: false,
        bumpRevision: replaceAll,
      ));

  void setName(String name) => _edit((d) => d.copyWith(name: name));

  void setPaper(ReceiptPaper paper) => _edit((d) => d.copyWith(paper: paper));

  void setSwitch(String section, String key, bool value) =>
      _edit((d) => d.copyWith(config: d.config.withValue(section, key, value)));

  void setText(String section, String key, String value) =>
      _edit((d) => d.copyWith(config: d.config.withValue(section, key, value)));

  void setFontScale(double scale) => _edit(
        (d) => d.copyWith(
          config: d.config.withValue('style', 'font_scale', scale.clamp(0.8, 1.4)),
        ),
      );

  void setExtraLines(List<String> lines) => _edit(
        (d) => d.copyWith(
          config: d.config.withValue('header', 'extra_lines', [
            for (final l in lines)
              if (l.trim().isNotEmpty) l.trim(),
          ].take(3).toList()),
        ),
      );

  /// The one language the whole receipt prints in (or both, two lines each).
  void setLanguage(ReceiptLanguage language) =>
      _edit((d) => d.copyWith(config: d.config.withLanguage(language)));

  /// A layout's design is fixed on the server, so choosing another design
  /// makes a NEW layout from the current settings (unsaved edits included)
  /// and returns it. The original layout is left as it is.
  Future<ReceiptLayout?> startFromDesign(ReceiptDesign design) async {
    if (state.saving) return null;
    if (!_isOnline()) {
      emit(state.copyWith(error: ReceiptLayoutsCubit.offlineMessage));
      return null;
    }
    emit(state.copyWith(saving: true, clearError: true));
    try {
      final base = state.draft.name.trim().isEmpty ? 'Receipt' : state.draft.name.trim();
      final json = await _api.create(
        name: '$base (${design.title})',
        design: design.code,
        paper: design.defaultPaper.code,
        config: state.draft.config.toJson(),
      );
      await _store.putLayout(json);
      emit(state.copyWith(saving: false));
      return ReceiptLayout.fromJson(json);
    } on ReceiptApiException catch (e) {
      emit(state.copyWith(saving: false, error: e.message));
      return null;
    }
  }

  void setLabel(String key, {String? en, String? ur}) =>
      _edit((d) => d.copyWith(config: d.config.withLabel(key, en: en, ur: ur)));

  /// Back to the design's own starting point (name and paper stay).
  void resetToDefaults() => _edit(
        (d) => d.copyWith(config: ReceiptLayoutConfig.defaultsFor(d.design)),
        replaceAll: true,
      );

  /// Applies a preset's switches and texts (only for a preset of this
  /// layout's own design family: thermal presets on rolls, A4 on A4).
  void applyPreset(ReceiptPreset preset) => _edit(
        (d) => d.copyWith(config: preset.build()),
        replaceAll: true,
      );

  void discard() => emit(ReceiptLayoutEditorState(
        draft: state.saved,
        saved: state.saved,
        revision: state.revision + 1,
      ));

  /// Saves to the server, then into the local data. Online only.
  Future<bool> save() async {
    if (state.saving) return false;
    if (state.draft.isBuiltIn) {
      emit(state.copyWith(
        error: 'This is the built-in layout. Create a layout from a design to change it.',
      ));
      return false;
    }
    final name = state.draft.name.trim();
    if (name.isEmpty) {
      emit(state.copyWith(error: 'Please type a name for the layout.'));
      return false;
    }
    if (!_isOnline()) {
      emit(state.copyWith(error: ReceiptLayoutsCubit.offlineMessage));
      return false;
    }
    emit(state.copyWith(saving: true, clearError: true));
    try {
      final json = await _api.update(
        state.draft.id,
        name: name,
        paper: state.draft.paper.code,
        config: state.draft.config.toJson(),
      );
      await _store.putLayout(json);
      final saved = ReceiptLayout.fromJson(json);
      emit(ReceiptLayoutEditorState(
        draft: saved,
        saved: saved,
        justSaved: true,
        revision: state.revision + 1,
      ));
      return true;
    } on ReceiptApiException catch (e) {
      emit(state.copyWith(saving: false, error: e.message));
      return false;
    }
  }
}
