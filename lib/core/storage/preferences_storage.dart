import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class PreferencesStorage {
  PreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'theme_mode';
  static const String _lastSyncKey = 'last_sync_at';
  static const String _selectedBranchKey = 'selected_branch_id';
  static const String _idleLockMinutesKey = 'idle_lock_minutes';
  static const String _allowBelowStockKey = 'offline_allow_below_stock';
  static const String _showSyncDetailsKey = 'offline_show_sync_details';
  static const String _askQuantityOnTapKey = 'pos_ask_quantity_on_tap';
  static const String _lastPaymentSourceKey = 'khata_last_payment_source';

  /// Default inactivity before the PIN lock appears. 0 disables auto-lock.
  static const int defaultIdleLockMinutes = 10;

  String? getLocale() => _prefs.getString(_localeKey);

  Future<bool> setLocale(String locale) => _prefs.setString(_localeKey, locale);

  String? getThemeMode() => _prefs.getString(_themeModeKey);

  Future<bool> setThemeMode(String mode) => _prefs.setString(_themeModeKey, mode);

  String? getLastSyncAt() => _prefs.getString(_lastSyncKey);

  Future<bool> setLastSyncAt(String timestamp) =>
      _prefs.setString(_lastSyncKey, timestamp);

  String? getSelectedBranchId() => _prefs.getString(_selectedBranchKey);

  Future<bool> setSelectedBranchId(String branchId) =>
      _prefs.setString(_selectedBranchKey, branchId);

  int getIdleLockMinutes() =>
      _prefs.getInt(_idleLockMinutesKey) ?? defaultIdleLockMinutes;

  Future<bool> setIdleLockMinutes(int minutes) =>
      _prefs.setInt(_idleLockMinutesKey, minutes < 0 ? 0 : minutes);

  /// Owner switch: sell below the recorded stock. Null = follow the server
  /// setting (default allowed).
  bool? getAllowBelowStock() => _prefs.getBool(_allowBelowStockKey);

  Future<bool> setAllowBelowStock(bool value) =>
      _prefs.setBool(_allowBelowStockKey, value);

  /// The money label last read for a business (it is not in the sync feed).
  String? getCurrencyLabel(String businessId) =>
      _prefs.getString('currency_label_$businessId');

  Future<bool> setCurrencyLabel(String businessId, String label) =>
      _prefs.setString('currency_label_$businessId', label);

  bool getShowSyncDetails() => _prefs.getBool(_showSyncDetailsKey) ?? false;

  Future<bool> setShowSyncDetails(bool value) =>
      _prefs.setBool(_showSyncDetailsKey, value);

  /// POS: tapping a product opens the quantity calculator (default) instead
  /// of adding one unit straight away.
  bool getAskQuantityOnTap() => _prefs.getBool(_askQuantityOnTapKey) ?? true;

  Future<bool> setAskQuantityOnTap(bool value) =>
      _prefs.setBool(_askQuantityOnTapKey, value);

  /// The `payment_source` used for the last supplier payment on this device.
  String? getLastPaymentSource() => _prefs.getString(_lastPaymentSourceKey);

  Future<bool> setLastPaymentSource(String source) =>
      _prefs.setString(_lastPaymentSourceKey, source);

  Future<bool> clear() => _prefs.clear();
}

@module
abstract class PreferencesModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
