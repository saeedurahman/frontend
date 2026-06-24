import 'package:flutter/material.dart';
import 'package:frantend/app.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/network/insecure_http_overrides.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/sync/sync_worker.dart';
import 'package:frantend/core/utils/logger.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureHttpOverrides();

  await configureDependencies();
  await sl<AuthGuard>().checkAuth();
  if (sl<AuthGuard>().isAuthenticated) {
    await sl<NotificationsCubit>().startSession();
    await sl<BranchSelectorCubit>().startSession();
  }
  await sl<SyncWorker>().start();

  AppLogger.info('Frantend POS started');

  runApp(FrantendApp());
}
