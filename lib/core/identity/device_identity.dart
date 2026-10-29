import 'dart:io';

import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/platform/secure_key_store.dart';

/// Who this installation is, for the (later) sync engine and audit trails.
///
/// `deviceId` is generated once, persisted in secure storage and survives
/// logout, tenant switches and app updates. It only changes if the secure
/// store is wiped (reinstall / OS reset).
class DeviceIdentity {
  DeviceIdentity({
    required SecureKeyStore store,
    required IdGenerator ids,
    String Function()? hostName,
  })  : _store = store,
        _ids = ids,
        _hostName = hostName ?? _defaultHostName;

  static const deviceIdKey = 'device_id';
  static const deviceNameKey = 'device_name';

  final SecureKeyStore _store;
  final IdGenerator _ids;
  final String Function() _hostName;

  String? _cachedId;
  Future<String>? _inFlight;

  /// The stable device id (created on first use).
  Future<String> deviceId() {
    final cached = _cachedId;
    if (cached != null) return Future.value(cached);
    return _inFlight ??= _load().whenComplete(() => _inFlight = null);
  }

  Future<String> _load() async {
    final existing = await _store.read(deviceIdKey);
    if (existing != null && isUuidV4(existing)) {
      return _cachedId = existing;
    }
    final created = _ids.newId();
    await _store.write(deviceIdKey, created);
    return _cachedId = created;
  }

  /// Human readable name, e.g. "FRONT-COUNTER-PC". A user-set name wins.
  Future<String> deviceName() async {
    final stored = await _store.read(deviceNameKey);
    if (stored != null && stored.trim().isNotEmpty) return stored;
    return _hostName();
  }

  Future<void> setDeviceName(String name) =>
      _store.write(deviceNameKey, name.trim());

  static String _defaultHostName() {
    try {
      final host = Platform.localHostname.trim();
      return host.isEmpty ? 'unknown-device' : host;
    } catch (_) {
      return 'unknown-device';
    }
  }
}
