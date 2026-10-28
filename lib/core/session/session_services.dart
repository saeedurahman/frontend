import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/session/session_signals.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:frantend/features/subscription/data/subscription_repository.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';

/// Hand-registered session services: live permissions ([AccessCubit]) and the
/// subscription gate ([SubscriptionCubit]), plus the glue between them, the
/// HTTP layer and the router guard. Kept out of the generated DI file.
abstract final class SessionServices {
  static bool _wired = false;
  static bool _wasAuthenticated = false;

  /// Registers the cubits (idempotent).
  static void register() {
    if (!sl.isRegistered<SubscriptionRepository>()) {
      sl.registerLazySingleton<SubscriptionRepository>(
        () => SubscriptionRepository(sl<Dio>()),
      );
    }
    if (!sl.isRegistered<SubscriptionCubit>()) {
      sl.registerLazySingleton<SubscriptionCubit>(
        () => SubscriptionCubit(
          fetchStatus: () => sl<SubscriptionRepository>().fetchStatus(),
        ),
      );
    }
    if (!sl.isRegistered<AccessCubit>()) {
      sl.registerLazySingleton<AccessCubit>(
        () => AccessCubit(
          fetchCurrentUser: () async => (await sl<AuthRepository>()
                  .getCurrentUser())
              .fold((_) => null, (user) => user),
          loadCachedUser: () async =>
              (await sl<AuthLocalDataSource>().getCachedUser())?.toEntity(),
        ),
      );
    }
  }

  /// Connects 402/403 signals, the router guard and the app lifecycle.
  static void wire() {
    if (_wired) return;
    _wired = true;

    final guard = sl<AuthGuard>();
    final access = sl<AccessCubit>();
    final subscription = sl<SubscriptionCubit>();
    final branches = sl<BranchSelectorCubit>();

    SessionSignals.onSubscriptionFailure = subscription.onSubscriptionFailure;
    SessionSignals.onForbiddenRequest = (request) {
      access.onForbidden();
      branches.handleForbiddenBranch(_branchIdOf(request));
    };

    branches.scopeProvider = () => (
          access: access.state.access,
          branchIds: access.state.branchIds,
        );

    subscription.stream.listen(
      (state) => guard.setSubscriptionBlocked(state.isBlocked),
    );

    AccessState previous = access.state;
    access.stream.listen((state) {
      final user = state.user;
      if (user != null) guard.updateUser(UserModel.fromEntity(user));
      final scopeChanged = !listEquals(
            previous.user?.permissionKeys,
            user?.permissionKeys,
          ) ||
          !listEquals(previous.branchIds, state.branchIds);
      previous = state;
      if (scopeChanged && user != null && guard.isAuthenticated) {
        unawaited(branches.startSession());
      }
    });

    _wasAuthenticated = guard.isAuthenticated;
    guard.addListener(() {
      final authenticated = guard.isAuthenticated;
      if (authenticated == _wasAuthenticated) return;
      _wasAuthenticated = authenticated;
      if (authenticated) {
        unawaited(access.startSession());
        unawaited(subscription.startSession());
      } else {
        access.stopSession();
        subscription.stopSession();
      }
    });

    WidgetsBinding.instance.addObserver(
      _ResumeObserver(() {
        if (!guard.isAuthenticated) return;
        access.onResumed();
        unawaited(subscription.refreshIfStale());
      }),
    );
  }

  /// `branch_id` of the refused request, from the query or the JSON body.
  static String? _branchIdOf(RequestOptions request) {
    final fromQuery = request.queryParameters['branch_id'];
    if (fromQuery is String) return fromQuery;
    final data = request.data;
    if (data is Map && data['branch_id'] is String) {
      return data['branch_id'] as String;
    }
    return null;
  }

  /// Signs out everywhere (shell menu, subscription page).
  static Future<void> logout() async {
    sl<NotificationsCubit>().stopSession();
    sl<BranchSelectorCubit>().stopSession();
    await sl<AuthRepository>().logout();
    sl<AuthGuard>().setAuthenticated(false);
  }
}

class _ResumeObserver with WidgetsBindingObserver {
  _ResumeObserver(this._onResume);

  final VoidCallback _onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _onResume();
  }
}
