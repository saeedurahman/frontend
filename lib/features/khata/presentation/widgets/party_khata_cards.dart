import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_format.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/domain/text/party_text.dart';
import 'package:frantend/features/khata/presentation/cubit/party_khata_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/followup_dialogs.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

/// A card heading with an optional figure or button on the right.
class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.icon, required this.title, this.trailing});

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      );
}

const _secondary = TextStyle(fontSize: 12, color: AppColors.textSecondary);

/// The unpaid bills, oldest first, with what is left of each.
class PendingBillsCard extends StatefulWidget {
  const PendingBillsCard({super.key, this.clock = DateTime.now});

  final DateTime Function() clock;

  /// Shown before "Show all".
  static const preview = 6;

  @override
  State<PendingBillsCard> createState() => _PendingBillsCardState();
}

class _PendingBillsCardState extends State<PendingBillsCard> {
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartyKhataCubit, PartyKhataState>(
      builder: (context, state) {
        final data = state.bills;
        final open = data?.value;
        return KhataCard(
          key: const Key('pending-bills-card'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _CardTitle(
                icon: Icons.receipt_long_outlined,
                title: PartyText.billsTitle,
                trailing: open == null || open.items.isEmpty
                    ? null
                    : Text(
                        PartyText.billsCount(open.items.length),
                        style: _secondary,
                      ),
              ),
              if (data != null && data.offline && data.asOf != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.spacingSm),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AsOfLabel(
                      key: const Key('bills-as-of'),
                      asOf: data.asOf!,
                      now: widget.clock(),
                    ),
                  ),
                ),
              const SizedBox(height: AppDimensions.spacing12),
              AnimatedSize(
                duration: KhataStyle.normal,
                curve: KhataStyle.curve,
                alignment: Alignment.topCenter,
                child: _body(context, state, open),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, PartyKhataState state, OpenItems? open) {
    if (open == null) {
      if (state.loadingBills) {
        return const SkeletonRows(
          key: Key('bills-loading'),
          count: 3,
          height: 56,
        );
      }
      return KhataEmptyState(
        key: const Key('bills-error'),
        compact: true,
        icon: Icons.cloud_off_outlined,
        color: AppColors.warning,
        title: PartyText.billsUnavailable,
        message: state.billsError,
        actionLabel: KhataUiText.retry,
        onAction: context.read<PartyKhataCubit>().load,
      );
    }
    if (open.items.isEmpty) {
      return KhataEmptyState(
        key: const Key('bills-empty'),
        compact: true,
        icon: Icons.verified_outlined,
        color: AppColors.success,
        title: PartyText.noBills,
        message: open.advance > Decimal.zero
            ? PartyText.advanceHeld(formatPKR(open.advance))
            : PartyText.noBillsHint,
      );
    }
    final shown = _all
        ? open.items
        : open.items.take(PendingBillsCard.preview).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AgingBar(
          type: context.read<PartyKhataCubit>().partyType,
          buckets: open.buckets,
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        for (var i = 0; i < shown.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          StaggeredEntry(
            index: i,
            child: _BillRow(shown[i], now: widget.clock()),
          ),
        ],
        if (open.items.length > PendingBillsCard.preview)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: const Key('bills-show-all'),
              onPressed: () => setState(() => _all = !_all),
              child: Text(_all ? PartyText.showLess : PartyText.showAll),
            ),
          ),
        if (open.termsDays > 0) ...[
          const SizedBox(height: AppDimensions.spacingXs),
          Text(PartyText.billsTerms(open.termsDays), style: _secondary),
        ],
      ],
    );
  }
}

class _BillRow extends StatelessWidget {
  const _BillRow(this.item, {required this.now});

  final OpenItem item;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final label = PartyText.documentLabel(item.documentType);
    final date = item.date;
    return Padding(
      key: ValueKey('bill-${item.documentId}'),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.number ?? label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Tooltip(
                message: PartyText.remaining,
                child: Text(
                  formatPKR(item.remaining),
                  style: KhataStyle.money.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            [
              if (date != null) KhataFormat.day(date, now: now),
              if (item.number != null) label,
              '${PartyText.total} ${formatPKR(item.total)}',
              '${PartyText.paid} ${formatPKR(item.allocated)}',
            ].join(' · '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _secondary,
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingXs,
            children: [
              KhataChip.age(
                item.ageDays,
                label: KhataFormat.days(item.ageDays),
              ),
              if (item.overdueDays > 0)
                KhataChip(
                  label:
                      PartyText.overdue(KhataFormat.days(item.overdueDays)),
                  color: AppColors.error,
                  textColor: const Color(0xFFA11D1D),
                  icon: Icons.priority_high_rounded,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A chip for a follow-up that is not on the server yet.
Widget? _syncChip(Followup f) {
  if (f.needsAttention) {
    return const KhataChip(
      label: PartyText.refused,
      color: AppColors.error,
      icon: Icons.error_outline,
    );
  }
  if (f.pending) {
    return const KhataChip(
      label: PartyText.waiting,
      color: AppColors.info,
      icon: Icons.cloud_upload_outlined,
    );
  }
  return null;
}

/// A button that needs `khata.followups.create` (works offline).
class _FollowupButton extends StatelessWidget {
  const _FollowupButton({
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final Key buttonKey;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => PermissionGate(
        permission: Perm.khataFollowupsCreate,
        mode: GateMode.disable,
        mutating: true,
        builder: (context, enabled) => TextButton.icon(
          key: buttonKey,
          onPressed: enabled ? onPressed : null,
          icon: Icon(icon, size: 16),
          label: Text(label),
        ),
      );
}

/// What they last said about paying.
class PromiseCard extends StatelessWidget {
  const PromiseCard({super.key, required this.name, this.clock = DateTime.now});

  final String name;
  final DateTime Function() clock;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartyKhataCubit, PartyKhataState>(
      builder: (context, state) {
        final cubit = context.read<PartyKhataCubit>();
        final promise = state.promise;
        final date = promise?.promiseDate;
        final now = clock();
        final daysLate =
            date == null ? 0 : KhataFormat.daysBetween(date, now);
        final sync = promise == null ? null : _syncChip(promise);
        return KhataCard(
          key: const Key('promise-card'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _CardTitle(
                icon: Icons.event_available_outlined,
                title: PartyText.promiseTitle,
                trailing: _FollowupButton(
                  buttonKey: const Key('party-add-promise'),
                  label: PartyText.addPromise,
                  icon: Icons.add,
                  onPressed: () => showPromiseDialog(
                    context,
                    repository: cubit.repository,
                    partyType: cubit.partyType,
                    partyId: cubit.partyId,
                    name: name,
                    branchId: cubit.branchId,
                    clock: clock,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              if (promise == null || date == null)
                const Text(PartyText.noPromise, style: _secondary)
              else ...[
                Text(
                  KhataFormat.fullDay(date),
                  style: KhataStyle.money.copyWith(fontSize: 20),
                ),
                if (promise.promiseAmount != null)
                  Text(
                    PartyText.promiseAmount(formatPKR(promise.promiseAmount!)),
                    style: _secondary,
                  ),
                if (promise.message != null)
                  Text(
                    promise.message!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: _secondary,
                  ),
                if (daysLate >= 0 || sync != null) ...[
                  const SizedBox(height: AppDimensions.spacingSm),
                  Wrap(
                    spacing: AppDimensions.spacingSm,
                    runSpacing: AppDimensions.spacingXs,
                    children: [
                      if (daysLate > 0)
                        const KhataChip(
                          key: Key('promise-passed'),
                          label: PartyText.promiseDatePassed,
                          color: AppColors.error,
                          textColor: Color(0xFFA11D1D),
                          icon: Icons.event_busy_outlined,
                        ),
                      if (daysLate == 0)
                        const KhataChip(
                          label: PartyText.promiseToday,
                          color: AppColors.warning,
                          textColor: Color(0xFF9C4410),
                          icon: Icons.today_outlined,
                        ),
                      if (sync != null) sync,
                    ],
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Every reminder, promise and note, newest first.
class FollowupTimelineCard extends StatefulWidget {
  const FollowupTimelineCard({
    super.key,
    required this.name,
    this.clock = DateTime.now,
  });

  final String name;
  final DateTime Function() clock;

  static const preview = 8;

  @override
  State<FollowupTimelineCard> createState() => _FollowupTimelineCardState();
}

class _FollowupTimelineCardState extends State<FollowupTimelineCard> {
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartyKhataCubit, PartyKhataState>(
      builder: (context, state) {
        final cubit = context.read<PartyKhataCubit>();
        final items = state.followups;
        final shown = _all
            ? items
            : items.take(FollowupTimelineCard.preview).toList();
        return KhataCard(
          key: const Key('timeline-card'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _CardTitle(
                icon: Icons.history_outlined,
                title: PartyText.timelineTitle,
                trailing: _FollowupButton(
                  buttonKey: const Key('party-add-note'),
                  label: PartyText.addNote,
                  icon: Icons.edit_note_outlined,
                  onPressed: () => showNoteDialog(
                    context,
                    repository: cubit.repository,
                    partyType: cubit.partyType,
                    partyId: cubit.partyId,
                    name: widget.name,
                    branchId: cubit.branchId,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              AnimatedSize(
                duration: KhataStyle.normal,
                curve: KhataStyle.curve,
                alignment: Alignment.topCenter,
                child: items.isEmpty
                    ? (state.loadingFollowups
                        ? const SkeletonRows(count: 2, height: 48)
                        : const KhataEmptyState(
                            key: Key('timeline-empty'),
                            compact: true,
                            icon: Icons.forum_outlined,
                            title: PartyText.noFollowups,
                            message: PartyText.noFollowupsHint,
                          ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < shown.length; i++)
                            StaggeredEntry(
                              key: ValueKey('followup-${shown[i].id}'),
                              index: i,
                              child: _TimelineRow(
                                shown[i],
                                now: widget.clock(),
                              ),
                            ),
                          if (items.length > FollowupTimelineCard.preview)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                key: const Key('timeline-show-all'),
                                onPressed: () => setState(() => _all = !_all),
                                child: Text(
                                  _all
                                      ? PartyText.showLess
                                      : PartyText.showAll,
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow(this.followup, {required this.now});

  final Followup followup;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final f = followup;
    final (icon, color) = switch (f.kind) {
      FollowupKind.reminder => (Icons.chat_outlined, AppColors.primary),
      FollowupKind.promise => (
          Icons.event_available_outlined,
          AppColors.warning,
        ),
      FollowupKind.note => (Icons.sticky_note_2_outlined, AppColors.info),
    };
    final sync = _syncChip(f);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PartyText.followupTitle(
                    f.kind,
                    channel: f.channel,
                    day: f.promiseDate == null
                        ? null
                        : KhataFormat.day(f.promiseDate!, now: now),
                    amount: f.promiseAmount == null
                        ? null
                        : formatPKR(f.promiseAmount!),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (f.message != null)
                  Tooltip(
                    message: f.message!,
                    child: Text(
                      f.message!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _secondary,
                    ),
                  ),
                Text(
                  '${KhataFormat.ago(f.createdAt, now: now)} · '
                  '${KhataFormat.time(f.createdAt)}',
                  style: _secondary,
                ),
                if (sync != null) ...[
                  const SizedBox(height: AppDimensions.spacingXs),
                  sync,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
