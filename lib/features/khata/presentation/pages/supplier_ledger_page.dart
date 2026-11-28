import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_ledger_cubit.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_line.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_wording.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ledger_table.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_actions.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_layout.dart';
import 'package:frantend/features/khata/presentation/widgets/pay_supplier_dialog.dart';
import 'package:frantend/features/khata/presentation/widgets/reverse_payment_dialog.dart';
import 'package:frantend/shared/widgets/dialogs/export_dialog.dart';
import 'package:frantend/shared/widgets/min_width_scroll.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/shared/widgets/sync/not_synced_badge.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// The supplier account: what you owe, every bill and payment, with the
/// running balance, a date filter, export, "Pay supplier" and
/// "Reverse payment".
class SupplierLedgerPage extends StatelessWidget {
  const SupplierLedgerPage({super.key, required this.supplierId});

  final String supplierId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<SupplierLedgerCubit>();
        if (sl.isRegistered<ConnectivityProbe>()) {
          cubit.watchConnectivity(sl<ConnectivityProbe>());
        }
        return cubit..load(supplierId);
      },
      child: BlocListener<BranchSelectorCubit, BranchSelectorState>(
        bloc: sl.isRegistered<BranchSelectorCubit>()
            ? sl<BranchSelectorCubit>()
            : null,
        listenWhen: (a, b) => a.selectedBranchId != b.selectedBranchId,
        listener: (context, _) => context.read<SupplierLedgerCubit>().refresh(),
        child: SupplierLedgerView(supplierId: supplierId),
      ),
    );
  }
}

class SupplierLedgerView extends StatelessWidget {
  const SupplierLedgerView({super.key, required this.supplierId});

  final String supplierId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierLedgerCubit, SupplierLedgerState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        final supplier = state.supplier;
        final lines = state.entries.map(LedgerLine.fromSupplier).toList();
        final canReverse = hasPermission(
          context,
          Perm.suppliersPaymentsReverse,
        );
        final khata = khataRepositoryIfAny();
        final canReverseEntries =
            khata != null && hasPermission(context, Perm.suppliersLedgerManage);
        final account = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(state: state, supplierId: supplierId),
            const SizedBox(height: 12),
            if (state.asOf != null) ...[
              Wrap(
                spacing: AppDimensions.spacing12,
                runSpacing: AppDimensions.spacingXs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AsOfLabel(
                    key: const ValueKey('ledger_as_of'),
                    asOf: state.asOf!,
                  ),
                  const Text(
                    KhataText.offlineAccountNote,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            // No balance to show when the account is not on this device.
            if (!state.offline || state.balance != null) ...[
              _BalanceCard(state: state),
              const SizedBox(height: 12),
            ],
            _DateFilter(state: state),
            if (state.hasDateFilter &&
                (state.openingBalance != null || state.openingNeedsInternet))
              _PeriodBalances(state: state),
            if (state.error != null && !state.offline)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  state.error!,
                  key: const ValueKey('ledger_error'),
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            const SizedBox(height: 8),
            if (state.offline)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  KhataText.offlineLedger,
                  key: ValueKey('ledger_offline'),
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            else
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (state.loadingMore && lines.isEmpty)
                          const LinearProgressIndicator(),
                        MinWidthScroll(
                          minWidth: 900,
                          child: KhataLedgerTable(
                            lines: lines,
                            onReverseEntry: canReverseEntries
                                ? (line) => reverseKhataEntry(
                                    context,
                                    repository: khata,
                                    type: PartyType.supplier,
                                    line: line,
                                    name: supplier?.name ?? '',
                                  )
                                : null,
                            // An empty copy is not an empty account.
                            emptyText: state.olderNeedsInternet
                                ? KhataText.olderNeedInternet
                                : state.hasDateFilter
                                ? KhataText.noEntriesInRange
                                : KhataText.noEntries,
                            reverseTooltip: canReverse
                                ? null
                                : requiresPermissionTooltip([
                                    Perm.suppliersPaymentsReverse,
                                  ]),
                            // Hidden (not just disabled) without the permission.
                            onReverse: canReverse
                                ? (line) =>
                                      _reverse(context, line, supplier?.name)
                                : null,
                          ),
                        ),
                        if (state.hasMore)
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: TextButton(
                              onPressed: state.loadingMore
                                  ? null
                                  : context
                                        .read<SupplierLedgerCubit>()
                                        .loadMore,
                              child: Text(
                                state.loadingMore
                                    ? 'Loading…'
                                    : 'Show older entries',
                              ),
                            ),
                          )
                        else if (state.olderNeedsInternet && lines.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              KhataText.olderNeedInternet,
                              key: ValueKey('ledger_older_offline'),
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
        return PartyKhataLayout(
          type: PartyType.supplier,
          partyId: supplierId,
          name: supplier?.name ?? KhataText.ledgerTitle,
          branchId: context.read<SupplierLedgerCubit>().branchId,
          account: account,
        );
      },
    );
  }

  Future<void> _reverse(
    BuildContext context,
    LedgerLine line,
    String? supplierName,
  ) async {
    final cubit = context.read<SupplierLedgerCubit>();
    final day = line.when == null
        ? ''
        : ' on ${DateFormat('dd MMM').format(line.when!)}';
    final done = await ReversePaymentDialog.show(
      context,
      summary:
          '${formatPKR(line.amount.abs())} paid to ${supplierName ?? 'supplier'}$day',
      onSubmit: (reason) => cubit.reversePayment(line.id, reason),
    );
    if (done && context.mounted) {
      AppAlerts.showSuccessMessage(context, KhataText.reversed);
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state, required this.supplierId});

  final SupplierLedgerState state;
  final String supplierId;

  @override
  Widget build(BuildContext context) {
    final supplier = state.supplier;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppDimensions.spacingMd,
      runSpacing: AppDimensions.spacingSm,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppDimensions.spacingSm,
          children: [
            TextButton.icon(
              onPressed: () => context.canPop()
                  ? context.pop()
                  : context.go(RouteNames.suppliers),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Suppliers'),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplier?.name ?? KhataText.ledgerTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SupplierSyncBadge(supplierId: supplierId, compact: false),
                if (supplier?.phone != null)
                  Text(
                    supplier!.phone!,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ],
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: [
            if (supplier != null)
              PartyKhataActions(
                type: PartyType.supplier,
                partyId: supplierId,
                name: supplier.name,
                phone: supplier.phone,
                branchId: context.read<SupplierLedgerCubit>().branchId,
                balanceOwed: state.owed,
                hasOpening: hasOpeningBalance(
                  state.entries.map(LedgerLine.fromSupplier),
                ),
              ),
            PermissionGate(
              permission: Perm.reportsExport,
              child: OutlinedButton.icon(
                key: const ValueKey('export_supplier_ledger'),
                onPressed: () => ExportDialog.show(
                  context,
                  dataset: 'supplier_ledger',
                  title: 'Supplier Account (${supplier?.name ?? ''})',
                  // Only this supplier, in the branch and dates on screen.
                  filters: {'supplier_id': supplierId},
                  fileLabel: supplier?.name ?? 'supplier',
                  branchId: context.read<SupplierLedgerCubit>().branchId,
                  dateFrom: state.dateFrom,
                  dateTo: state.dateTo,
                ),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text(KhataText.exportLedger),
              ),
            ),
            PermissionGate(
              permission: Perm.suppliersPaymentsCreate,
              mode: GateMode.disable,
              mutating: true,
              builder: (context, enabled) => FilledButton.icon(
                key: const ValueKey('pay_supplier_button'),
                onPressed: enabled
                    ? () async {
                        final paid = await PaySupplierDialog.show(
                          context,
                          supplierId: supplierId,
                          supplierName: supplier?.name,
                          supplierPhone: supplier?.phone,
                        );
                        if (paid && context.mounted) {
                          context.read<SupplierLedgerCubit>().refresh();
                        }
                      }
                    : null,
                icon: const Icon(Icons.payments_outlined, size: 18),
                label: const Text(KhataText.paySupplierTitle),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(0, 44),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.state});

  final SupplierLedgerState state;

  @override
  Widget build(BuildContext context) {
    final owed = state.owed;
    final advance = state.advance;
    final isOwed = owed > Decimal.zero;
    final color = isOwed
        ? AppColors.error
        : (advance > Decimal.zero ? AppColors.info : AppColors.success);
    final label = isOwed
        ? KhataText.youOweNow
        : (advance > Decimal.zero
              ? 'Advance paid to supplier'
              : KhataText.settled);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(
            isOwed
                ? Icons.account_balance_wallet_outlined
                : Icons.check_circle_outline,
            color: color,
            size: 32,
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              Text(
                key: const ValueKey('ledger_balance'),
                formatPKR(isOwed ? owed : advance),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The balance before and after the chosen dates, as the server worked it out.
class _PeriodBalances extends StatelessWidget {
  const _PeriodBalances({required this.state});

  final SupplierLedgerState state;

  @override
  Widget build(BuildContext context) {
    Widget figure(String label, Decimal? value, String key) => Text(
      '$label: ${value == null ? KhataText.needsInternetValue : LedgerWording.balance(value, LedgerParty.supplier).text}',
      key: ValueKey(key),
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
    final closing = state.closingBalance;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 24,
        runSpacing: 4,
        children: [
          figure(
            KhataText.openingBalance,
            state.openingBalance,
            'ledger_opening_balance',
          ),
          if (closing != null)
            figure(KhataText.closingBalance, closing, 'ledger_closing_balance'),
        ],
      ),
    );
  }
}

class _DateFilter extends StatelessWidget {
  const _DateFilter({required this.state});

  final SupplierLedgerState state;

  Future<void> _pick(BuildContext context, {required bool from}) async {
    final now = DateTime.now();
    // "From" can never be after "To": the server refuses that.
    var first = DateTime(now.year - 10);
    var last = now;
    if (from) {
      last = state.dateTo ?? now;
    } else {
      first = state.dateFrom ?? first;
    }
    var initial = (from ? state.dateFrom : state.dateTo) ?? last;
    if (initial.isAfter(last)) initial = last;
    if (initial.isBefore(first)) initial = first;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked == null || !context.mounted) return;
    final cubit = context.read<SupplierLedgerCubit>();
    await cubit.setDates(
      from ? picked : state.dateFrom,
      from ? state.dateTo : picked,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy');
    return Row(
      children: [
        OutlinedButton.icon(
          key: const ValueKey('date_from'),
          onPressed: () => _pick(context, from: true),
          icon: const Icon(Icons.event_outlined, size: 16),
          label: Text(
            state.dateFrom == null ? 'From' : fmt.format(state.dateFrom!),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          key: const ValueKey('date_to'),
          onPressed: () => _pick(context, from: false),
          icon: const Icon(Icons.event_outlined, size: 16),
          label: Text(state.dateTo == null ? 'To' : fmt.format(state.dateTo!)),
        ),
        if (state.hasDateFilter) ...[
          const SizedBox(width: 8),
          TextButton(
            key: const ValueKey('clear_dates'),
            onPressed: context.read<SupplierLedgerCubit>().clearDates,
            child: const Text(KhataText.clearDates),
          ),
        ],
      ],
    );
  }
}
