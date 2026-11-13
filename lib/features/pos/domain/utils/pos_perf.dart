import 'package:flutter/foundation.dart';

/// Timings of the two things a cashier waits on. Logged in debug builds only;
/// the last value of each is kept so tests can assert the budgets.
abstract final class PosPerf {
  /// Tap "Add" -> the line is in the cart.
  static const addToCartBudget = Duration(milliseconds: 100);

  /// "Complete sale" -> the sale is saved on this device.
  static const saleSaveBudget = Duration(milliseconds: 300);

  static const addToCart = 'add-to-cart';
  static const modifierLookup = 'modifier lookup';
  static const saleSave = 'sale save';

  static final Map<String, Duration> _last = {};

  static Duration? last(String what) => _last[what];

  static void record(String what, Duration elapsed, {Duration? budget}) {
    _last[what] = elapsed;
    if (!kDebugMode) return;
    final over = budget != null && elapsed > budget;
    debugPrint(
      '[POS:Perf] $what ${elapsed.inMicroseconds / 1000} ms'
      '${budget == null ? '' : ' (budget ${budget.inMilliseconds} ms)'}'
      '${over ? ' SLOW' : ''}',
    );
  }

  /// Runs [body] and records how long it took.
  static Future<T> measure<T>(
    String what,
    Future<T> Function() body, {
    Duration? budget,
  }) async {
    final watch = Stopwatch()..start();
    try {
      return await body();
    } finally {
      record(what, watch.elapsed, budget: budget);
    }
  }
}
