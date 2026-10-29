import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frantend/app.dart';
import 'package:frantend/core/brand/app_brand.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/network/insecure_http_overrides.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/security/idle_lock_service.dart';
import 'package:frantend/core/security/startup_guard.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/platform/app_window_service.dart';
import 'package:frantend/core/utils/crash_log.dart';
import 'package:frantend/core/utils/logger.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:frantend/features/restaurant/domain/usecases/load_business_session_usecase.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureDiagnostics();
  configureHttpOverrides();

  // Show a window immediately; startup work runs behind it so a slow or
  // failing step is visible instead of leaving the app with no window.
  runApp(const _Bootstrap());
}

/// Routes console output through the redactor and persists uncaught errors.
void _configureDiagnostics() {
  final original = debugPrint;
  debugPrint = (String? message, {int? wrapWidth}) {
    // Nothing is printed in release builds; elsewhere tokens/PINs are masked.
    if (kReleaseMode || message == null) return;
    original(AppLogger.redact(message), wrapWidth: wrapWidth);
  };

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    CrashLog.write('flutter', details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    CrashLog.write('platform', error, stack);
    return true;
  };
}

/// Where the last startup failure was written (shown in release builds).
String? _crashLogPath;

/// Last startup step that began, shown on screen while the app is loading.
final ValueNotifier<String> _startupStep = ValueNotifier('Starting...');

Future<void> _startup() async {
  Future<void> step(String name, Future<void> Function() body) async {
    _startupStep.value = name;
    debugPrint('[startup] $name');
    await body();
  }

  await step(
    'Checking configuration',
    () async => StartupGuard.validate(
      isRelease: kReleaseMode,
      apiBaseUrl: ApiConstants.baseUrl,
      allowInsecureSsl: InsecureHttpOverrides.insecureFlag,
    ),
  );
  await step('Configuring dependencies', configureDependencies);
  await step('Checking auth', () => sl<AuthGuard>().checkAuth());
  if (sl<AuthGuard>().isAuthenticated) {
    // Cold-start permission refresh: updates cached permission_keys from GET
    // /auth/me when online. Does not cover mid-session admin changes while the
    // app stays open — those apply on next login or cold start.
    // Best-effort: an unreachable backend must not block startup (offline POS).
    await step('Loading current user', () async {
      try {
        await sl<AuthRepository>().getCurrentUser().timeout(
          const Duration(seconds: 8),
        );
      } catch (e) {
        debugPrint('[startup] current user refresh skipped: $e');
      }
    });
    await step('Loading business session', () async {
      try {
        await sl<LoadBusinessSessionUseCase>()().timeout(
          const Duration(seconds: 8),
        );
      } catch (e) {
        debugPrint('[startup] business session refresh skipped: $e');
      }
    });
    await step(
      'Refreshing session context',
      () => sl<AuthGuard>().refreshSessionContext(),
    );
    // Both were already started when the session was detected; these calls
    // join the in-flight requests so the first screen is routed correctly
    // (blocked subscription / missing permission) instead of flashing.
    await step('Checking subscription', () async {
      try {
        await sl<SubscriptionCubit>().load().timeout(const Duration(seconds: 8));
        await sl<AccessCubit>().refresh(force: true).timeout(
          const Duration(seconds: 8),
        );
      } catch (e) {
        debugPrint('[startup] subscription/access check skipped: $e');
      }
    });
    await step(
      'Starting notifications',
      () => sl<NotificationsCubit>().startSession(),
    );
    await step(
      'Starting branch selector',
      () => sl<BranchSelectorCubit>().startSession(),
    );
  }
  await step('Starting reachability probe', () async {
    sl<ConnectivityProbe>().start();
    await sl<AppWindowService>().setTitle();
  });
  await step('Starting idle lock', () async => sl<IdleLockService>().start());

  AppLogger.info('${AppBrand.current.appName} started');
}

class _Bootstrap extends StatefulWidget {
  const _Bootstrap();

  @override
  State<_Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<_Bootstrap> {
  late final Future<void> _ready = _guardedStartup();

  Future<void> _guardedStartup() async {
    try {
      await _startup();
    } catch (e, st) {
      final file = await CrashLog.write('startup:${_startupStep.value}', e, st);
      _crashLogPath = file?.path;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _ready,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return PakApp();
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: snapshot.hasError
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: _StartupError(
                        error: snapshot.error!,
                        stackTrace: snapshot.stackTrace,
                        step: _startupStep.value,
                        logPath: _crashLogPath,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        ValueListenableBuilder<String>(
                          valueListenable: _startupStep,
                          builder: (_, step, __) => Text(step),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

/// Release builds show a friendly message; debug builds keep full details.
class _StartupError extends StatelessWidget {
  const _StartupError({
    required this.error,
    required this.stackTrace,
    required this.step,
    required this.logPath,
  });

  final Object error;
  final StackTrace? stackTrace;
  final String step;
  final String? logPath;

  @override
  Widget build(BuildContext context) {
    final error = this.error;
    if (error is StartupConfigError) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SelectableText('Cannot start the app\n\n${error.message}'),
      );
    }
    if (kReleaseMode) {
      final where = logPath == null ? '.' : ' and share this file:\n$logPath';
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SelectableText(
          'Something went wrong while starting the app.\n\n'
          'Please close and reopen it. If the problem continues, contact '
          'support$where',
        ),
      );
    }
    return SelectableText(
      'Startup failed at "$step":\n\n$error\n\n$stackTrace',
    );
  }
}
