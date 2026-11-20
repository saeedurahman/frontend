import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The two sounds a scan makes.
enum FeedbackSound { success, error }

/// Plays the beep after a scan (a good beep, a bad beep). Muting is a
/// per-device preference: a noisy shop floor is a property of the counter,
/// not of the business, so it is not a server setting.
abstract class FeedbackSoundService {
  bool get enabled;

  Future<void> setEnabled(bool value);

  /// Plays [sound] unless muted. Never throws and never blocks the scan.
  void play(FeedbackSound sound);
}

class SystemFeedbackSoundService implements FeedbackSoundService {
  SystemFeedbackSoundService(this._prefs);

  static const prefsKey = 'quick_add.sound_enabled';

  final SharedPreferences _prefs;

  @override
  bool get enabled => _prefs.getBool(prefsKey) ?? true;

  @override
  Future<void> setEnabled(bool value) => _prefs.setBool(prefsKey, value);

  @override
  void play(FeedbackSound sound) {
    if (!enabled) return;
    try {
      if (Platform.isWindows) {
        _windowsBeep(sound);
      } else {
        SystemSound.play(sound == FeedbackSound.success ? SystemSoundType.click : SystemSoundType.alert);
      }
    } catch (_) {
      // No sound is better than a failed scan.
    }
  }

  static int Function(int)? _messageBeep;

  static void _windowsBeep(FeedbackSound sound) {
    _messageBeep ??= DynamicLibrary.open('user32.dll')
        .lookupFunction<Int32 Function(Uint32), int Function(int)>('MessageBeep');
    // MB_OK (0) is the soft "ding"; MB_ICONHAND (0x10) the error sound.
    _messageBeep!(sound == FeedbackSound.success ? 0x00000000 : 0x00000010);
  }
}

/// Silent (tests, and platforms without sound).
class NoFeedbackSound implements FeedbackSoundService {
  const NoFeedbackSound();

  @override
  bool get enabled => false;

  @override
  Future<void> setEnabled(bool value) async {}

  @override
  void play(FeedbackSound sound) {}
}
