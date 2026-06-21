import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/localization/app_localizations.dart';
import 'package:frantend/core/localization/locale_cubit.dart';
import 'package:frantend/core/router/app_router.dart';
import 'package:frantend/core/theme/app_theme.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';

class FrantendApp extends StatelessWidget {
  FrantendApp({super.key});

  final _router = AppRouter.create();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<NotificationsCubit>()),
        BlocProvider.value(value: sl<BranchSelectorCubit>()),
      ],
      child: BlocProvider(
        create: (_) => sl<LocaleCubit>()..load(),
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              title: 'Frantend POS',
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
            );
          },
        ),
      ),
    );
  }
}
