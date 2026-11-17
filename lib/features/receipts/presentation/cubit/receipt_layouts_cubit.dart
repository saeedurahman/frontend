import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';

class ReceiptLayoutsState {
  const ReceiptLayoutsState({
    this.loading = true,
    this.layouts = const [],
    this.assignments = const [],
    this.online = true,
    this.busy = false,
    this.error,
    this.notice,
  });

  final bool loading;
  final List<ReceiptLayout> layouts;
  final List<ReceiptLayoutAssignment> assignments;

  /// The server was reachable when this was loaded / last changed.
  final bool online;
  final bool busy;
  final String? error;
  final String? notice;

  ReceiptLayoutsState copyWith({
    bool? loading,
    List<ReceiptLayout>? layouts,
    List<ReceiptLayoutAssignment>? assignments,
    bool? online,
    bool? busy,
    String? error,
    bool clearError = false,
    String? notice,
    bool clearNotice = false,
  }) =>
      ReceiptLayoutsState(
        loading: loading ?? this.loading,
        layouts: layouts ?? this.layouts,
        assignments: assignments ?? this.assignments,
        online: online ?? this.online,
        busy: busy ?? this.busy,
        error: clearError ? null : (error ?? this.error),
        notice: clearNotice ? null : (notice ?? this.notice),
      );

  /// The layout [channel] uses by default (business-wide), if any.
  ReceiptLayout? defaultFor(ReceiptChannel channel) {
    for (final a in assignments) {
      if (a.channel == channel && a.branchId == null && a.layoutId != null) {
        for (final l in layouts) {
          if (l.id == a.layoutId) return l;
        }
      }
    }
    return null;
  }

  ReceiptLayout? overrideFor(ReceiptChannel channel, String branchId) {
    for (final a in assignments) {
      if (a.channel == channel && a.branchId == branchId && a.layoutId != null) {
        for (final l in layouts) {
          if (l.id == a.layoutId) return l;
        }
      }
    }
    return null;
  }

  /// Channels a layout is the default for (shown as chips on the list).
  List<ReceiptChannel> usedBy(String layoutId) => [
        for (final a in assignments)
          if (a.layoutId == layoutId && a.branchId == null) a.channel,
      ];
}

/// The list of layouts and where each one is used. Reads the device copy at
/// once (works offline) and refreshes from the server when it can be reached.
/// Every change goes to the server first and then into the local data, so the
/// next receipt already uses it. Changes need the internet.
class ReceiptLayoutsCubit extends Cubit<ReceiptLayoutsState> {
  ReceiptLayoutsCubit({
    required ReceiptLayoutStore store,
    required ReceiptLayoutApi api,
    required bool Function() isOnline,
  })  : _store = store,
        _api = api,
        _isOnline = isOnline,
        super(const ReceiptLayoutsState());

  final ReceiptLayoutStore _store;
  final ReceiptLayoutApi _api;
  final bool Function() _isOnline;

  static const offlineMessage =
      'You are offline. Receipt layouts can only be changed while you are online. '
      'Your current layouts keep working.';

  Future<void> load() async {
    await _readLocal(loading: false);
    if (!_isOnline()) {
      emit(state.copyWith(online: false));
      return;
    }
    try {
      final layouts = await _api.list();
      final assignments = await _api.assignments();
      final keep = {for (final l in layouts) '${l['id']}'};
      for (final l in layouts) {
        await _store.putLayout(l);
      }
      for (final l in await _store.layouts()) {
        if (!keep.contains(l.id)) await _store.removeLayout(l.id);
      }
      final keepA = {for (final a in assignments) '${a['id']}'};
      for (final a in assignments) {
        await _store.putAssignment(a);
      }
      for (final a in await _store.assignments()) {
        if (!keepA.contains(a.id)) await _store.removeAssignment(a.id);
      }
      await _readLocal(online: true);
    } on ReceiptApiException catch (e) {
      emit(state.copyWith(online: !e.offline, error: e.offline ? null : e.message));
    }
  }

  Future<void> _readLocal({bool loading = false, bool? online}) async {
    final layouts = await _store.layouts();
    final assignments = await _store.assignments();
    if (isClosed) return;
    emit(state.copyWith(
      loading: loading,
      layouts: layouts,
      assignments: assignments,
      online: online,
    ));
  }

  bool _requireOnline() {
    if (_isOnline()) return true;
    emit(state.copyWith(online: false, error: offlineMessage));
    return false;
  }

  Future<T?> _change<T>(Future<T> Function() body, {String? notice}) async {
    if (state.busy || !_requireOnline()) return null;
    emit(state.copyWith(busy: true, clearError: true, clearNotice: true));
    try {
      final result = await body();
      await _readLocal(online: true);
      if (!isClosed) emit(state.copyWith(busy: false, notice: notice));
      return result;
    } on ReceiptApiException catch (e) {
      if (!isClosed) {
        emit(state.copyWith(busy: false, online: !e.offline, error: e.message));
      }
      return null;
    }
  }

  /// Creates a layout from a design (and optionally a preset config).
  Future<ReceiptLayout?> create({
    required ReceiptDesign design,
    required String name,
    ReceiptPaper? paper,
    ReceiptLayoutConfig? config,
  }) async {
    final json = await _change(
      () async {
        final created = await _api.create(
          name: name.trim().isEmpty ? design.title : name.trim(),
          design: design.code,
          paper: (paper ?? design.defaultPaper).code,
          config: (config ?? ReceiptLayoutConfig.defaultsFor(design)).toJson(),
        );
        await _store.putLayout(created);
        return created;
      },
      notice: 'Layout created.',
    );
    return json == null ? null : ReceiptLayout.fromJson(json);
  }

  Future<ReceiptLayout?> duplicate(String id, {String? name}) async {
    final json = await _change(
      () async {
        final copy = await _api.duplicate(id, name: name);
        await _store.putLayout(copy);
        return copy;
      },
      notice: 'Layout duplicated.',
    );
    return json == null ? null : ReceiptLayout.fromJson(json);
  }

  Future<bool> rename(String id, String name) async {
    final clean = name.trim();
    if (clean.isEmpty) {
      emit(state.copyWith(error: 'Please type a name for the layout.'));
      return false;
    }
    final ok = await _change(
      () async {
        await _store.putLayout(await _api.update(id, name: clean));
        return true;
      },
      notice: 'Layout renamed.',
    );
    return ok ?? false;
  }

  /// Deletes a layout. The last layout cannot be deleted; a layout that is
  /// still assigned is refused by the server (409) with its own message.
  Future<bool> delete(String id) async {
    if (state.layouts.length <= 1) {
      emit(state.copyWith(error: 'You need at least one layout, so the last one cannot be deleted.'));
      return false;
    }
    final ok = await _change(
      () async {
        await _api.delete(id);
        await _store.removeLayout(id);
        return true;
      },
      notice: 'Layout deleted.',
    );
    return ok ?? false;
  }

  /// Sets the layout [channel] uses; [branchId] null = the whole business,
  /// [layoutId] null on a branch = remove that branch's own choice.
  Future<bool> assign(
    ReceiptChannel channel,
    String? layoutId, {
    String? branchId,
  }) async {
    final ok = await _change(
      () async {
        final rows = await _api.putAssignments([
          {'channel': channel.code, 'branch_id': branchId, 'layout_id': layoutId},
        ]);
        if (layoutId == null && branchId != null) {
          for (final a in await _store.assignments()) {
            if (a.channel == channel && a.branchId == branchId) {
              await _store.removeAssignment(a.id);
            }
          }
        }
        for (final r in rows) {
          await _store.putAssignment(r);
        }
        return true;
      },
      notice: 'Saved.',
    );
    return ok ?? false;
  }

  void clearMessages() => emit(state.copyWith(clearError: true, clearNotice: true));
}
