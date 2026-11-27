import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_format.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

/// One thing that can be done to a party from the list.
class HubRowAction {
  const HubRowAction({
    required this.id,
    required this.label,
    required this.icon,
    required this.permission,
    required this.onRun,
    this.mutating = false,
  });

  /// Stable name used in widget keys.
  final String id;
  final String label;
  final IconData icon;
  final String permission;
  final bool mutating;
  final VoidCallback onRun;
}

/// A party in the khata: who, how much, how old, and what was last done.
///
/// Wide rows always show their actions as quiet icon buttons; narrow rows keep
/// them in a menu.
class KhataHubRowTile extends StatefulWidget {
  const KhataHubRowTile({
    super.key,
    required this.row,
    required this.type,
    required this.narrow,
    required this.actions,
    required this.onOpen,
    this.now,
  });

  final HubRow row;
  final PartyType type;
  final bool narrow;
  final List<HubRowAction> actions;
  final VoidCallback onOpen;
  final DateTime? now;

  @override
  State<KhataHubRowTile> createState() => _KhataHubRowTileState();
}

class _KhataHubRowTileState extends State<KhataHubRowTile> {
  bool _focused = false;

  List<Widget> _chips() {
    final row = widget.row;
    final now = widget.now ?? DateTime.now();
    final promise = row.promiseDate;
    final passed = promise != null &&
        KhataFormat.daysBetween(promise, now) > 0;
    return [
      if (row.oldestOpenDate != null) KhataChip.age(row.oldestAgeDays),
      if (promise != null)
        KhataChip(
          label: passed
              ? KhataUiText.promisePassed(KhataFormat.day(promise, now: now))
              : KhataUiText.promised(KhataFormat.day(promise, now: now)),
          color: passed ? AppColors.error : AppColors.info,
          textColor:
              passed ? const Color(0xFFA11D1D) : const Color(0xFF1F5C94),
          icon: Icons.event_outlined,
          tooltip: row.promiseAmount == null
              ? null
              : formatPKR(row.promiseAmount),
        ),
      if (row.lastReminderAt != null)
        KhataChip(
          label: KhataUiText.remindedAgo(
            KhataFormat.ago(row.lastReminderAt!, now: now),
          ),
          color: AppColors.textSecondary,
          textColor: const Color(0xFF4A5568),
          icon: Icons.notifications_none_outlined,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final row = widget.row;
    final color = KhataStyle.side(widget.type);
    final phone = row.phone;
    final identity = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          row.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (phone != null)
          Text(
            phone,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
    final balance = Tooltip(
      message: widget.type.isCustomer
          ? KhataUiText.toReceiveHint
          : KhataUiText.toPayHint,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Text(
          formatPKR(row.balanceOwed),
          style: KhataStyle.money.copyWith(fontSize: 20, color: color),
        ),
      ),
    );
    final chips = Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingXs,
      children: _chips(),
    );

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (value) => setState(() => _focused = value),
      child: KhataCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMd,
            vertical: AppDimensions.spacing12,
          ),
          borderColor: _focused ? AppColors.primary : null,
          onTap: widget.onOpen,
          child: widget.narrow
              ? Row(
                  children: [
                    InitialsAvatar(row.name, color: color),
                    const SizedBox(width: AppDimensions.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(child: identity),
                              const SizedBox(width: AppDimensions.spacingSm),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 160),
                                child: balance,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spacingSm),
                          chips,
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingXs),
                    _Menu(actions: widget.actions),
                  ],
                )
              : Row(
                  children: [
                    InitialsAvatar(row.name, color: color),
                    const SizedBox(width: AppDimensions.spacing12),
                    Expanded(flex: 3, child: identity),
                    const SizedBox(width: AppDimensions.spacingMd),
                    Expanded(flex: 4, child: chips),
                    const SizedBox(width: AppDimensions.spacingMd),
                    SizedBox(width: 176, child: balance),
                    const SizedBox(width: AppDimensions.spacingMd),
                    Row(
                      key: ValueKey('hub-actions-${row.id}'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final a in widget.actions)
                          _ActionButton(
                            rowId: row.id,
                            action: a,
                            accent: color,
                          ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.rowId,
    required this.action,
    required this.accent,
  });

  final String rowId;
  final HubRowAction action;

  /// The tint under the pointer.
  final Color accent;

  @override
  Widget build(BuildContext context) => PermissionGate(
        permission: action.permission,
        mode: GateMode.disable,
        mutating: action.mutating,
        builder: (context, enabled) => GestureDetector(
          // A click on a button that is off must not open the row behind it.
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? null : () {},
          child: IconButton(
            key: ValueKey('hub-${action.id}-$rowId'),
            // The gate explains why a button is off.
            tooltip: enabled ? action.label : null,
            onPressed: enabled ? action.onRun : null,
            style: IconButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              disabledForegroundColor:
                  AppColors.textSecondary.withValues(alpha: 0.38),
              hoverColor: accent.withValues(alpha: 0.10),
            ),
            icon: Icon(action.icon, size: 20),
          ),
        ),
      );
}

class _Menu extends StatelessWidget {
  const _Menu({required this.actions});

  final List<HubRowAction> actions;

  @override
  Widget build(BuildContext context) {
    final readOnly = isReadOnlyMode(context);
    final reasons = {
      for (final a in actions)
        a.id: !hasPermission(context, a.permission)
            ? requiresPermissionTooltip([a.permission])
            : a.mutating && readOnly
                ? kReadOnlyTooltip
                : null,
    };
    return PopupMenuButton<HubRowAction>(
      tooltip: HubText.moreActions,
      icon: const Icon(Icons.more_vert, size: 20),
      onSelected: (a) => a.onRun(),
      itemBuilder: (_) => [
        for (final a in actions)
          PopupMenuItem<HubRowAction>(
            key: ValueKey('hub-menu-${a.id}'),
            value: a,
            enabled: reasons[a.id] == null,
            child: Tooltip(
              message: reasons[a.id] ?? '',
              child: Row(
                children: [
                  Icon(a.icon, size: 20),
                  const SizedBox(width: AppDimensions.spacing12),
                  Flexible(child: Text(a.label)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
