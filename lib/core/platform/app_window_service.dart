import 'package:flutter/services.dart';
import 'package:frantend/core/brand/app_brand.dart';

/// Controls the native application window (desktop only).
abstract class AppWindowService {
  /// Sets the OS window title; null restores the brand name.
  Future<void> setTitle([String? title]);
}

/// Windows implementation: asks the runner over a method channel. The runner
/// already starts with the brand title (see `windows/runner/main.cpp`), so a
/// runner that does not handle the channel yet is not an error.
class WindowsAppWindowService implements AppWindowService {
  WindowsAppWindowService({MethodChannel? channel, AppBrand Function()? brand})
      : _channel = channel ?? const MethodChannel(channelName),
        _brand = brand ?? (() => AppBrand.current);

  static const channelName = 'app/window';

  final MethodChannel _channel;
  final AppBrand Function() _brand;

  @override
  Future<void> setTitle([String? title]) async {
    try {
      await _channel.invokeMethod<void>('setTitle', title ?? _brand().appName);
    } on MissingPluginException {
      // Native side not present: the static runner title stays.
    } on PlatformException {
      // Cosmetic; never break startup over a window title.
    }
  }
}

/// For platforms without a window title (mobile) and for tests.
class NoopAppWindowService implements AppWindowService {
  const NoopAppWindowService();

  @override
  Future<void> setTitle([String? title]) async {}
}
