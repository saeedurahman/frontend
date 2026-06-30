import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:frantend/features/auth/presentation/cubit/auth_state.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:frantend/features/auth/presentation/pages/desktop_login_widget.dart';
import 'package:frantend/features/auth/presentation/pages/mobile_login_widget.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:frantend/utils/responsive/responsive.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (_) async {
              sl<NotificationsCubit>().startSession();
              sl<BranchSelectorCubit>().startSession();
              await sl<AuthGuard>().refreshSessionContext();
              if (context.mounted) {
                context.go(sl<AuthGuard>().homeRoute);
              }
            },
            error: (message) => AppAlerts.showErrorMessage(context, message),
            orElse: () {},
          );
        },
        builder: (context, state) {
          if (context.isMobile) {
            return const MobileLoginWidget();
          }
          return const DesktopLoginWidget();
        },
      ),
    );
  }
}
