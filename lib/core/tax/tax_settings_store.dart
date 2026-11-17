import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/tax/tax_settings.dart';

/// Keeps [TaxSettingsHolder.current] equal to the settings pulled to this
/// device and tells listeners when they change (a pull, or a save made on this
/// device). Offline safe: it only reads local data.
class TaxSettingsStore {
  TaxSettingsStore(this._catalog);

  final LocalCatalog _catalog;
  final _changes = StreamController<TaxSettings>.broadcast();
  StreamSubscription<void>? _sub;
  bool _reloading = false;
  bool _again = false;

  TaxSettings get current => TaxSettingsHolder.current;

  /// Emits the new settings whenever they actually changed.
  Stream<TaxSettings> get changes => _changes.stream;

  /// Loads once, then follows every committed local change.
  Future<void> start() async {
    _sub ??= _catalog.changes.listen((_) => unawaited(reload()));
    await reload();
  }

  Future<void> reload() async {
    if (_reloading) {
      _again = true;
      return;
    }
    _reloading = true;
    try {
      do {
        _again = false;
        final row = await _catalog.settings();
        final raw = row?['app_settings'];
        final TaxSettings next;
        if (raw is Map) {
          next = TaxSettings.fromMap(raw.cast<String, dynamic>());
        } else {
          // Nothing pulled yet, or an old server without the tax keys.
          next = TaxSettings.defaults;
        }
        apply(next);
      } while (_again);
    } catch (e) {
      debugPrint('[Tax] could not read local settings: $e');
    } finally {
      _reloading = false;
    }
  }

  /// Makes [next] the settings in force (after a save, before the pull echo
  /// arrives; also used by tests).
  void apply(TaxSettings next) {
    if (next == TaxSettingsHolder.current) return;
    TaxSettingsHolder.current = next;
    if (!_changes.isClosed) _changes.add(next);
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _changes.close();
  }
}
