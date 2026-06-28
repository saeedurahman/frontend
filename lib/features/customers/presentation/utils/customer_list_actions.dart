import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';

Future<void> confirmDeactivateCustomer(
  BuildContext context,
  CustomerListRow row,
) async {
  final owed = CustomerBalanceUtils.amountOwed(row.balance);
  final message = owed > Decimal.zero
      ? 'This customer owes ${DecimalUtils.format(owed)}. Deactivating will not clear the balance.\n\nThe customer will be marked inactive.'
      : 'The customer will be marked inactive.';

  final ok = await ConfirmDialog.show(
    context,
    title: 'Deactivate ${row.customer.name}?',
    message: message,
  );
  if (ok == true && context.mounted) {
    final success = await context
        .read<CustomersListCubit>()
        .deactivateCustomer(row.customer.id);
    if (success && context.mounted) {
      AppAlerts.showSuccessMessage(context, 'Customer deactivated');
    }
  }
}
