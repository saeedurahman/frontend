import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/core/utils/currency_label.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';

/// Keeps [CurrencyLabelHolder.current] equal to the business's
/// `business.currency_label` setting.
///
/// The setting is not part of the sync feed, so it is read from
/// `GET /settings` when the server can be reached and remembered on this
/// device (per business) for offline use.
class CurrencyLabelStore {
  CurrencyLabelStore({
    required Future<List<AppSettingModel>> Function() fetch,
    required Future<String?> Function() businessId,
    required PreferencesStorage preferences,
    DateTime Function()? now,
  })  : _fetch = fetch,
        _businessId = businessId,
        _preferences = preferences,
        _now = now ?? DateTime.now;

  static const settingKey = 'business.currency_label';

  /// How often [refreshIfOld] asks the server again.
  static const maxAge = Duration(minutes: 10);

  final Future<List<AppSettingModel>> Function() _fetch;
  final Future<String?> Function() _businessId;
  final PreferencesStorage _preferences;
  final DateTime Function() _now;
  final _subscriptions = <StreamSubscription<void>>[];

  DateTime? _askedAt;
  String? _askedFor;

  /// Applies the label remembered for this business, then asks the server
  /// without making the caller wait.
  Future<void> start() async {
    await loadRemembered();
    unawaited(refresh());
  }

  /// Asks again on every [online] event, and on a [localChanges] event when
  /// the label is older than [maxAge].
  void follow({Stream<void>? online, Stream<void>? localChanges}) {
    if (online != null) {
      _subscriptions.add(online.listen((_) => unawaited(refresh())));
    }
    if (localChanges != null) {
      _subscriptions.add(
        localChanges.listen((_) => unawaited(refreshIfOld())),
      );
    }
  }

  /// The label of the signed-in business as last seen on this device.
  Future<void> loadRemembered() async {
    final business = await _businessId();
    _apply(business == null ? null : _preferences.getCurrencyLabel(business));
  }

  Future<void> refreshIfOld() async {
    final business = await _businessId();
    final asked = _askedAt;
    if (business == _askedFor &&
        asked != null &&
        _now().difference(asked) < maxAge) {
      return;
    }
    await refresh();
  }

  /// Reads the setting from the server. Offline or refused: the remembered
  /// label stays.
  Future<void> refresh() async {
    try {
      final business = await _businessId();
      if (business == null) {
        _apply(null);
        return;
      }
      _askedAt = _now();
      _askedFor = business;
      final label = labelOf(await _fetch());
      // Someone else signed in while the server was answering.
      if (label == null || await _businessId() != business) return;
      await _preferences.setCurrencyLabel(business, label);
      _apply(label);
    } catch (e) {
      debugPrint('[Currency] could not read the currency label: $e');
    }
  }

  /// The business-wide label in [settings]; null when it is not there.
  static String? labelOf(List<AppSettingModel> settings) {
    for (final s in settings) {
      if (s.settingKey != settingKey || s.branchId != null) continue;
      final value = s.settingValue['value']?.toString().trim();
      return value == null || value.isEmpty ? null : value;
    }
    return null;
  }

  void _apply(String? label) {
    CurrencyLabelHolder.current = label ?? CurrencyLabelHolder.fallback;
  }

  Future<void> dispose() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
    _subscriptions.clear();
  }
}
