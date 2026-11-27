import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/session/active_branch_resolver.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/domain/manual_entry.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/retry_key.dart';
import 'package:frantend/features/khata/domain/text/entry_text.dart';
import 'package:frantend/features/khata/domain/text/party_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_message_cubit.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_line.dart';
import 'package:frantend/features/khata/presentation/widgets/entry_dialogs.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_message_dialog.dart';
import 'package:frantend/features/khata/presentation/widgets/reverse_payment_dialog.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

KhataRepository? khataRepositoryIfAny() =>
    sl.isRegistered<KhataRepository>() ? sl<KhataRepository>() : null;

/// Whether the loaded lines already hold a live opening balance.
bool hasOpeningBalance(Iterable<LedgerLine> lines) => lines.any(
      (l) =>
          (l.source == 'opening' || l.type == 'opening_balance') &&
          !l.isReversed &&
          !l.isReversal,
    );

/// "Statement" among a list row's actions. Empty where the khata is not set up
/// or may not be seen; brings its own gap.
class StatementRowButton extends StatelessWidget {
  const StatementRowButton({
    super.key,
    required this.type,
    required this.partyId,
  });

  final PartyType type;
  final String partyId;

  @override
  Widget build(BuildContext context) {
    if (khataRepositoryIfAny() == null ||
        !hasPermission(context, Perm.khataView)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: AppTableActionButton(
        key: ValueKey('statement-row-action-$partyId'),
        icon: Icons.summarize_outlined,
        tooltip: PartyText.statement,
        onPressed: () => context.push(type.statementRoute(partyId)),
      ),
    );
  }
}

/// "Remind on WhatsApp", "Statement" and "Add entry" on a party's page.
/// Empty where the khata is not set up.
class PartyKhataActions extends StatelessWidget {
  const PartyKhataActions({
    super.key,
    required this.type,
    required this.partyId,
    required this.name,
    this.phone,
    this.branchId,
    this.balanceOwed,
    this.hasOpening = false,
    this.repository,
  });

  final PartyType type;
  final String partyId;
  final String name;
  final String? phone;
  final String? branchId;
  final Decimal? balanceOwed;
  final bool hasOpening;
  final KhataRepository? repository;

  @override
  Widget build(BuildContext context) {
    final repo = repository ?? khataRepositoryIfAny();
    if (repo == null) return const SizedBox.shrink();
    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        PermissionGate(
          permission: Perm.khataView,
          child: PermissionGate(
            permission: Perm.khataFollowupsCreate,
            mode: GateMode.disable,
            builder: (context, enabled) => Tooltip(
              message: enabled ? PartyText.remindHint : '',
              child: OutlinedButton.icon(
                key: const Key('party-remind'),
                onPressed: enabled
                    ? () => showKhataMessageDialog(
                          context,
                          MessageRequest(
                            partyType: type,
                            partyId: partyId,
                            name: name,
                            phone: phone,
                            branchId: branchId,
                            knownDue: balanceOwed,
                          ),
                          repository: repo,
                        )
                    : null,
                icon: const Icon(Icons.chat_outlined, size: 18),
                label: const Text(PartyText.remind),
              ),
            ),
          ),
        ),
        PermissionGate(
          permission: Perm.khataView,
          child: Tooltip(
            message: PartyText.statementHint,
            child: OutlinedButton.icon(
              key: const Key('party-statement'),
              onPressed: () => context.push(type.statementRoute(partyId)),
              icon: const Icon(Icons.receipt_long_outlined, size: 18),
              label: const Text(PartyText.statement),
            ),
          ),
        ),
        _EntryMenu(
          type: type,
          partyId: partyId,
          name: name,
          branchId: branchId,
          hasOpening: hasOpening,
          repository: repo,
        ),
      ],
    );
  }
}

enum _Entry { opening, newDebt, adjustment }

class _EntryMenu extends StatelessWidget {
  const _EntryMenu({
    required this.type,
    required this.partyId,
    required this.name,
    required this.branchId,
    required this.hasOpening,
    required this.repository,
  });

  final PartyType type;
  final String partyId;
  final String name;
  final String? branchId;
  final bool hasOpening;
  final KhataRepository repository;

  Future<void> _open(BuildContext context, _Entry entry) async {
    // Like payments, an entry belongs to a branch whenever one is known.
    final branch = branchId ??
        (sl.isRegistered<ActiveBranchResolver>()
            ? await sl<ActiveBranchResolver>().resolve()
            : null);
    if (!context.mounted) return;
    if (entry == _Entry.opening) {
      await showOpeningBalanceDialog(
        context,
        repository: repository,
        partyType: type,
        partyId: partyId,
        name: name,
        branchId: branch,
      );
      return;
    }
    await showManualEntryDialog(
      context,
      repository: repository,
      partyType: type,
      partyId: partyId,
      name: name,
      kind: entry == _Entry.newDebt
          ? ManualKind.newDebtFor(type)
          : ManualKind.adjustmentIncrease,
      branchId: branch,
    );
  }

  @override
  Widget build(BuildContext context) {
    return OfflineAwareBuilder(
      builder: (context, offline) => PermissionGate(
        permission: type.ledgerManagePermission,
        mode: GateMode.disable,
        mutating: true,
        builder: (context, allowed) {
          final enabled = allowed && !offline;
          Widget menu = PopupMenuButton<_Entry>(
            key: const Key('party-entry-menu'),
            enabled: enabled,
            // The wrapping tooltip explains a disabled button.
            tooltip: enabled ? EntryText.manualMenuTooltip : '',
            position: PopupMenuPosition.under,
            onSelected: (entry) => _open(context, entry),
            itemBuilder: (_) => [
              if (!hasOpening)
                const PopupMenuItem(
                  key: Key('entry-opening'),
                  value: _Entry.opening,
                  child: Text(EntryText.addOpening),
                ),
              PopupMenuItem(
                key: const Key('entry-new-debt'),
                value: _Entry.newDebt,
                child: Text(EntryText.title(ManualKind.newDebtFor(type))),
              ),
              const PopupMenuItem(
                key: Key('entry-adjustment'),
                value: _Entry.adjustment,
                child: Text(EntryText.adjustment),
              ),
            ],
            child: _MenuFace(enabled: enabled),
          );
          if (allowed && offline) {
            menu = Tooltip(message: EntryText.offline, child: menu);
          }
          return menu;
        },
      ),
    );
  }
}

/// An outlined-button look for the menu.
class _MenuFace extends StatelessWidget {
  const _MenuFace({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled
        ? AppColors.primary
        : Theme.of(context).disabledColor;
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.spacingLg),
        border: Border.all(
          color: enabled ? AppColors.border : color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 18, color: color),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            EntryText.manualMenu,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Icon(Icons.arrow_drop_down, size: 18, color: color),
        ],
      ),
    );
  }
}

/// Undoes an opening balance or manual entry, asking why.
Future<void> reverseKhataEntry(
  BuildContext context, {
  required KhataRepository repository,
  required PartyType type,
  required LedgerLine line,
  required String name,
}) async {
  final key = RetryKey();
  final done = await ReversePaymentDialog.show(
    context,
    title: EntryText.reverseEntry,
    explain: EntryText.reverseEntryExplain,
    keepLabel: EntryText.keepEntry,
    confirmLabel: EntryText.reverseEntry,
    summary: '${line.typeLabel} · ${formatPKR(line.amount.abs())} · $name',
    onSubmit: (reason) async {
      final result = await repository.reverseEntry(
        type,
        line.id,
        reason: reason,
        idempotencyKey: key.keyFor([line.id, reason]),
      );
      key.settle(result.fold((f) => f, (_) => null));
      return result.fold(
        (f) => f is NetworkFailure
            ? EntryText.offline
            : EntryText.forCode(f.code) ?? f.message,
        (_) => null,
      );
    },
  );
  if (done && context.mounted) {
    AppAlerts.showSuccessMessage(context, EntryText.entryReversed);
  }
}
