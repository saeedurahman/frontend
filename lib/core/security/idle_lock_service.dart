import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/storage/preferences_storage.dart';

/// Locks the UI after a period of inactivity.
///
/// Locking only raises [locked]; nothing is navigated away from or disposed,
/// so carts, held orders and form state survive. The lock overlay (see
/// `IdleLockHost`) asks for the PIN and calls [unlock].
class IdleLockService {
  IdleLockService({
    required PreferencesStorage preferences,
    required Listenable authChanges,
    required bool Function() isAuthenticated,
    Future<bool> Function()? canLock,
    DateTime Function()? now,
  })  : _preferences = preferences,
        _authChanges = authChanges,
        _isAuthenticated = isAuthenticated,
        _canLock = canLock ?? (() async => true),
        _now = now ?? DateTime.now;

  final PreferencesStorage _preferences;
  final Listenable _authChanges;
  final bool Function() _isAuthenticated;
  final Future<bool> Function() _canLock;
  final DateTime Function() _now;

  /// True while the lock screen must be shown.
  final ValueNotifier<bool> locked = ValueNotifier<bool>(false);

  Timer? _timer;
  DateTime? _lastReset;
  bool _started = false;

  /// Activity events closer together than this don't restart the timer.
  static const _resetThrottle = Duration(seconds: 1);

  /// Choices offered in settings (minutes; 0 = off).
  static const timeoutChoices = <int>[0, 1, 5, 10, 15, 30, 60];

  int get timeoutMinutes => _preferences.getIdleLockMinutes();

  Duration? get timeout {
    final minutes = timeoutMinutes;
    return minutes <= 0 ? null : Duration(minutes: minutes);
  }

  void start() {
    if (_started) return;
    _started = true;
    _authChanges.addListener(_onAuthChanged);
    HardwareKeyboard.instance.addHandler(_onKey);
    _onAuthChanged();
  }

  void dispose() {
    _timer?.cancel();
    if (_started) {
      _authChanges.removeListener(_onAuthChanged);
      HardwareKeyboard.instance.removeHandler(_onKey);
    }
    locked.dispose();
  }

  Future<void> setTimeoutMinutes(int minutes) async {
    await _preferences.setIdleLockMinutes(minutes);
    _lastReset = null;
    recordActivity();
  }

  /// Call on every user interaction (pointer, key).
  void recordActivity() {
    if (!_started || locked.value || !_isAuthenticated()) return;
    final now = _now();
    final last = _lastReset;
    if (last != null && now.difference(last) < _resetThrottle) return;
    _lastReset = now;
    _arm();
  }

  /// Lock immediately (e.g. a "Lock screen" button).
  void lock() {
    if (!_isAuthenticated()) return;
    _timer?.cancel();
    locked.value = true;
  }

  void unlock() {
    if (!locked.value) return;
    locked.value = false;
    _lastReset = null;
    recordActivity();
  }

  bool _onKey(KeyEvent event) {
    recordActivity();
    return false; // never swallow keys
  }

  void _onAuthChanged() {
    if (_isAuthenticated()) {
      _lastReset = null;
      recordActivity();
    } else {
      _timer?.cancel();
      locked.value = false;
    }
  }

  void _arm() {
    _timer?.cancel();
    final delay = timeout;
    if (delay == null) return;
    _timer = Timer(delay, _onTimeout);
  }

  Future<void> _onTimeout() async {
    if (!_isAuthenticated() || locked.value) return;
    if (!await _canLock()) return; // no PIN to unlock with: never lock out
    if (!_isAuthenticated()) return;
    locked.value = true;
  }
}
