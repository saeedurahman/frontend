import 'dart:async';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';

/// What the app knows about reaching the backend.
enum ReachabilityStatus {
  /// `GET /time` answered promptly.
  online,

  /// `GET /time` could not be completed (repeatedly).
  offline,

  /// The server answers, but slowly or with an error: expect flaky calls.
  degraded,
}

/// Measures one round trip to the backend.
///
/// Returns the latency on success and throws on timeout / connection error /
/// non-2xx. Injectable so tests never open a socket.
typedef ReachabilityPing = Future<Duration> Function(Duration timeout);

/// Real reachability, as opposed to "a network adapter is up".
///
/// The OS connectivity state (connectivity_plus) is only a *hint* used to
/// probe sooner or to skip pointless probes; the verdict always comes from a
/// `GET /time` with a 3 second timeout.
abstract class ConnectivityProbe {
  /// Last known verdict (starts as [ReachabilityStatus.online] until the
  /// first probe completes, so cold start never flashes "offline").
  ReachabilityStatus get current;

  /// Emits only when the verdict changes.
  Stream<ReachabilityStatus> get status;

  /// Probes now and returns the new verdict.
  Future<ReachabilityStatus> check();

  /// Begins periodic probing (idempotent).
  void start();

  /// Stops probing (idempotent).
  void stop();

  /// True while the backend is believed reachable ([degraded] counts: calls
  /// may still succeed, so they are attempted rather than refused).
  bool get isReachable => current != ReachabilityStatus.offline;

  void dispose();
}

class HttpConnectivityProbe implements ConnectivityProbe {
  HttpConnectivityProbe({
    required ReachabilityPing ping,
    Stream<bool>? hint,
    this.probeTimeout = const Duration(seconds: 3),
    this.onlineInterval = const Duration(seconds: 30),
    this.minBackoff = const Duration(seconds: 2),
    this.maxBackoff = const Duration(seconds: 60),
    this.degradedLatency = const Duration(milliseconds: 1500),
    this.failuresBeforeOffline = 2,
    this.hintDebounce = const Duration(milliseconds: 500),
  })  : _ping = ping,
        _hint = hint;

  /// Probe against `GET /time` of the API using [dio] (no auth, no retries).
  factory HttpConnectivityProbe.forApi({
    required Dio dio,
    Connectivity? connectivity,
    String path = ApiConstants.serverTime,
  }) {
    return HttpConnectivityProbe(
      ping: (timeout) async {
        final watch = Stopwatch()..start();
        final response = await dio.get<dynamic>(
          path,
          options: Options(
            connectTimeout: timeout,
            receiveTimeout: timeout,
            sendTimeout: timeout,
            extra: const {'no_retry': true},
          ),
        );
        final code = response.statusCode ?? 0;
        if (code < 200 || code >= 300) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          );
        }
        return watch.elapsed;
      },
      hint: connectivity?.onConnectivityChanged.map(
        (r) => r != ConnectivityResult.none,
      ),
    );
  }

  final ReachabilityPing _ping;
  final Stream<bool>? _hint;
  final Duration probeTimeout;
  final Duration onlineInterval;
  final Duration minBackoff;
  final Duration maxBackoff;
  final Duration degradedLatency;

  /// Consecutive failed probes needed before reporting offline (debounce:
  /// one dropped packet must not flip the whole UI).
  final int failuresBeforeOffline;
  final Duration hintDebounce;

  final StreamController<ReachabilityStatus> _controller =
      StreamController<ReachabilityStatus>.broadcast();

  ReachabilityStatus _current = ReachabilityStatus.online;
  int _failures = 0;
  Duration _backoff = Duration.zero;
  Timer? _timer;
  Timer? _hintTimer;
  StreamSubscription<bool>? _hintSub;
  bool _running = false;
  bool _disposed = false;
  Future<ReachabilityStatus>? _inFlight;

  @override
  ReachabilityStatus get current => _current;

  @override
  bool get isReachable => _current != ReachabilityStatus.offline;

  @override
  Stream<ReachabilityStatus> get status => _controller.stream;

  /// Delay before the next probe: steady while online, exponential
  /// (2s, 4s, 8s ... capped) while offline.
  Duration get nextDelay =>
      _current == ReachabilityStatus.offline ? _backoff : onlineInterval;

  @override
  void start() {
    if (_running || _disposed) return;
    _running = true;
    _hintSub = _hint?.listen(_onHint);
    unawaited(check());
  }

  @override
  void stop() {
    _running = false;
    _timer?.cancel();
    _timer = null;
    _hintTimer?.cancel();
    _hintTimer = null;
    unawaited(_hintSub?.cancel());
    _hintSub = null;
  }

  void _onHint(bool networkUp) {
    // The OS says the adapter changed: re-probe soon (debounced) rather than
    // trusting it. Losing the adapter still needs a failed probe to count.
    _hintTimer?.cancel();
    _hintTimer = Timer(hintDebounce, () {
      if (_running) unawaited(check());
    });
  }

  @override
  Future<ReachabilityStatus> check() {
    return _inFlight ??= _probe().whenComplete(() => _inFlight = null);
  }

  Future<ReachabilityStatus> _probe() async {
    ReachabilityStatus verdict;
    try {
      final latency = await _ping(probeTimeout);
      _failures = 0;
      _backoff = Duration.zero;
      verdict = latency >= degradedLatency
          ? ReachabilityStatus.degraded
          : ReachabilityStatus.online;
    } catch (e) {
      _failures++;
      if (e is DioException && e.type == DioExceptionType.badResponse) {
        // The server is there but unhealthy (5xx etc.): degraded, not offline.
        verdict = ReachabilityStatus.degraded;
      } else if (_failures >= failuresBeforeOffline) {
        verdict = ReachabilityStatus.offline;
      } else {
        // First miss: keep the previous verdict, retry quickly.
        verdict = _current;
      }
      if (verdict == ReachabilityStatus.offline) {
        _backoff = _backoff == Duration.zero
            ? minBackoff
            : Duration(
                milliseconds: math.min(
                  _backoff.inMilliseconds * 2,
                  maxBackoff.inMilliseconds,
                ),
              );
      }
    }
    _set(verdict);
    _schedule();
    return verdict;
  }

  void _set(ReachabilityStatus next) {
    if (_disposed || next == _current) return;
    _current = next;
    _controller.add(next);
  }

  void _schedule() {
    _timer?.cancel();
    if (!_running || _disposed) return;
    // A single miss while still "online" is re-checked at the offline pace.
    final delay = _failures > 0 && _current != ReachabilityStatus.offline
        ? minBackoff
        : nextDelay;
    _timer = Timer(delay, () => unawaited(check()));
  }

  @override
  void dispose() {
    _disposed = true;
    stop();
    unawaited(_controller.close());
  }
}

/// Always-online probe for tests and previews.
class FixedConnectivityProbe implements ConnectivityProbe {
  FixedConnectivityProbe([this._status = ReachabilityStatus.online]);

  ReachabilityStatus _status;
  final StreamController<ReachabilityStatus> _controller =
      StreamController<ReachabilityStatus>.broadcast(sync: true);

  void set(ReachabilityStatus next) {
    if (next == _status) return;
    _status = next;
    _controller.add(next);
  }

  @override
  ReachabilityStatus get current => _status;

  @override
  bool get isReachable => _status != ReachabilityStatus.offline;

  @override
  Stream<ReachabilityStatus> get status => _controller.stream;

  @override
  Future<ReachabilityStatus> check() async => _status;

  @override
  void start() {}

  @override
  void stop() {}

  @override
  void dispose() => unawaited(_controller.close());
}
