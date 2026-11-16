import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/repos/local_repositories.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';

/// What a receipt needs besides the sale: the business name, address, phone,
/// NTN, and the footer / paper size.
///
/// **Never a network call.** Printing (and reprinting an old sale) happens at
/// the counter, so everything comes from the device:
///
/// 1. the pulled `settings` entity (`business_name`, `address_line1`,
///    `phone`, `tax_id` / `ntn`, `receipt_footer`), kept fresh by the sync;
/// 2. only when that is missing (an install from before settings were
///    pulled), the older copies kept in `sync_meta`.
///
/// When neither exists the defaults below still print a valid receipt.
class ReceiptBrandingSource {
  ReceiptBrandingSource({
    required SyncStore store,
    required LocalSettingsRepository localSettings,
    LocalCatalog? catalog,
  })  : _store = store,
        _localSettings = localSettings,
        _catalog = catalog ?? LocalCatalog(store, businessId: () async => null);

  final SyncStore _store;
  final LocalSettingsRepository _localSettings;
  final LocalCatalog _catalog;

  static const profileKey = 'business_profile_cache';

  static const defaults = ReceiptDisplaySettings(
    footerText: 'Thank you for shopping with us!',
    paperSize: '80mm',
  );

  static String? _text(Map<String, dynamic> data, List<String> keys) {
    for (final k in keys) {
      final v = data[k]?.toString().trim();
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  Future<BusinessProfileModel?> _cachedProfile() async {
    final json = await _store.metaJson(profileKey);
    if (json == null) return null;
    try {
      return BusinessProfileModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// The business as the receipt header shows it; null when nothing is known.
  Future<BusinessProfileModel?> businessProfile() async {
    final pulled = await _catalog.settings();
    final name = pulled == null ? null : _text(pulled, ['business_name', 'name']);
    if (pulled != null && name != null) {
      final cached = await _cachedProfile();
      final base = cached ??
          BusinessProfileModel(id: '${pulled['id'] ?? ''}', name: name);
      return base.copyWith(
        name: name,
        phone: _text(pulled, ['phone']) ?? base.phone,
        taxId: _text(pulled, ['tax_id', 'ntn']) ?? base.taxId,
        addressLine1:
            _text(pulled, ['address_line1', 'address']) ?? base.addressLine1,
      );
    }
    return _cachedProfile();
  }

  /// Receipt footer and paper size.
  Future<ReceiptDisplaySettings> displaySettings({String? branchId}) async {
    final legacy = await GetReceiptDisplaySettingsUseCase(_localSettings)(
      branchId: branchId,
    );
    final stored = legacy.fold((_) => defaults, (s) => s);
    final pulled = await _catalog.settings();
    final footer = pulled == null ? null : _text(pulled, ['receipt_footer']);
    if (footer == null) return stored;
    return ReceiptDisplaySettings(footerText: footer, paperSize: stored.paperSize);
  }
}
