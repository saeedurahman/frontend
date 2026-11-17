import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
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
        appBar: AppBar(title: const Text('Receipt layouts')),
        body: const Center(
          child: Text("You don't have permission to change receipt layouts."),
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
            title: const Text('Receipt layouts'),
            leading: BackButton(onPressed: () => context.go(RouteNames.settings)),
            actions: [
              TextButton.icon(
                key: const Key('open-assignments'),
                onPressed: () => context.push(RouteNames.settingsReceiptAssignments),
                icon: const Icon(Icons.rule),
                label: const Text('Where each layout is used'),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilledButton.icon(
                  key: const Key('new-layout'),
                  onPressed: state.busy ? null : () => _create(context, cubit),
                  icon: const Icon(Icons.add),
                  label: const Text('New layout'),
                ),
              ),
            ],
          ),
          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (!state.online)
                      Card(
                        key: const Key('layouts-offline-notice'),
                        color: Colors.amber.shade100,
                        child: const ListTile(
                          leading: Icon(Icons.cloud_off),
                          title: Text(ReceiptLayoutsCubit.offlineMessage),
                        ),
                      ),
                    if (state.layouts.isEmpty)
                      const Card(
                        key: Key('layouts-empty'),
                        child: ListTile(
                          leading: Icon(Icons.receipt_long),
                          title: Text('Your receipts use the built-in classic design'),
                          subtitle: Text(
                            'Your own layouts appear here once this device has synced. '
                            'You can then make a copy of any design and change it.',
                          ),
                        ),
                      ),
                    for (final l in state.layouts)
                      _LayoutCard(
                        layout: l,
                        usedBy: state.usedBy(l.id),
                        canDelete: state.layouts.length > 1,
                        busy: state.busy,
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

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptLayoutsCubit>();
    return Card(
      key: Key('layout-${layout.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push(RouteNames.settingsReceiptLayoutPath(layout.id)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutThumbnail(layout: layout),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(layout.name, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    Text('${layout.design.title} · ${layout.paper.title}',
                        style: AppTextStyles.bodySmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final c in usedBy)
                          Chip(
                            key: Key('used-by-${layout.id}-${c.code}'),
                            visualDensity: VisualDensity.compact,
                            avatar: const Icon(Icons.check, size: 16),
                            label: Text('Used for ${c.title.toLowerCase()}'),
                          ),
                        if (usedBy.isEmpty)
                          Text('Not used by default anywhere.',
                              style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                key: Key('layout-menu-${layout.id}'),
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
        ),
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
