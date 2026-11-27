import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/widgets/customer_ledger_header.dart';
import 'package:frantend/features/customers/presentation/widgets/customer_ledger_table.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_layout.dart';
import 'package:frantend/shared/widgets/min_width_scroll.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';
import 'package:frantend/utils/app_alerts.dart';

class CustomerLedgerPage extends StatelessWidget {
  const CustomerLedgerPage({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CustomerLedgerCubit>()..load(customerId),
      child: BlocListener<BranchSelectorCubit, BranchSelectorState>(
        bloc: sl.isRegistered<BranchSelectorCubit>()
            ? sl<BranchSelectorCubit>()
            : null,
        listener: (context, branchState) {
          context
              .read<CustomerLedgerCubit>()
              .onBranchChanged(branchState.selectedBranchId);
        },
        // The account stays usable offline: promises, reminders and notes are
        // saved on this device and sent later.
        child: const OfflineAwareScaffold(
          message: 'The full ledger needs internet. '
              'You can still record payments, promises and notes.',
          child: _CustomerLedgerView(),
        ),
      ),
    );
  }
}

class _CustomerLedgerView extends StatelessWidget {
  const _CustomerLedgerView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerLedgerCubit, CustomerLedgerState>(
      listener: (context, state) {
        if (state is CustomerLedgerError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return switch (state) {
          CustomerLedgerInitial() || CustomerLedgerLoading() =>
            const Center(child: CircularProgressIndicator()),
          CustomerLedgerError(:final message) => Center(
              child: Text(message, style: AppTextStyles.bodyMedium),
            ),
          CustomerLedgerLoaded loaded => PartyKhataLayout(
              type: PartyType.customer,
              partyId: loaded.customer.id,
              name: loaded.customer.name,
              branchId: context.read<CustomerLedgerCubit>().branchId,
              account: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomerLedgerHeader(state: loaded),
                  const SizedBox(height: AppDimensions.spacingMd),
                  Expanded(
                    child: MinWidthScroll(
                      minWidth: 760,
                      child: CustomerLedgerTable(state: loaded),
                    ),
                  ),
                ],
              ),
            ),
        };
      },
    );
  }
}
