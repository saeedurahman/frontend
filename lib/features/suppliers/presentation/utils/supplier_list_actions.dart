import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';

Future<void> confirmDeleteSupplier(
  BuildContext context,
  SupplierListRow row,
) async {
  final ok = await ConfirmDialog.show(
    context,
    title: 'Delete ${row.supplier.name}?',
    message: 'This action cannot be undone.',
  );
  if (ok == true && context.mounted) {
    final success = await context
        .read<SuppliersListCubit>()
        .deleteSupplier(row.supplier.id);
    if (success && context.mounted) {
      AppAlerts.showSuccessMessage(context, 'Supplier deleted');
    }
  }
}
