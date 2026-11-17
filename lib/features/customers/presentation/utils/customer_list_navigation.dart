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

/// The customer's screen can take a payment or change the balance, so the list
/// is read again when it comes back.
Future<void> openCustomerDetail(BuildContext context, String path) async {
  final cubit = context.read<CustomersListCubit>();
  await context.push<Object?>(path);
  if (!cubit.isClosed) await cubit.refresh();
}
