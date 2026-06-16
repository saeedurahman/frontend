import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/register/presentation/cubit/register_cubit.dart';

/// Provides a single [RegisterCubit] instance across all registration routes.
class RegisterFlowShell extends StatelessWidget {
  const RegisterFlowShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: child,
    );
  }
}
