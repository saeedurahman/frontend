import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_switches.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layouts_cubit.dart';
import 'package:frantend/features/receipts/presentation/widgets/layout_preview.dart';
import 'package:frantend/features/receipts/presentation/widgets/receipt_ui.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:go_router/go_router.dart';

/// Settings > Receipt Layouts: every layout with a small picture, where it is
/// used, and create / duplicate / rename / delete.
class ReceiptLayoutsPage extends StatelessWidget {
  const ReceiptLayoutsPage({super.key, this.store, this.api, this.isOnline});

  final ReceiptLayoutStore? store;
  final ReceiptLayoutApi? api;
  final bool Function()? isOnline;

  @override
  Widget build(BuildContext context) {
    if (!hasPermission(context, Perm.settingsManage)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Receipt Layouts')),
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
      child: const _ListView(),
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView();

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
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Receipt Layouts'),
            leading: BackButton(
              onPressed: () => context.canPop() ? context.pop() : context.go(RouteNames.settings),
            ),
            actions: [
              Tooltip(
                message: 'Choose which layout prints, goes on WhatsApp or opens from a link',
                child: MediaQuery.sizeOf(context).width < 700
                    ? IconButton(
                        key: const Key('open-assignments'),
                        onPressed: () => context.push(RouteNames.settingsReceiptAssignments),
                        icon: const Icon(Icons.rule),
                      )
                    : TextButton.icon(
                        key: const Key('open-assignments'),
                        onPressed: () => context.push(RouteNames.settingsReceiptAssignments),
                        icon: const Icon(Icons.rule),
                        label: const Text('Where each layout is used'),
                      ),
              ),
              const SizedBox(width: Sp.sm),
              Padding(
                padding: const EdgeInsets.only(right: Sp.lg),
                child: FilledButton.icon(
                  key: const Key('new-layout'),
                  onPressed: state.busy ? null : () => _create(context, cubit),
                  icon: const Icon(Icons.add),
                  label: Text(MediaQuery.sizeOf(context).width < 700 ? 'New' : 'New layout'),
                ),
              ),
            ],
          ),
          body: state.loading
              ? const _GridSkeleton()
              : ListView(
                  padding: const EdgeInsets.all(Sp.xl),
                  children: [
                    if (!state.online) ...[
                      const OfflineNotice(
                        key: Key('layouts-offline-notice'),
                        message: ReceiptLayoutsCubit.offlineMessage,
                      ),
                      const SizedBox(height: Sp.lg),
                    ],
                    if (state.layouts.isEmpty)
                      ReceiptCard(
                        key: const Key('layouts-empty'),
                        child: StateMessage(
                          icon: Icons.receipt_long,
                          title: 'Your receipts use the built-in classic design',
                          message: 'Your own layouts appear here once this device has synced. '
                              'You can then make a copy of any design and change it.',
                          action: FilledButton.icon(
                            onPressed: state.busy ? null : () => _create(context, cubit),
                            icon: const Icon(Icons.add),
                            label: const Text('New layout'),
                          ),
                        ),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, c) {
                          final cols = c.maxWidth >= 1000 ? 3 : (c.maxWidth >= 620 ? 2 : 1);
                          final w = (c.maxWidth - Sp.lg * (cols - 1)) / cols;
                          return Wrap(
                            spacing: Sp.lg,
                            runSpacing: Sp.lg,
                            children: [
                              for (final l in state.layouts)
                                SizedBox(
                                  width: w,
                                  child: _LayoutCard(
                                    layout: l,
                                    usedBy: state.usedBy(l.id),
                                    canDelete: state.layouts.length > 1,
                                    busy: state.busy,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
        );
      },
    );
  }

  Future<void> _create(BuildContext context, ReceiptLayoutsCubit cubit) async {
    final made = await showDialog<_NewLayout>(
      context: context,
      builder: (_) => const _NewLayoutDialog(),
    );
    if (made == null) return;
    final layout = await cubit.create(
      design: made.design,
      name: made.name,
      paper: made.design.defaultPaper,
      config: made.preset?.build(),
    );
    if (layout != null && context.mounted) {
      context.push(RouteNames.settingsReceiptLayoutPath(layout.id));
    }
  }
}

/// Placeholder cards shown while the layouts load.
class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        key: const Key('layouts-skeleton'),
        builder: (context, c) {
          final cols = c.maxWidth >= 1000 ? 3 : (c.maxWidth >= 620 ? 2 : 1);
          final w = (c.maxWidth - 2 * Sp.xl - Sp.lg * (cols - 1)) / cols;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Sp.xl),
            child: Wrap(
              spacing: Sp.lg,
              runSpacing: Sp.lg,
              children: [
                for (var i = 0; i < cols * 2; i++)
                  ReceiptCard(
                    child: SizedBox(
                      width: w - 2 * Sp.lg,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBox(height: 160, radius: AppDimensions.radiusMd),
                          SizedBox(height: Sp.md),
                          SkeletonBox(width: 140, height: 18),
                          SizedBox(height: Sp.sm),
                          SkeletonBox(width: 90, height: 14),
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

class _LayoutCard extends StatelessWidget {
  const _LayoutCard({
    required this.layout,
    required this.usedBy,
    required this.canDelete,
    required this.busy,
  });

  final ReceiptLayout layout;
  final List<ReceiptChannel> usedBy;
  final bool canDelete;
  final bool busy;

  static String _defaultText(ReceiptChannel c) => switch (c) {
        ReceiptChannel.print => 'Default for print',
        ReceiptChannel.whatsapp => 'Default for WhatsApp',
        ReceiptChannel.link => 'Default for link',
      };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptLayoutsCubit>();
    return ReceiptCard(
      key: Key('layout-${layout.id}'),
      padding: EdgeInsets.zero,
      onTap: () => context.push(RouteNames.settingsReceiptLayoutPath(layout.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            key: Key('layout-thumb-${layout.id}'),
            height: 196,
            color: const Color(0xFFEDF1F6),
            padding: const EdgeInsets.only(top: Sp.lg),
            alignment: Alignment.topCenter,
            child: LayoutThumbnail(layout: layout, width: 150, height: 180),
          ),
          Padding(
            padding: const EdgeInsets.all(Sp.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        layout.name,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      key: Key('layout-menu-${layout.id}'),
                      tooltip: 'More actions',
                      enabled: !busy,
                      onSelected: (v) => _menu(context, cubit, v),
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                        const PopupMenuItem(value: 'rename', child: Text('Rename')),
                        PopupMenuItem(
                          value: 'delete',
                          enabled: canDelete,
                          child: Text(canDelete ? 'Delete' : 'Delete (keep at least one)'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: Sp.xs),
                Text(layout.design.title, style: AppTextStyles.bodySmall),
                const SizedBox(height: Sp.md),
                Wrap(
                  spacing: Sp.sm,
                  runSpacing: Sp.sm,
                  children: [
                    InfoBadge(
                      layout.paper.title,
                      key: Key('paper-badge-${layout.id}'),
                      icon: Icons.description_outlined,
                    ),
                    InfoBadge(
                      layout.config.language.badge,
                      key: Key('language-badge-${layout.id}'),
                      icon: Icons.translate,
                    ),
                  ],
                ),
                const SizedBox(height: Sp.sm),
                Wrap(
                  spacing: Sp.sm,
                  runSpacing: Sp.sm,
                  children: [
                    for (final c in usedBy)
                      InfoBadge(
                        _defaultText(c),
                        key: Key('used-by-${layout.id}-${c.code}'),
                        icon: Icons.check,
                        color: AppColors.primary,
                      ),
                    if (usedBy.isEmpty)
                      Text('Not a default anywhere.', style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _menu(BuildContext context, ReceiptLayoutsCubit cubit, String action) async {
    switch (action) {
      case 'edit':
        context.push(RouteNames.settingsReceiptLayoutPath(layout.id));
      case 'duplicate':
        await cubit.duplicate(layout.id, name: '${layout.name} copy');
      case 'rename':
        final name = await _askName(context, layout.name);
        if (name != null) await cubit.rename(layout.id, name);
      case 'delete':
        final sure = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Delete "${layout.name}"?'),
            content: const Text(
              'Receipts will stop using this layout. If it is chosen as a default '
              'you must pick another layout first.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              FilledButton(
                key: const Key('confirm-delete-layout'),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (sure == true) await cubit.delete(layout.id);
    }
  }

  Future<String?> _askName(BuildContext context, String current) {
    final controller = TextEditingController(text: current);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename layout'),
        content: TextField(
          key: const Key('rename-field'),
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Layout name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            key: const Key('rename-confirm'),
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _NewLayout {
  const _NewLayout(this.design, this.name, this.preset);
  final ReceiptDesign design;
  final String name;
  final ReceiptPreset? preset;
}

class _NewLayoutDialog extends StatefulWidget {
  const _NewLayoutDialog();

  @override
  State<_NewLayoutDialog> createState() => _NewLayoutDialogState();
}

class _NewLayoutDialogState extends State<_NewLayoutDialog> {
  ReceiptDesign _design = ReceiptDesign.thermalClassic;
  ReceiptPreset? _preset;
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New receipt layout'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                key: const Key('new-layout-name'),
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  helperText: 'For example "Counter receipt" or "Tax invoice".',
                ),
              ),
              const SizedBox(height: 16),
              Text('Start from a ready-made choice', style: AppTextStyles.titleMedium),
              const SizedBox(height: 4),
              for (final p in ReceiptPreset.all)
                RadioListTile<String>(
                  key: Key('new-preset-${p.id}'),
                  contentPadding: EdgeInsets.zero,
                  value: 'preset:${p.id}',
                  groupValue: _preset == null ? 'design:${_design.code}' : 'preset:${_preset!.id}',
                  title: Text(p.title),
                  subtitle: Text(p.description),
                  onChanged: (_) => setState(() {
                    _preset = p;
                    _design = p.design;
                  }),
                ),
              const Divider(),
              Text('Or pick a design', style: AppTextStyles.titleMedium),
              for (final d in ReceiptDesign.values)
                RadioListTile<String>(
                  key: Key('new-design-${d.code}'),
                  contentPadding: EdgeInsets.zero,
                  value: 'design:${d.code}',
                  groupValue: _preset == null ? 'design:${_design.code}' : 'preset:${_preset!.id}',
                  title: Text(d.title),
                  subtitle: Text(d.description),
                  onChanged: (_) => setState(() {
                    _preset = null;
                    _design = d;
                  }),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          key: const Key('create-layout-confirm'),
          onPressed: () => Navigator.pop(
            context,
            _NewLayout(_design, _name.text, _preset),
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
