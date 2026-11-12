import 'dart:async';

/// One-line messages for the user that originate outside the widget tree
/// (sync finished with flagged sales, device removed, ...). `SessionNoticeHost`
/// shows them as snackbars.
abstract final class SessionNotices {
  static final StreamController<String> _controller =
      StreamController<String>.broadcast();

  static Stream<String> get stream => _controller.stream;

  static void post(String message) {
    if (!_controller.isClosed) _controller.add(message);
  }
}
