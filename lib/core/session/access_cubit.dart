import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';

typedef CurrentUserFetcher = Future<User?> Function();

class AccessState extends Equatable {
  const AccessState({
    this.user,
    this.permissionsVersion,
    this.noticeSeq = 0,
    this.notice,
  });

  final User? user;
  final int? permissionsVersion;

  /// Bumped when a refresh changed what the user may do, so the UI can tell
  /// them once.
  final int noticeSeq;
  final String? notice;

  UserAccess get access => user == null
      ? UserAccess.none
      : UserAccess(
          role: user!.role,
          roles: user!.roles,
          permissionKeys: user!.permissionKeys,
        );

  bool can(String permission) => access.can(permission);
  bool canAny(Iterable<String> permissions) => access.canAny(permissions);

  /// Branches the user is limited to; empty means no restriction was sent.
  List<String> get branchIds => user?.branchIds ?? const [];

  @override
  List<Object?> get props => [user, permissionsVersion, noticeSeq, notice];
}

/// The signed-in user's live permissions.
///
/// Refreshed from `/auth/me` every [refreshInterval], when the app is resumed,
/// after a 403, and whenever the backend's `permissions_version` moves.
class AccessCubit extends Cubit<AccessState> {
  AccessCubit({
    required CurrentUserFetcher fetchCurrentUser,
    required CurrentUserFetcher loadCachedUser,
    this.refreshInterval = const Duration(minutes: 10),
    this.minGap = const Duration(seconds: 20),
    DateTime Function()? now,
  })  : _fetchCurrentUser = fetchCurrentUser,
        _loadCachedUser = loadCachedUser,
        _now = now ?? DateTime.now,
        super(const AccessState());

  final CurrentUserFetcher _fetchCurrentUser;
  final CurrentUserFetcher _loadCachedUser;
  final Duration refreshInterval;

  /// Minimum time between two refreshes triggered by 403s / resume, so a burst
  /// of denied requests costs one call.
  final Duration minGap;
  final DateTime Function() _now;

  static const permissionsChangedNotice =
      'Your permissions were updated by an administrator.';

  Timer? _timer;
  Future<void>? _inFlight;
  DateTime? _lastRefresh;

  /// Loads the cached user at once (so the UI is not empty), then refreshes.
  Future<void> startSession() async {
    _timer?.cancel();
    _timer = Timer.periodic(refreshInterval, (_) => refresh(force: true));
    final cached = await _loadCachedUser();
    if (isClosed) return;
    if (cached != null && state.user == null) {
      emit(AccessState(
        user: cached,
        permissionsVersion: cached.permissionsVersion,
      ));
    }
    await refresh(force: true);
  }

  void stopSession() {
    _timer?.cancel();
    _timer = null;
    _inFlight = null;
    _lastRefresh = null;
    if (!isClosed) emit(const AccessState());
  }

  /// Re-reads the user. [force] skips the throttle (timer, startup).
  Future<void> refresh({bool force = false}) {
    final running = _inFlight;
    if (running != null) return running;
    final last = _lastRefresh;
    if (!force && last != null && _now().difference(last) < minGap) {
      return Future<void>.value();
    }
    final future = _refresh().whenComplete(() => _inFlight = null);
    _inFlight = future;
    return future;
  }

  Future<void> _refresh() async {
    _lastRefresh = _now();
    User? fresh;
    try {
      fresh = await _fetchCurrentUser();
    } catch (_) {
      fresh = null;
    }
    if (isClosed || fresh == null) return;
    apply(fresh);
  }

  /// Installs [fresh] and tells the user when their rights moved.
  void apply(User fresh) {
    final before = state.user;
    final versionMoved = before?.permissionsVersion != null &&
        fresh.permissionsVersion != null &&
        before!.permissionsVersion != fresh.permissionsVersion;
    final rightsChanged = before != null &&
        (!setEquals(_keySet(before), _keySet(fresh)) ||
            before.role != fresh.role ||
            versionMoved);

    emit(AccessState(
      user: fresh,
      permissionsVersion: fresh.permissionsVersion,
      noticeSeq: rightsChanged ? state.noticeSeq + 1 : state.noticeSeq,
      notice: rightsChanged ? permissionsChangedNotice : state.notice,
    ));
  }

  /// The backend told us the version moved (e.g. a header or token claim).
  void onPermissionsVersion(int? version) {
    if (version == null || version == state.permissionsVersion) return;
    refresh(force: true);
  }

  /// A request was refused with 403: the cached permissions may be stale.
  void onForbidden() {
    refresh();
  }

  /// App came back to the foreground.
  void onResumed() {
    refresh();
  }

  static Set<String> _keySet(User user) => user.permissionKeys.toSet();

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
