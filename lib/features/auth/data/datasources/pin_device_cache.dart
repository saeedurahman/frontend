import 'dart:convert';

import 'package:frantend/core/storage/secure_storage.dart';
import 'package:injectable/injectable.dart';

class PinStaffEntry {
  const PinStaffEntry({
    required this.id,
    required this.fullName,
    this.lastUsedAt,
  });

  final String id;
  final String fullName;

  /// ISO-8601 UTC timestamp of last PIN login on this device; null for legacy rows.
  final String? lastUsedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      };

  factory PinStaffEntry.fromJson(Map<String, dynamic> json) => PinStaffEntry(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        lastUsedAt: json['last_used_at'] as String?,
      );
}

class PinDeviceCacheData {
  const PinDeviceCacheData({
    required this.businessSlug,
    required this.staff,
    this.lastFullRefreshAt,
  });

  final String businessSlug;
  final List<PinStaffEntry> staff;

  /// ISO-8601 UTC timestamp of last successful GET /users roster replace.
  final String? lastFullRefreshAt;

  Map<String, dynamic> toJson() => {
        'business_slug': businessSlug,
        'staff': staff.map((e) => e.toJson()).toList(),
        if (lastFullRefreshAt != null) 'last_full_refresh_at': lastFullRefreshAt,
      };

  factory PinDeviceCacheData.fromJson(Map<String, dynamic> json) {
    final staffJson = json['staff'];
    return PinDeviceCacheData(
      businessSlug: json['business_slug'] as String? ?? '',
      staff: staffJson is List
          ? staffJson
              .whereType<Map<String, dynamic>>()
              .map(PinStaffEntry.fromJson)
              .toList()
          : const [],
      lastFullRefreshAt: json['last_full_refresh_at'] as String?,
    );
  }
}

abstract class PinDeviceCache {
  Future<PinDeviceCacheData?> read();
  Future<void> write(PinDeviceCacheData data);
}

@LazySingleton(as: PinDeviceCache)
class PinDeviceCacheImpl implements PinDeviceCache {
  PinDeviceCacheImpl(this._secureStorage);

  final SecureStorage _secureStorage;

  @override
  Future<PinDeviceCacheData?> read() async {
    final raw = await _secureStorage.getPinDeviceCache();
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return null;
      return PinDeviceCacheData.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(PinDeviceCacheData data) async {
    await _secureStorage.savePinDeviceCache(jsonEncode(data.toJson()));
  }
}
