import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/security/idle_lock_service.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Auth extends ChangeNotifier {
  bool signedIn = true;

  void set(bool value) {
    signedIn = value;
    notifyListeners();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PreferencesStorage prefs;
  late _Auth auth;
  var canLock = true;
  late DateTime clock;

  Future<IdleLockService> build({Map<String, Object> stored = const {}}) async {
    SharedPreferences.setMockInitialValues(stored);
    prefs = PreferencesStorage(await SharedPreferences.getInstance());
    auth = _Auth();
    canLock = true;
    clock = DateTime(2026, 1, 1);
    return IdleLockService(
      preferences: prefs,
      authChanges: auth,
      isAuthenticated: () => auth.signedIn,
      canLock: () async => canLock,
      now: () => clock,
    );
  }

  test('default timeout is 10 minutes', () async {
    final service = await build();
    expect(PreferencesStorage.defaultIdleLockMinutes, 10);
    expect(service.timeout, const Duration(minutes: 10));
    service.dispose();
  });

  test('locks after the default 10 minutes of inactivity', () async {
    final service = await build();
    fakeAsync((async) {
      service.start();
      async.elapse(const Duration(minutes: 9, seconds: 59));
      expect(service.locked.value, isFalse);
      async.elapse(const Duration(seconds: 2));
      async.flushMicrotasks();
      expect(service.locked.value, isTrue);
    });
    service.dispose();
  });

  test('activity restarts the countdown', () async {
    final service = await build();
    fakeAsync((async) {
      service.start();
      async.elapse(const Duration(minutes: 8));
      clock = clock.add(const Duration(minutes: 8));
      service.recordActivity();
      async.elapse(const Duration(minutes: 8));
      async.flushMicrotasks();
      expect(service.locked.value, isFalse, reason: '8+8 < 10 after reset');
      async.elapse(const Duration(minutes: 3));
      async.flushMicrotasks();
      expect(service.locked.value, isTrue);
    });
    service.dispose();
  });

  test('timeout is configurable and 0 disables the lock', () async {
    final service = await build(stored: {'idle_lock_minutes': 0});
    expect(service.timeout, isNull);
    fakeAsync((async) {
      service.start();
      async.elapse(const Duration(hours: 5));
      async.flushMicrotasks();
      expect(service.locked.value, isFalse);
    });
    service.dispose();

    final short = await build(stored: {'idle_lock_minutes': 1});
    fakeAsync((async) {
      short.start();
      async.elapse(const Duration(minutes: 1, seconds: 1));
      async.flushMicrotasks();
      expect(short.locked.value, isTrue);
    });
    short.dispose();
  });

  test('setTimeoutMinutes persists the choice', () async {
    final service = await build();
    await service.setTimeoutMinutes(30);
    expect(prefs.getIdleLockMinutes(), 30);
    expect(service.timeout, const Duration(minutes: 30));
    service.dispose();
  });

  test('does not lock users who cannot unlock (no PIN / kitchen display)',
      () async {
    final service = await build();
    canLock = false;
    fakeAsync((async) {
      service.start();
      async.elapse(const Duration(minutes: 30));
      async.flushMicrotasks();
      expect(service.locked.value, isFalse);
    });
    service.dispose();
  });

  test('does not lock while signed out and unlocks on sign-out', () async {
    final service = await build();
    fakeAsync((async) {
      auth.set(false);
      service.start();
      async.elapse(const Duration(minutes: 30));
      async.flushMicrotasks();
      expect(service.locked.value, isFalse);

      auth.set(true);
      async.elapse(const Duration(minutes: 11));
      async.flushMicrotasks();
      expect(service.locked.value, isTrue);

      auth.set(false);
      expect(service.locked.value, isFalse);
    });
    service.dispose();
  });

  test('unlock clears the lock and re-arms the timer', () async {
    final service = await build();
    fakeAsync((async) {
      service.start();
      async.elapse(const Duration(minutes: 11));
      async.flushMicrotasks();
      expect(service.locked.value, isTrue);

      service.unlock();
      expect(service.locked.value, isFalse);

      async.elapse(const Duration(minutes: 11));
      async.flushMicrotasks();
      expect(service.locked.value, isTrue);
    });
    service.dispose();
  });

  test('activity while locked is ignored (cannot bypass the lock)', () async {
    final service = await build();
    fakeAsync((async) {
      service.start();
      async.elapse(const Duration(minutes: 11));
      async.flushMicrotasks();
      expect(service.locked.value, isTrue);

      clock = clock.add(const Duration(minutes: 11));
      service.recordActivity();
      expect(service.locked.value, isTrue);
    });
    service.dispose();
  });

  test('manual lock() locks immediately', () async {
    final service = await build();
    service.start();
    service.lock();
    expect(service.locked.value, isTrue);
    service.dispose();
  });
}
