import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_context.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_switches.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layout_editor_cubit.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layouts_cubit.dart';
import 'package:frantend/features/receipts/presentation/widgets/layout_actions.dart';
import 'package:frantend/features/receipts/presentation/widgets/layout_preview.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:go_router/go_router.dart';

/// Opens the editor for one layout (loaded from the device copy).
class ReceiptLayoutEditorPage extends StatelessWidget {
  const ReceiptLayoutEditorPage({super.key, required this.layoutId, this.store, this.api, this.isOnline});

  final String layoutId;
  final ReceiptLayoutStore? store;
  final ReceiptLayoutApi? api;
  final bool Function()? isOnline;

  @override
  Widget build(BuildContext context) {
    if (!hasPermission(context, 'settings.manage')) {
      return const Scaffold(
        body: Center(child: Text("You don't have permission to change receipt layouts.")),
      );
    }
    final layouts = store ?? sl<ReceiptLayoutStore>();
    return FutureBuilder<ReceiptLayout?>(
      future: layouts.layout(layoutId),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final layout = snap.data;
        if (layout == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Receipt layout')),
            body: const Center(child: Text('This layout was not found on this device.')),
          );
        }
        return BlocProvider(
          create: (_) => ReceiptLayoutEditorCubit(
            layout: layout,
            api: api ?? sl<ReceiptLayoutApi>(),
            store: layouts,
            isOnline: isOnline ?? () => sl<ConnectivityProbe>().isReachable,
          ),
          child: _EditorView(isOnline: isOnline ?? () => sl<ConnectivityProbe>().isReachable),
        );
      },
    );
  }
}

class _EditorView extends StatefulWidget {
  const _EditorView({required this.isOnline});

  final bool Function() isOnline;

  @override
  State<_EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<_EditorView> {
  ReceiptBusiness? _business;

  @override
  void initState() {
    super.initState();
    LayoutActions.realBusiness().then((b) {
      if (mounted) setState(() => _business = b);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiptLayoutEditorCubit, ReceiptLayoutEditorState>(
      listenWhen: (a, b) => a.error != b.error || (!a.justSaved && b.justSaved),
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.error != null) {
          messenger.showSnackBar(SnackBar(content: Text(state.error!)));
        } else if (state.justSaved) {
          messenger.showSnackBar(const SnackBar(content: Text('Layout saved.')));
        }
      },
      builder: (context, state) {
        final online = widget.isOnline();
        final cubit = context.read<ReceiptLayoutEditorCubit>();
        final controls = _Controls(state: state, enabled: online && !state.draft.isBuiltIn);
        final preview = _PreviewPane(state: state, business: _business);
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(state.draft.name.isEmpty ? 'Receipt layout' : state.draft.name),
            leading: BackButton(onPressed: () => _leave(context, state)),
            actions: [
              TextButton.icon(
                key: const Key('editor-test-print'),
                onPressed: () => LayoutActions.testPrint(context, state.draft),
                icon: const Icon(Icons.print),
                label: const Text('Test print'),
              ),
              TextButton.icon(
                key: const Key('editor-save-pdf'),
                onPressed: () => LayoutActions.savePdf(context, state.draft),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Save as PDF'),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilledButton.icon(
                  key: const Key('editor-save'),
                  onPressed: online && state.dirty && !state.saving ? cubit.save : null,
                  icon: state.saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              if (!online)
                MaterialBanner(
                  key: const Key('editor-offline-notice'),
                  backgroundColor: Colors.amber.shade100,
                  content: const Text(ReceiptLayoutsCubit.offlineMessage),
                  leading: const Icon(Icons.cloud_off),
                  actions: const [SizedBox.shrink()],
                ),
              if (state.draft.isBuiltIn)
                MaterialBanner(
                  backgroundColor: Colors.blue.shade50,
                  content: const Text(
                    'This is the built-in receipt used until your layouts reach this device. '
                    'Create a layout from the Receipt layouts list to change it.',
                  ),
                  leading: const Icon(Icons.info_outline),
                  actions: const [SizedBox.shrink()],
                ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, c) {
                    if (c.maxWidth >= 900) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 480, child: controls),
                          const VerticalDivider(width: 1),
                          Expanded(child: preview),
                        ],
                      );
                    }
                    return ListView(
                      children: [
                        SizedBox(height: 420, child: preview),
                        controls,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _leave(BuildContext context, ReceiptLayoutEditorState state) async {
    if (!state.dirty) {
      context.pop();
      return;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave without saving?'),
        content: const Text('Your changes to this layout have not been saved.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep editing')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Leave')),
        ],
      ),
    );
    if (leave == true && context.mounted) context.pop();
  }
}

class _PreviewPane extends StatelessWidget {
  const _PreviewPane({required this.state, required this.business});

  final ReceiptLayoutEditorState state;
  final ReceiptBusiness? business;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text('Live preview', style: AppTextStyles.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Made with a sample sale. This is exactly how the receipt will look.',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              LayoutPreview(
                layout: state.draft,
                business: business,
                maxWidth: (c.maxWidth - 40).clamp(200, 640).toDouble(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.state, required this.enabled});

  final ReceiptLayoutEditorState state;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptLayoutEditorCubit>();
    final d = state.draft;
    final c = d.config;
    return AbsorbPointer(
      absorbing: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: ValueKey('name-${state.revision}'),
              initialValue: d.name,
              decoration: const InputDecoration(
                labelText: 'Layout name',
                helperText: 'Only you see this name, e.g. "Counter receipt".',
              ),
              onChanged: cubit.setName,
            ),
            const SizedBox(height: 12),
            Text(d.design.title, style: AppTextStyles.titleMedium),
            Text(d.design.description, style: AppTextStyles.bodySmall),
            const SizedBox(height: 12),
            if (d.design.papers.length > 1)
              DropdownButtonFormField<ReceiptPaper>(
                key: const Key('paper-size'),
                initialValue: d.paper,
                decoration: const InputDecoration(
                  labelText: 'Paper size',
                  helperText: 'Match the paper roll in your printer.',
                ),
                items: [
                  for (final p in d.design.papers)
                    DropdownMenuItem(value: p, child: Text(p.title)),
                ],
                onChanged: (p) {
                  if (p != null) cubit.setPaper(p);
                },
              )
            else
              Text('Paper: ${d.paper.title}', style: AppTextStyles.bodySmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in ReceiptPreset.all)
                  if (p.design.isA4 == d.design.isA4)
                    OutlinedButton(
                      key: Key('preset-${p.id}'),
                      onPressed: () => cubit.applyPreset(p),
                      child: Text(p.title),
                    ),
                TextButton(
                  key: const Key('reset-defaults'),
                  onPressed: cubit.resetToDefaults,
                  child: const Text('Reset to design defaults'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final group in ReceiptSwitches.groups.entries)
              _Group(
                title: group.key,
                initiallyExpanded: group.key == ReceiptSwitches.header,
                children: [
                  for (final spec in group.value)
                    SwitchListTile(
                      key: Key('switch-${spec.section}-${spec.key}'),
                      contentPadding: EdgeInsets.zero,
                      title: Text(spec.title),
                      subtitle: Text(spec.help, style: AppTextStyles.bodySmall),
                      value: _bool(c, spec.section, spec.key),
                      onChanged: (v) => cubit.setSwitch(spec.section, spec.key, v),
                    ),
                  ..._extras(context, group.key, state),
                ],
              ),
            _Group(
              title: 'Style',
              children: [
                const Text('Text size', style: TextStyle(fontWeight: FontWeight.w600)),
                Slider(
                  key: const Key('font-scale'),
                  value: c.style.fontScale,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: '${(c.style.fontScale * 100).round()}%',
                  onChanged: cubit.setFontScale,
                ),
                Text('Make everything on the receipt smaller or bigger.',
                    style: AppTextStyles.bodySmall),
                SwitchListTile(
                  key: const Key('switch-style-show_dividers'),
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Divider lines'),
                  subtitle: Text('Thin lines between the parts of the receipt.',
                      style: AppTextStyles.bodySmall),
                  value: c.style.showDividers,
                  onChanged: (v) => cubit.setSwitch('style', 'show_dividers', v),
                ),
                SwitchListTile(
                  key: const Key('switch-style-compact_items'),
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tight item rows'),
                  subtitle: Text('Uses less paper by putting each item on fewer lines.',
                      style: AppTextStyles.bodySmall),
                  value: c.style.compactItems,
                  onChanged: (v) => cubit.setSwitch('style', 'compact_items', v),
                ),
              ],
            ),
            _Group(
              title: 'Words on the receipt',
              children: [
                Text(
                  'Change any caption. Add an Urdu version and it prints on the same line '
                  'as "English / اردو".',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 8),
                for (final key in ReceiptSwitches.editableLabels)
                  _LabelRow(
                    key: ValueKey('label-$key-${state.revision}'),
                    labelKey: key,
                    value: c.label(key),
                    onChanged: ({en, ur}) => cubit.setLabel(key, en: en, ur: ur),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static bool _bool(ReceiptLayoutConfig c, String section, String key) {
    final j = c.toJson()[section];
    return j is Map && j[key] == true;
  }

  List<Widget> _extras(BuildContext context, String group, ReceiptLayoutEditorState state) {
    final cubit = context.read<ReceiptLayoutEditorCubit>();
    final c = state.draft.config;
    switch (group) {
      case ReceiptSwitches.header:
        final extra = c.header.extraLines;
        return [
          TextFormField(
            key: ValueKey('ntn-label-${state.revision}'),
            initialValue: c.header.ntnLabel,
            decoration: const InputDecoration(
              labelText: 'Word printed before the NTN',
              helperText: 'Usually "NTN". The number itself comes from your Business Profile.',
            ),
            onChanged: (v) => cubit.setText('header', 'ntn_label', v),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                key: ValueKey('extra-$i-${state.revision}'),
                initialValue: i < extra.length ? extra[i] : '',
                decoration: InputDecoration(
                  labelText: 'Extra line ${i + 1}',
                  helperText: i == 0 ? 'For example a website or a license number.' : null,
                ),
                onChanged: (v) {
                  final lines = [...extra];
                  while (lines.length < 3) {
                    lines.add('');
                  }
                  lines[i] = v;
                  cubit.setExtraLines(lines);
                },
              ),
            ),
        ];
      case ReceiptSwitches.details:
        return [
          DropdownButtonFormField<String>(
            key: ValueKey('number-source-${state.revision}'),
            initialValue: c.meta.numberSource,
            decoration: const InputDecoration(
              labelText: 'Which receipt number to print',
              helperText:
                  'Counter number is made on this counter (like C1-0042) and is always there. '
                  'Invoice number comes from the server after the sale syncs; until then the counter number is used.',
              helperMaxLines: 4,
            ),
            items: const [
              DropdownMenuItem(value: 'register', child: Text('Counter number (C1-0042)')),
              DropdownMenuItem(value: 'official', child: Text('Invoice number (INV-0042)')),
            ],
            onChanged: (v) {
              if (v != null) cubit.setText('meta', 'number_source', v);
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: ValueKey('walkin-${state.revision}'),
            initialValue: c.meta.walkinLabel,
            decoration: const InputDecoration(
              labelText: 'Walk-in customer wording',
              helperText: 'Printed when no customer was chosen. Leave empty to print nothing.',
            ),
            onChanged: (v) => cubit.setText('meta', 'walkin_label', v),
          ),
        ];
      case ReceiptSwitches.items:
        return [
          DropdownButtonFormField<String>(
            key: ValueKey('name-language-${state.revision}'),
            initialValue: c.items.nameLanguage,
            decoration: const InputDecoration(
              labelText: 'Item name language',
              helperText:
                  'Products can have an Urdu name as well as the main name. Choose which to print.',
              helperMaxLines: 3,
            ),
            items: const [
              DropdownMenuItem(value: 'primary', child: Text('Main name')),
              DropdownMenuItem(value: 'secondary', child: Text('Urdu name')),
              DropdownMenuItem(value: 'both', child: Text('Both names')),
            ],
            onChanged: (v) {
              if (v != null) cubit.setText('items', 'name_language', v);
            },
          ),
        ];
      case ReceiptSwitches.footer:
        return [
          TextFormField(
            key: ValueKey('footer-en-${state.revision}'),
            initialValue: c.footer.textEn,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Thank-you message (English)',
              helperText: 'Printed at the bottom, e.g. "Thank you! Come again."',
            ),
            onChanged: (v) => cubit.setText('footer', 'text_en', v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: ValueKey('footer-ur-${state.revision}'),
            initialValue: c.footer.textUr,
            maxLines: 2,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              labelText: 'Thank-you message (اردو)',
              helperText: 'Optional Urdu message, printed under the English one.',
            ),
            onChanged: (v) => cubit.setText('footer', 'text_ur', v),
          ),
        ];
    }
    return const [];
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children, this.initiallyExpanded = false});

  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(top: 12),
        child: ExpansionTile(
          key: PageStorageKey('group-$title'),
          initiallyExpanded: initiallyExpanded,
          title: Text(title, style: AppTextStyles.titleMedium),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({
    super.key,
    required this.labelKey,
    required this.value,
    required this.onChanged,
  });

  final String labelKey;
  final ReceiptLabel value;
  final void Function({String? en, String? ur}) onChanged;

  @override
  Widget build(BuildContext context) {
    final name = ReceiptLabelDefaults.friendlyNames[labelKey] ?? labelKey;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: Key('label-$labelKey-en'),
                  initialValue: value.en,
                  decoration: const InputDecoration(isDense: true, labelText: 'English'),
                  onChanged: (v) => onChanged(en: v),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  key: Key('label-$labelKey-ur'),
                  initialValue: value.ur,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(isDense: true, labelText: 'اردو'),
                  onChanged: (v) => onChanged(ur: v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
