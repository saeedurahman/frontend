import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frantend/core/brand/app_brand.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/localization/app_localizations.dart';
import 'package:frantend/core/localization/locale_cubit.dart';
import 'package:frantend/core/router/app_router.dart';
import 'package:frantend/core/security/idle_lock_host.dart';
import 'package:frantend/core/security/idle_lock_service.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/session/session_notice_host.dart';
import 'package:frantend/core/theme/app_theme.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';

class PakApp extends StatelessWidget {
  PakApp({super.key});

  final _router = AppRouter.create();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<NotificationsCubit>()),
        BlocProvider.value(value: sl<BranchSelectorCubit>()),
        BlocProvider.value(value: sl<AccessCubit>()),
        BlocProvider.value(value: sl<SubscriptionCubit>()),
      ],
      child: BlocProvider(
        create: (_) => sl<LocaleCubit>()..load(),
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              title: AppBrand.current.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              locale: locale,
              supportedLocales: LocaleCubit.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routerConfig: _router,
              builder: (context, child) => IdleLockHost(
                service: sl<IdleLockService>(),
                child: SessionNoticeHost(
                  branchSelector: sl<BranchSelectorCubit>(),
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
