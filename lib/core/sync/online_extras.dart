import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/offline/repos/local_repositories.dart';
import 'package:frantend/core/sync/lease_service.dart';
import 'package:frantend/core/sync/sync_store.dart';

/// Small online-only refreshes that ride on a successful sync. Each is best
/// effort: the engine ignores their failures, and the POS never waits on them.
///
/// - `GET /settings` -> cached copy (default tax rate etc. are app settings,
///   not part of the pulled entities).
/// - `GET /business/me` -> stored copy (receipt header when printing offline).
/// - `GET /shifts/my-active` -> a shift opened elsewhere (web, another till)
///   becomes the local active shift, so the shift gate matches the server.
/// - `GET /subscription/status` -> a fresh signed lease.
class OnlineExtras {
  OnlineExtras({
    required Dio dio,
    required SyncStore store,
    required LeaseService lease,
    required Future<String?> Function() userId,
    this.leaseRefresh = const Duration(hours: 6),
  })  : _dio = dio,
        _store = store,
        _lease = lease,
        _userId = userId;

  final Dio _dio;
  final SyncStore _store;
  final LeaseService _lease;
  final Future<String?> Function() _userId;
  final Duration leaseRefresh;

  static const _opts = null;

  Future<void> run() async {
    await _safely(_settings);
    await _safely(_businessProfile);
    await _safely(_activeShift);
    await _safely(refreshLease);
  }

  Future<void> _safely(Future<void> Function() step) async {
    try {
      await step();
    } catch (_) {
      // Best effort.
    }
  }

  Future<void> _settings() async {
    final response = await _dio.get<dynamic>(ApiConstants.settings, options: _opts);
    final data = response.data;
    final list = data is List ? data : (data is Map ? data['items'] : null);
    if (list is List) {
      await _store.setMeta(LocalSettingsRepository.cacheKey, jsonEncode(list));
    }
  }

  /// `GET /business/me` -> stored copy for receipts printed offline.
  Future<void> _businessProfile() async {
    final response = await _dio.get<dynamic>(ApiConstants.businessMe, options: _opts);
    final data = response.data;
    if (data is Map && data['id'] != null) {
      await _store.setMeta(businessProfileKey, jsonEncode(data));
    }
  }

  /// Same key as `ReceiptBrandingSource.profileKey`.
  static const businessProfileKey = 'business_profile_cache';

  Future<void> _activeShift() async {
    final user = await _userId();
    if (user == null) return;
    if (await _store.openShiftFor(user) != null) return;
    final response = await _dio.get<dynamic>(ApiConstants.shiftsMyActive, options: _opts);
    final data = response.data;
    if (data is! Map || data['id'] == null) return;
    await _store.upsertShift({
      'id': '${data['id']}',
      'register_id': '${data['cash_register_id']}',
      'register_name': (data['register'] is Map) ? (data['register'] as Map)['name'] : null,
      'branch_id': data['branch_id']?.toString(),
      'user_id': user,
      'status': 'open',
      'opening_float': '${data['opening_float'] ?? '0'}',
      'notes': data['notes']?.toString(),
      'opened_at': '${data['opened_at'] ?? _store.now().toUtc().toIso8601String()}',
      'sync_state': 'synced',
    });
  }

  /// Re-reads `/subscription/status` when the lease is old or not valid.
  Future<void> refreshLease({bool force = false}) async {
    if (!_lease.enforced) return;
    final last = DateTime.tryParse(await _store.meta('lease_fetched_at') ?? '');
    final verdict = await _lease.evaluate();
    final due = force ||
        verdict.state != LeaseState.valid ||
        last == null ||
        _store.now().difference(last) > leaseRefresh;
    if (!due) return;
    final response = await _dio.get<dynamic>(ApiConstants.subscriptionStatus, options: _opts);
    final data = response.data;
    if (data is Map && await _lease.ingest(data['lease'])) {
      await _store.setMeta('lease_fetched_at', _store.now().toUtc().toIso8601String());
    }
  }
}
