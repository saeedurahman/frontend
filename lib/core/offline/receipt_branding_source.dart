import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/repos/local_repositories.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';

/// What a receipt needs besides the sale: the business name / address and
/// the footer / paper size.
///
/// Printing happens at the counter, so both come from the device: the copies
/// kept in `sync_meta` (refreshed after every online sync and whenever this
/// class does reach the server). The server is only asked in the foreground
/// when nothing has ever been stored *and* it is reachable; a receipt is
/// never held up by, or fails because of, the network.
class ReceiptBrandingSource {
  ReceiptBrandingSource({
    required SyncStore store,
    required LocalSettingsRepository localSettings,
    required Future<Either<Failure, BusinessProfileModel>> Function()
        fetchProfile,
    required Future<Either<Failure, List<AppSettingModel>>> Function({
      String? branchId,
    }) fetchSettings,
    bool Function()? isReachable,
  })  : _store = store,
        _localSettings = localSettings,
        _fetchProfile = fetchProfile,
        _fetchSettings = fetchSettings,
        _isReachable = isReachable;

  final SyncStore _store;
  final LocalSettingsRepository _localSettings;
  final Future<Either<Failure, BusinessProfileModel>> Function() _fetchProfile;
  final Future<Either<Failure, List<AppSettingModel>>> Function({
    String? branchId,
  }) _fetchSettings;
  final bool Function()? _isReachable;

  static const profileKey = 'business_profile_cache';

  static const defaults = ReceiptDisplaySettings(
    footerText: 'Thank you for shopping with us!',
    paperSize: '80mm',
  );

  bool get _reachable => _isReachable?.call() ?? true;

  Future<BusinessProfileModel?> _cachedProfile() async {
    final json = await _store.metaJson(profileKey);
    if (json == null) return null;
    try {
      return BusinessProfileModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<BusinessProfileModel?> _refreshProfile() async {
    try {
      final result = await _fetchProfile();
      return await result.fold((_) async => null, (profile) async {
        await _store.setMeta(profileKey, jsonEncode(profile.toJson()));
        return profile;
      });
    } catch (_) {
      return null;
    }
  }

  /// Stored business profile; null when none is known yet.
  Future<BusinessProfileModel?> businessProfile() async {
    final cached = await _cachedProfile();
    if (cached != null) {
      if (_reachable) unawaited(_refreshProfile());
      return cached;
    }
    return _reachable ? _refreshProfile() : null;
  }

  /// Receipt footer and paper size from the stored settings.
  Future<ReceiptDisplaySettings> displaySettings({String? branchId}) async {
    final hasCopy =
        await _store.meta(LocalSettingsRepository.cacheKey) != null;
    if (!hasCopy && _reachable) {
      try {
        final fetched = await _fetchSettings(branchId: branchId);
        await fetched.fold((_) async {}, (settings) async {
          await _store.setMeta(
            LocalSettingsRepository.cacheKey,
            jsonEncode([for (final s in settings) s.toJson()]),
          );
        });
      } catch (_) {
        // The defaults below still print a valid receipt.
      }
    }
    final result = await GetReceiptDisplaySettingsUseCase(_localSettings)(
      branchId: branchId,
    );
    return result.fold((_) => defaults, (settings) => settings);
  }
}
