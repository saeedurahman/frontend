import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:go_router/go_router.dart';

Future<void> openCustomerForm(BuildContext context, String path) async {
  final saved = await context.push<bool>(path);
  if (saved == true && context.mounted) {
    await context.read<CustomersListCubit>().refresh();
  }
}
