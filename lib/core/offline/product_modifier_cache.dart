import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';

typedef ModifierGroupsFetcher = Future<Either<Failure, List<ModifierGroupModel>>>
    Function(String productId);

/// Modifier groups of a product, answered from the device.
///
/// Adding a product to the cart asks "does this item have modifiers?". The
/// answer comes from the **pulled** modifier groups / modifiers / product
/// links (`local`, see `LocalCatalog.modifierGroupsFor`): they are part of
/// the sync feed, so they work offline and are as fresh as the last pull.
/// The server is then not asked at all.
///
/// Only when the device holds no pulled modifier data (`local` answers null:
/// an older install, or a user the feed does not deliver them to) does the
/// older path apply: [groupsFor] reads the answer stored in `sync_meta`
/// (`modifier_groups:<productId>`, wiped with the rest of the tenant data)
/// and the server is asked in the background ([warm], and a refresh behind
/// a stale lookup) as an optional refresh of that copy.
class ProductModifierCache {
  ProductModifierCache({
    required Future<String?> Function(String key) read,
    required Future<void> Function(String key, String value) write,
    required ModifierGroupsFetcher fetch,
    Future<List<ModifierGroupModel>?> Function(String productId)? local,
    DateTime Function()? clock,
    bool Function()? enabled,
    bool Function()? isReachable,
    this.maxAge = const Duration(minutes: 10),
    this.concurrency = 4,
  })  : _local = local,
        _readRaw = read,
        _writeRaw = write,
        _clock = clock ?? DateTime.now,
        _fetch = fetch,
        _enabled = enabled,
        _isReachable = isReachable;

  /// The production wiring: answers are kept in the local database.
  factory ProductModifierCache.onStore({
    required SyncStore store,
    required ModifierGroupsFetcher fetch,
    Future<List<ModifierGroupModel>?> Function(String productId)? local,
    bool Function()? enabled,
    bool Function()? isReachable,
    Duration maxAge = const Duration(minutes: 10),
  }) =>
      ProductModifierCache(
        local: local,
        read: store.meta,
        write: store.setMeta,
        clock: store.now,
        fetch: fetch,
        enabled: enabled,
        isReachable: isReachable,
        maxAge: maxAge,
      );

  /// Pulled data: the product's groups, or null when the device holds no
  /// pulled modifier data at all.
  final Future<List<ModifierGroupModel>?> Function(String productId)? _local;

  final Future<String?> Function(String key) _readRaw;
  final Future<void> Function(String key, String value) _writeRaw;
  final DateTime Function() _clock;
  final ModifierGroupsFetcher _fetch;

  /// False for a business without restaurant features: no lookups at all.
  final bool Function()? _enabled;

  /// False while the server is known to be unreachable: no background calls.
  final bool Function()? _isReachable;

  /// A stored answer older than this is refreshed in the background.
  final Duration maxAge;
  final int concurrency;

  final Set<String> _inFlight = {};

  static String keyFor(String productId) => 'modifier_groups:$productId';

  bool get enabled => _enabled?.call() ?? true;

  /// Usable (active, with at least one active modifier) groups of the
  /// product from the local copy. Never waits for the network.
  ///
  /// A product that was never looked up answers "no modifiers"; the answer
  /// is then fetched in the background for the next time.
  Future<List<ModifierGroupModel>> groupsFor(String productId) async {
    if (!enabled) return const [];
    final pulled = await _local?.call(productId);
    if (pulled != null) return usable(pulled);
    final entry = await _read(productId);
    if (entry == null || _isStale(entry.fetchedAt)) {
      unawaited(refresh(productId));
    }
    return entry?.groups ?? const [];
  }

  /// Background warm-up for products that are on screen.
  Future<void> warm(Iterable<String> productIds) async {
    if (!enabled || !_reachable) return;
    final pending = <String>[];
    for (final id in productIds.toSet()) {
      if (await _local?.call(id) != null) continue; // pulled: nothing to fetch
      final entry = await _read(id);
      if (entry == null || _isStale(entry.fetchedAt)) pending.add(id);
    }
    for (var i = 0; i < pending.length; i += concurrency) {
      if (!_reachable) return;
      await Future.wait(pending.skip(i).take(concurrency).map(refresh));
    }
  }

  /// Asks the server and stores the answer. Failures keep the old copy.
  Future<void> refresh(String productId) async {
    if (!enabled || !_reachable || !_inFlight.add(productId)) return;
    try {
      final result = await _fetch(productId);
      await result.fold((_) async {}, (groups) => _write(productId, groups));
    } catch (_) {
      // Best effort: the local copy stays as it is.
    } finally {
      _inFlight.remove(productId);
    }
  }

  bool get _reachable => _isReachable?.call() ?? true;

  bool _isStale(DateTime fetchedAt) =>
      _clock().difference(fetchedAt).abs() > maxAge;

  Future<({DateTime fetchedAt, List<ModifierGroupModel> groups})?> _read(
    String productId,
  ) async {
    final raw = await _readRaw(keyFor(productId));
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map;
      final groups = [
        for (final g in json['groups'] as List)
          ModifierGroupModel.fromJson(Map<String, dynamic>.from(g as Map)),
      ];
      return (
        fetchedAt: DateTime.fromMillisecondsSinceEpoch(json['at'] as int),
        groups: usable(groups),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _write(String productId, List<ModifierGroupModel> groups) =>
      _writeRaw(
        keyFor(productId),
        jsonEncode({
          'at': _clock().millisecondsSinceEpoch,
          'groups': [for (final g in groups) _groupJson(g)],
        }),
      );

  static Map<String, dynamic> _groupJson(ModifierGroupModel group) => {
        ...group.toJson(),
        'modifiers': [for (final m in group.modifiers) m.toJson()],
      };

  /// Groups the picker can show: active, with an active modifier.
  static List<ModifierGroupModel> usable(List<ModifierGroupModel> groups) => [
        for (final g in groups)
          if (g.isActive && g.modifiers.any((m) => m.isActive)) g,
      ];
}
