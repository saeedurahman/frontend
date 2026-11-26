import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/utils/logger.dart';

/// The shared "stay current" behaviour of list and detail cubits.
///
/// * [watchData] re-reads when a write touches one of the watched topics. The
///   subscription ends with the cubit.
/// * Changes that arrive while a re-read runs are folded into one more re-read
///   (no timers, no delays).
/// * [beginRead] / [isStale] drop an answer that a newer read has overtaken, so
///   an old response can never put old rows back on screen.
/// * Nothing is emitted after the cubit is closed.
///
/// A re-read started by a change must be quiet: no spinner, filters and page
/// kept, and the rows on screen stay when it fails.
mixin AutoRefresh<S> on Cubit<S> {
  StreamSubscription<DataChange>? _dataSubscription;
  Future<void>? _refreshing;
  bool _refreshAgain = false;
  int _generation = 0;

  /// Ids of records created since the cubit started, newest last.
  final List<String> _createdIds = [];

  List<String> get createdIds => List.unmodifiable(_createdIds);

  /// For a cubit that creates a record itself.
  void markCreated(String id) {
    if (!_createdIds.contains(id)) _createdIds.add(id);
  }

  /// Stops treating them as new (the user changed what the list shows).
  void forgetCreated() => _createdIds.clear();

  bool isNewlyCreated(String id) => _createdIds.contains(id);

  /// [items] with the newly created ones on top, newest first, so a new row is
  /// in sight whatever the list is ordered by. The rest keep their order.
  List<T> newestFirst<T>(List<T> items, String Function(T item) idOf) {
    if (_createdIds.isEmpty) return items;
    final byId = {for (final item in items) idOf(item): item};
    return [
      for (final id in _createdIds.reversed)
        if (byId.containsKey(id)) byId[id] as T,
      for (final item in items)
        if (!_createdIds.contains(idOf(item))) item,
    ];
  }

  /// The id of the first row when it is a new one. A table given this as its
  /// reset token returns to its first page when a new row arrives.
  String? createdOnTop<T>(List<T> items, String Function(T item) idOf) {
    if (items.isEmpty) return null;
    final top = idOf(items.first);
    return _createdIds.contains(top) ? top : null;
  }

  /// Completes when the re-reads started so far are done.
  Future<void> get refreshSettled => _refreshing ?? Future<void>.value();

  /// Whether the records [change] created belong on this screen. Override when a
  /// cubit watches topics that other kinds of record also touch.
  bool remembersCreated(DataChange change) => true;

  void watchData(
    Set<DataTopic> topics,
    Future<void> Function() onChange, {
    DataChangeBus? bus,
  }) {
    _dataSubscription?.cancel();
    _dataSubscription =
        (bus ?? DataChangeBus.instance).changes.listen((change) {
      if (isClosed || !change.topics.any(topics.contains)) return;
      if (remembersCreated(change)) change.createdIds.forEach(markCreated);
      unawaited(_scheduleRefresh(onChange));
    });
  }

  Future<void> _scheduleRefresh(Future<void> Function() onChange) {
    _refreshAgain = true;
    return _refreshing ??= _drain(onChange);
  }

  Future<void> _drain(Future<void> Function() onChange) async {
    try {
      while (_refreshAgain && !isClosed) {
        _refreshAgain = false;
        try {
          await onChange();
        } catch (e) {
          // A failed re-read leaves the screen as it is.
          AppLogger.warning('Refresh after a change failed (${e.runtimeType})');
        }
      }
    } finally {
      _refreshing = null;
    }
  }

  /// Call at the start of a read that will replace the screen's data.
  int beginRead() => ++_generation;

  /// True when a newer read started (or the cubit closed) since [read].
  bool isStale(int read) => isClosed || read != _generation;

  @override
  void emit(S state) {
    if (isClosed) return;
    super.emit(state);
  }

  @override
  Future<void> close() {
    // Not awaited: cancelling a broadcast subscription needs no answer.
    unawaited(_dataSubscription?.cancel() ?? Future<void>.value());
    _dataSubscription = null;
    return super.close();
  }
}
