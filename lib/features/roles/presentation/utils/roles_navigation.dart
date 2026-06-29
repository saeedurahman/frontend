import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frantend/features/roles/presentation/cubit/roles_list_cubit.dart';

Future<void> openRoleForm(BuildContext context, String path) async {
  final saved = await context.push<bool>(path);
  if (saved == true && context.mounted) {
    await context.read<RolesListCubit>().refresh();
  }
}
