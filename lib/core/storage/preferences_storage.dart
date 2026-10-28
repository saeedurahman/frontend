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

  Future<bool> clear() => _prefs.clear();
}

@module
abstract class PreferencesModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
