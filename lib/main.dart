import 'package:flutter/material.dart';
import 'package:frantend/app.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/sync/sync_worker.dart';
import 'package:frantend/core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  await sl<AuthGuard>().checkAuth();
  await sl<SyncWorker>().start();

  AppLogger.info('Frantend POS started');

  runApp(FrantendApp());
}
