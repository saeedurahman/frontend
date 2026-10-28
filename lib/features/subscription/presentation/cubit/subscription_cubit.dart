import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/subscription/data/subscription_status.dart';

typedef SubscriptionFetcher = Future<SubscriptionStatus> Function();

/// A banner appears when this many days (or fewer) are left.
const int kSubscriptionBannerDays = 7;

class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.status,
    this.block,
    this.isLoading = false,
    this.graceNoticeSeq = 0,
    this.graceNotice,
  });

  /// Last status read from the server.
  final SubscriptionStatus? status;

  /// Last 402 seen on any request. Cleared by the next successful status load.
  final SubscriptionFailure? block;

  final bool isLoading;

  /// Bumped on every refused write in grace mode so the UI can show a
  /// snackbar each time (not just on the first).
  final int graceNoticeSeq;
  final String? graceNotice;

  bool get _graceBlock => block?.isGraceReadOnly ?? false;

  /// The business may not use the app at all.
  bool get isBlocked {
    if (block != null && !_graceBlock) return true;
    if (_graceBlock) return false;
    return status?.isHardBlocked ?? false;
  }

  /// Read-only: everything that creates, edits or deletes is refused.
  bool get isGraceReadOnly {
    if (isBlocked) return false;
    return _graceBlock || (status?.isGrace ?? false);
  }

  int? get daysLeft => status?.daysLeft;

  /// Show "ends in X days" (only while the app is still fully usable).
  bool get showExpiryBanner {
    final days = daysLeft;
    return !isBlocked &&
        !isGraceReadOnly &&
        days != null &&
        days >= 0 &&
        days <= kSubscriptionBannerDays;
  }

  SubscriptionContact get contact {
    final fromBlock = block?.contact;
    if (fromBlock != null && !fromBlock.isEmpty) return fromBlock;
    return status?.contact ?? SubscriptionContact.empty;
  }

  DateTime? get expiredAt => block?.expiredAt ?? status?.endsAt;

  String get message =>
      block?.message ?? SubscriptionFailure.defaultMessage;

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    SubscriptionFailure? block,
    bool clearBlock = false,
    bool? isLoading,
    int? graceNoticeSeq,
    String? graceNotice,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      block: clearBlock ? null : (block ?? this.block),
      isLoading: isLoading ?? this.isLoading,
      graceNoticeSeq: graceNoticeSeq ?? this.graceNoticeSeq,
      graceNotice: graceNotice ?? this.graceNotice,
    );
  }

  @override
  List<Object?> get props =>
      [status, block, isLoading, graceNoticeSeq, graceNotice];
}

/// Global subscription state: loaded after login / cold start and every
/// [refreshInterval], and fed by every 402 the HTTP layer sees.
class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit({
    required SubscriptionFetcher fetchStatus,
    this.refreshInterval = const Duration(hours: 6),
  })  : _fetchStatus = fetchStatus,
        super(const SubscriptionState());

  final SubscriptionFetcher _fetchStatus;
  final Duration refreshInterval;

  Timer? _timer;
  Future<bool>? _inFlight;
  DateTime? _lastLoadedAt;

  static const graceFriendlyMessage =
      'Your account is in read-only mode. Please renew your subscription to '
      'make changes.';

  /// Starts the periodic refresh and loads once now.
  Future<void> startSession() {
    _timer?.cancel();
    _timer = Timer.periodic(refreshInterval, (_) => load());
    return load();
  }

  void stopSession() {
    _timer?.cancel();
    _timer = null;
    _inFlight = null;
    _lastLoadedAt = null;
    if (!isClosed) emit(const SubscriptionState());
  }

  /// Fetches `/subscription/status`. Returns true when the app is usable
  /// afterwards (not blocked). Concurrent calls share one request.
  Future<bool> load() {
    final running = _inFlight;
    if (running != null) return running;
    final future = _load().whenComplete(() => _inFlight = null);
    _inFlight = future;
    return future;
  }

  /// Reloads unless the status was read within [maxAge] (app resume).
  Future<bool> refreshIfStale({Duration maxAge = const Duration(minutes: 5)}) {
    final last = _lastLoadedAt;
    if (last != null && DateTime.now().difference(last) < maxAge) {
      return Future<bool>.value(!state.isBlocked);
    }
    return load();
  }

  Future<bool> _load() async {
    _lastLoadedAt = DateTime.now();
    emit(state.copyWith(isLoading: true));
    try {
      final status = await _fetchStatus();
      if (isClosed) return true;
      // A fresh status is the truth: it replaces any earlier 402.
      emit(state.copyWith(
        status: status,
        clearBlock: true,
        isLoading: false,
      ));
    } on SubscriptionFailure catch (failure) {
      if (isClosed) return true;
      emit(state.copyWith(block: failure, isLoading: false));
    } catch (_) {
      // Offline / server trouble: keep what we knew, never lock anyone out
      // because the status could not be read.
      if (!isClosed) emit(state.copyWith(isLoading: false));
    }
    return !state.isBlocked;
  }

  /// A request came back 402.
  void onSubscriptionFailure(SubscriptionFailure failure) {
    if (isClosed) return;
    if (failure.isGraceReadOnly) {
      emit(state.copyWith(
        block: failure,
        graceNoticeSeq: state.graceNoticeSeq + 1,
        graceNotice: graceFriendlyMessage,
      ));
      return;
    }
    emit(state.copyWith(block: failure));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
