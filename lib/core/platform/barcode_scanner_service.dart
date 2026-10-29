import 'dart:async';

import 'package:flutter/services.dart';

/// Source of scanned barcodes.
///
/// Desktop: a USB/Bluetooth scanner acting as a keyboard ("keyboard wedge").
/// Mobile (later): the camera, behind the same interface.
abstract class BarcodeScannerService {
  /// Every completed scan, as the raw code text.
  Stream<String> get scans;

  /// Starts listening (idempotent).
  void start();

  /// Stops listening (idempotent).
  void stop();
}

/// Turns a stream of timed key characters into scans.
///
/// A scanner types a whole code within a few milliseconds and ends with
/// Enter; a human is far slower. A burst counts as a scan only when it has at
/// least [minLength] characters and every gap is below [maxGap].
class WedgeDecoder {
  WedgeDecoder({
    this.maxGap = const Duration(milliseconds: 80),
    this.minLength = 4,
  });

  final Duration maxGap;
  final int minLength;

  final StringBuffer _buffer = StringBuffer();
  Duration? _last;

  /// Feeds one printable character at [at]. Slow typing restarts the burst.
  void addChar(String char, Duration at) {
    final last = _last;
    if (last != null && at - last > maxGap) _buffer.clear();
    _buffer.write(char);
    _last = at;
  }

  /// Enter: returns the scanned code, or null if the burst was not a scan.
  String? submit(Duration at) {
    final last = _last;
    final fast = last != null && at - last <= maxGap;
    final code = _buffer.toString();
    reset();
    if (!fast || code.length < minLength) return null;
    return code;
  }

  void reset() {
    _buffer.clear();
    _last = null;
  }
}

class KeyboardWedgeBarcodeScanner implements BarcodeScannerService {
  KeyboardWedgeBarcodeScanner({WedgeDecoder? decoder})
      : _decoder = decoder ?? WedgeDecoder();

  final WedgeDecoder _decoder;
  final StreamController<String> _controller = StreamController.broadcast();
  bool _started = false;

  @override
  Stream<String> get scans => _controller.stream;

  @override
  void start() {
    if (_started) return;
    _started = true;
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void stop() {
    if (!_started) return;
    _started = false;
    HardwareKeyboard.instance.removeHandler(_onKey);
    _decoder.reset();
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      final code = _decoder.submit(event.timeStamp);
      if (code != null) _controller.add(code);
      return false;
    }
    final char = event.character;
    if (char != null && char.length == 1 && char.codeUnitAt(0) >= 0x20) {
      _decoder.addChar(char, event.timeStamp);
    }
    // Never swallow keys: normal typing must keep working.
    return false;
  }
}
