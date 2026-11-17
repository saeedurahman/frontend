import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layouts_cubit.dart';
import 'package:frantend/features/receipts/presentation/widgets/receipt_ui.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

/// Which layout each kind of receipt uses (printed, WhatsApp, public link),
/// for the whole business, with an optional different choice per branch.
class ReceiptAssignmentsPage extends StatelessWidget {
  const ReceiptAssignmentsPage({
    super.key,
    this.store,
    this.api,
    this.isOnline,
    this.branches,
  });

  final ReceiptLayoutStore? store;
  final ReceiptLayoutApi? api;
  final bool Function()? isOnline;

  /// Branches as `{id, name}`; defaults to the pulled `branch` entities.
  final Future<List<Map<String, String>>> Function()? branches;

  @override
  Widget build(BuildContext context) {
    if (!hasPermission(context, Perm.settingsManage)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Where each layout is used')),
        body: const StateMessage(
          icon: Icons.lock_outline,
          title: "You don't have permission to change receipt layouts.",
        ),
      );
    }
    return BlocProvider(
      create: (_) => ReceiptLayoutsCubit(
        store: store ?? sl<ReceiptLayoutStore>(),
        api: api ?? sl<ReceiptLayoutApi>(),
        isOnline: isOnline ?? () => sl<ConnectivityProbe>().isReachable,
      )..load(),
      child: _AssignmentsView(branches: branches ?? _localBranches),
    );
  }

  static Future<List<Map<String, String>>> _localBranches() async {
    final rows = await sl<SyncStore>().entities('branch');
    return [
      for (final r in rows)
        {'id': '${r['id']}', 'name': '${r['name'] ?? r['id']}'},
    ];
  }
}

class _AssignmentsView extends StatefulWidget {
  const _AssignmentsView({required this.branches});

  final Future<List<Map<String, String>>> Function() branches;

  @override
  State<_AssignmentsView> createState() => _AssignmentsViewState();
}

class _AssignmentsViewState extends State<_AssignmentsView> {
  List<Map<String, String>> _branches = const [];

  @override
  void initState() {
    super.initState();
    widget.branches().then((b) {
      if (mounted) setState(() => _branches = b);
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiptLayoutsCubit, ReceiptLayoutsState>(
      listenWhen: (a, b) => a.error != b.error || a.notice != b.notice,
      listener: (context, state) {
        final text = state.error ?? state.notice;
        if (text != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
          context.read<ReceiptLayoutsCubit>().clearMessages();
        }
      },
      builder: (context, state) {
        final cubit = context.read<ReceiptLayoutsCubit>();
        final active = [for (final l in state.layouts) if (l.isActive) l];
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Where each layout is used')),
          body: state.loading
              ? const _AssignmentsSkeleton()
              : ListView(
                  padding: const EdgeInsets.all(Sp.xl),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!state.online) ...[
                              const OfflineNotice(
                                key: Key('assignments-offline-notice'),
                                message: ReceiptLayoutsCubit.offlineMessage,
                              ),
                              const SizedBox(height: Sp.lg),
                            ],
                            Text(
                              'Pick the layout each kind of receipt uses. '
                              'A branch can use a different layout from the rest of the business.',
                              style: AppTextStyles.bodySmall,
                            ),
                            const SizedBox(height: Sp.lg),
                            if (active.isEmpty)
                              const ReceiptCard(
                                key: Key('assignments-empty'),
                                child: StateMessage(
                                  icon: Icons.receipt_long,
                                  title: 'No layouts yet',
                                  message: 'Make a layout in Receipt Layouts first, then choose where it is used.',
                                ),
                              )
                            else
                              for (final channel in ReceiptChannel.values) ...[
                                _ChannelCard(
                                  channel: channel,
                                  state: state,
                                  layouts: active,
                                  branches: _branches,
                                  enabled: state.online && !state.busy,
                                  onAssign: (id, {branchId}) =>
                                      cubit.assign(channel, id, branchId: branchId),
                                ),
                                const SizedBox(height: Sp.lg),
                              ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _AssignmentsSkeleton extends StatelessWidget {
  const _AssignmentsSkeleton();

  @override
  Widget build(BuildContext context) => ListView(
        key: const Key('assignments-skeleton'),
        padding: const EdgeInsets.all(Sp.xl),
        children: [
          for (var i = 0; i < 3; i++) ...[
            const SkeletonBox(height: 120, radius: AppDimensions.radiusMd),
            const SizedBox(height: Sp.lg),
          ],
        ],
      );
}

class _ChannelCard extends StatefulWidget {
  const _ChannelCard({
    required this.channel,
    required this.state,
    required this.layouts,
    required this.branches,
    required this.enabled,
    required this.onAssign,
  });

  final ReceiptChannel channel;
  final ReceiptLayoutsState state;
  final List<ReceiptLayout> layouts;
  final List<Map<String, String>> branches;
  final bool enabled;
  final void Function(String? id, {String? branchId}) onAssign;

  @override
  State<_ChannelCard> createState() => _ChannelCardState();
}

class _ChannelCardState extends State<_ChannelCard> {
  bool? _open;

  static (IconData, String) _meta(ReceiptChannel c) => switch (c) {
        ReceiptChannel.print => (Icons.print_outlined, 'Used when you print a receipt or save it as a PDF.'),
        ReceiptChannel.whatsapp => (Icons.chat_outlined, 'Used for the text sent on WhatsApp.'),
        ReceiptChannel.link => (Icons.link, 'Used for the receipt page a customer opens from a link.'),
      };

  @override
  Widget build(BuildContext context) {
    final channel = widget.channel;
    final (icon, help) = _meta(channel);
    final overrides = [
      for (final b in widget.branches)
        if (widget.state.overrideFor(channel, b['id']!) != null) b,
    ];
    final open = _open ?? overrides.isNotEmpty;
    return ReceiptCard(
      key: Key('channel-card-${channel.code}'),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(Sp.lg),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: Sp.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(channel.title, style: AppTextStyles.titleMedium),
                      const SizedBox(height: Sp.xs),
                      Text(help, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.all(Sp.lg),
            child: _Row(
              label: 'Whole business',
              hint: 'Used everywhere unless a branch has its own.',
              picker: _Picker(
                key: Key('assign-${channel.code}'),
                value: widget.state.defaultFor(channel)?.id,
                layouts: widget.layouts,
                allowNone: false,
                enabled: widget.enabled,
                onChanged: (id) => widget.onAssign(id),
              ),
            ),
          ),
          if (widget.branches.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.border),
            InkWell(
              key: Key('override-toggle-${channel.code}'),
              onTap: () => setState(() => _open = !open),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sp.lg, vertical: Sp.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Override per branch'
                        '${overrides.isEmpty ? '' : '  ·  ${overrides.length} changed'}',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Icon(open ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            if (open)
              Padding(
                key: Key('override-list-${channel.code}'),
                padding: const EdgeInsets.fromLTRB(Sp.lg, 0, Sp.lg, Sp.lg),
                child: Column(
                  children: [
                    for (final b in widget.branches) ...[
                      _Row(
                        label: b['name']!,
                        hint: null,
                        picker: _Picker(
                          key: Key('assign-${channel.code}-${b['id']}'),
                          value: widget.state.overrideFor(channel, b['id']!)?.id,
                          layouts: widget.layouts,
                          allowNone: true,
                          enabled: widget.enabled,
                          onChanged: (id) => widget.onAssign(id, branchId: b['id']),
                        ),
                      ),
                      if (b != widget.branches.last) const SizedBox(height: Sp.md),
                    ],
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Label on the left, dropdown on the right; stacked on a narrow card.
class _Row extends StatelessWidget {
  const _Row({required this.label, required this.hint, required this.picker});

  final String label;
  final String? hint;
  final Widget picker;

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        if (hint != null) ...[
          const SizedBox(height: Sp.xs),
          Text(hint!, style: AppTextStyles.bodySmall),
        ],
      ],
    );
    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth < 480) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [text, const SizedBox(height: Sp.sm), picker],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: text),
            const SizedBox(width: Sp.lg),
            Expanded(flex: 3, child: picker),
          ],
        );
      },
    );
  }
}

class _Picker extends StatelessWidget {
  const _Picker({
    super.key,
    required this.value,
    required this.layouts,
    required this.allowNone,
    required this.enabled,
    required this.onChanged,
  });

  final String? value;
  final List<ReceiptLayout> layouts;
  final bool allowNone;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final known = layouts.any((l) => l.id == value);
    return DropdownButtonFormField<String?>(
      initialValue: known ? value : null,
      isExpanded: true,
      decoration: const InputDecoration(isDense: true),
      items: [
        if (allowNone || !known)
          DropdownMenuItem<String?>(
            value: null,
            child: Text(allowNone ? 'Same as the business' : 'Choose a layout'),
          ),
        for (final l in layouts)
          DropdownMenuItem<String?>(
            value: l.id,
            child: Text(l.name, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: enabled
          ? (id) {
              if (id == value) return;
              if (id == null && !allowNone) return;
              onChanged(id);
            }
          : null,
    );
  }
}
