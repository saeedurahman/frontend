import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frantend/core/error/failures.dart';

/// The one place that turns a transport problem into words for the screen.
///
/// Raw `DioException` / `SocketException` text ("The connection errored: the
/// remote computer refused the network connection ...") is for logs only. The
/// UI gets one of the short sentences below.
abstract final class UserErrorMessage {
  /// The server cannot be reached (offline, refused, DNS, timeout).
  static const offline =
      "Can't reach the server. Check the connection and try again.";

  /// The work is safe on the device and waits for the next sync.
  static const savedOffline = 'Saved on this device, will sync when online';

  /// A record that has not reached the server yet.
  static const notSyncedYet = 'Not synced yet';

  /// Shown instead of data that only the server has.
  static const needsConnection = 'This is available when you are online.';

  static const generic = 'Something went wrong. Please try again.';

  /// True for every "the request never got an answer" error.
  static bool isConnectionError(Object? error) {
    if (error is NetworkFailure) return true;
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return true;
        case DioExceptionType.unknown:
          return error.error == null || isConnectionError(error.error);
        default:
          return false;
      }
    }
    return error is SocketException ||
        error is HttpException ||
        error is HandshakeException ||
        error is TimeoutException;
  }

  static final _rawMarkers = <RegExp>[
    RegExp('DioException', caseSensitive: false),
    RegExp('SocketException', caseSensitive: false),
    RegExp('HttpException', caseSensitive: false),
    RegExp('HandshakeException', caseSensitive: false),
    RegExp('ClientException', caseSensitive: false),
    RegExp('The connection errored', caseSensitive: false),
    RegExp('connection (was )?refused', caseSensitive: false),
    RegExp('refused the network connection', caseSensitive: false),
    RegExp('cannot be solved by the library', caseSensitive: false),
    RegExp('Failed host lookup', caseSensitive: false),
    RegExp('Connection (closed|reset|timed out)', caseSensitive: false),
    RegExp('Network is unreachable', caseSensitive: false),
    RegExp(r'errno\s*=\s*\d+', caseSensitive: false),
    RegExp('RequestOptions', caseSensitive: false),
    RegExp(r'took longer than .* to (connect|receive|send)',
        caseSensitive: false),
  ];

  /// True when [text] is transport-library output, not a sentence for a user.
  static bool looksRaw(String? text) {
    if (text == null || text.isEmpty) return false;
    return _rawMarkers.any((m) => m.hasMatch(text));
  }

  /// [message] unless it is raw transport text, which becomes [offline].
  static String clean(String? message, {String fallback = generic}) {
    final text = message?.trim() ?? '';
    if (text.isEmpty) return fallback;
    if (looksRaw(text)) return offline;
    return text;
  }

  /// Words for any thrown object or [Failure].
  static String from(Object? error, {String fallback = generic}) {
    if (error == null) return fallback;
    if (error is Failure) {
      return error is NetworkFailure
          ? clean(error.message, fallback: offline)
          : clean(error.message, fallback: fallback);
    }
    if (isConnectionError(error)) return offline;
    final text = error.toString();
    const prefix = 'Exception: ';
    return clean(
      text.startsWith(prefix) ? text.substring(prefix.length) : text,
      fallback: fallback,
    );
  }
}
