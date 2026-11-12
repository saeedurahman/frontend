import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/storage/preferences_storage.dart';

/// Owner-adjustable behavior of the counter when it cannot ask the server.
class OfflinePolicy {
  OfflinePolicy(this._prefs, this._catalog);

  final PreferencesStorage _prefs;
  final LocalCatalog _catalog;

  /// Selling more than the recorded stock: a warning, not a block.
  ///
  /// Order of precedence: the owner's switch on this device, then the
  /// business setting `allow_negative_stock` delivered by sync, then "allow"
  /// (the server accepts oversold replayed sales and flags them).
  Future<bool> allowSellBelowStock() async {
    final local = _prefs.getAllowBelowStock();
    if (local != null) return local;
    final settings = await _catalog.settings();
    final server = settings?['allow_negative_stock'];
    return server is bool ? server : true;
  }

  bool get showSyncDetails => _prefs.getShowSyncDetails();
}
