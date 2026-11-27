import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/widgets/record_payment_dialog.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/presentation/widgets/pay_supplier_dialog.dart';

/// Taking money from a customer or paying a supplier from outside their own
/// page (the hub). Uses the same dialogs as the account pages.
Future<void> showKhataPayment(
  BuildContext context, {
  required PartyType type,
  required String id,
  required String name,
  String? phone,
  String? branchId,
}) async {
  if (!type.isCustomer) {
    await PaySupplierDialog.show(
      context,
      supplierId: id,
      supplierName: name,
      supplierPhone: phone,
    );
    return;
  }
  await showDialog<bool>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) =>
          sl<CustomerLedgerCubit>()..load(id, branchId: branchId),
      child: const _CustomerPayment(),
    ),
  );
}

/// Opens the account first, then shows the customer payment window over it.
class _CustomerPayment extends StatefulWidget {
  const _CustomerPayment();

  @override
  State<_CustomerPayment> createState() => _CustomerPaymentState();
}

class _CustomerPaymentState extends State<_CustomerPayment> {
  /// The first loaded account: the payment window stays while it re-reads.
  CustomerLedgerLoaded? _account;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerLedgerCubit, CustomerLedgerState>(
      builder: (context, state) {
        if (state is CustomerLedgerLoaded) _account = state;
        final account = _account;
        if (account != null) {
          return RecordPaymentDialog(
            customerName: account.customer.name,
            currentBalance: account.balance,
          );
        }
        final failed = state is CustomerLedgerError ? state.message : null;
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (failed == null)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                const Icon(Icons.error_outline),
              const SizedBox(width: AppDimensions.spacingMd),
              Flexible(
                child: Text(
                  failed == null
                      ? HubText.openingAccount
                      : '${HubText.paymentNeedsAccount}\n$failed',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(KhataUiText.close),
            ),
          ],
        );
      },
    );
  }
}
