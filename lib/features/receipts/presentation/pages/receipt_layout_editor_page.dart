import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_context.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_switches.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layout_editor_cubit.dart';
import 'package:frantend/features/receipts/presentation/cubit/receipt_layouts_cubit.dart';
import 'package:frantend/features/receipts/presentation/widgets/layout_actions.dart';
import 'package:frantend/features/receipts/presentation/widgets/layout_preview.dart';
import 'package:frantend/features/receipts/presentation/widgets/receipt_ui.dart';
import 'package:frantend/features/receipts/presentation/widgets/receipt_view.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:go_router/go_router.dart';

/// Window width from which the editor and the live preview sit side by side.
const double kEditorTwoPaneWidth = 860;

/// Opens the editor for one layout (loaded from the device copy).
class ReceiptLayoutEditorPage extends StatelessWidget {
  const ReceiptLayoutEditorPage({
    super.key,
    required this.layoutId,
    this.store,
    this.api,
    this.isOnline,
  });

  final String layoutId;
  final ReceiptLayoutStore? store;
  final ReceiptLayoutApi? api;
  final bool Function()? isOnline;

  @override
  Widget build(BuildContext context) {
    if (!hasPermission(context, 'settings.manage')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Receipt layout')),
        body: const StateMessage(
          icon: Icons.lock_outline,
          title: "You don't have permission to change receipt layouts.",
        ),
      );
    }
    final layouts = store ?? sl<ReceiptLayoutStore>();
    return FutureBuilder<ReceiptLayout?>(
      future: layouts.layout(layoutId),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const _EditorSkeleton();
        }
        final layout = snap.data;
        if (layout == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(title: const Text('Receipt layout')),
            body: StateMessage(
              icon: Icons.search_off,
              title: 'This layout was not found on this device.',
              message:
                  'It may have been deleted. Go back to the list and pick another one.',
              action: OutlinedButton(
                onPressed: () => context.go(RouteNames.settingsReceiptLayouts),
                child: const Text('Back to Receipt Layouts'),
              ),
            ),
          );
        }
        final online = isOnline ?? () => sl<ConnectivityProbe>().isReachable;
        return BlocProvider(
          create: (_) => ReceiptLayoutEditorCubit(
            layout: layout,
            api: api ?? sl<ReceiptLayoutApi>(),
            store: layouts,
            isOnline: online,
          ),
          child: _EditorView(isOnline: online),
        );
      },
    );
  }
}

/// Grey placeholders in the shape of the editor while the layout loads.
class _EditorSkeleton extends StatelessWidget {
  const _EditorSkeleton();

  @override
  Widget build(BuildContext context) => Scaffold(
    key: const Key('editor-skeleton'),
    backgroundColor: AppColors.background,
    appBar: AppBar(title: const SkeletonBox(width: 160, height: 20)),
    body: Padding(
      padding: const EdgeInsets.all(Sp.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < 4; i++) ...[
            const SkeletonBox(height: 72, radius: AppDimensions.radiusMd),
            const SizedBox(height: Sp.lg),
          ],
        ],
      ),
    ),
  );
}

class _EditorView extends StatefulWidget {
  const _EditorView({required this.isOnline});

  final bool Function() isOnline;

  @override
  State<_EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<_EditorView>
    with SingleTickerProviderStateMixin {
  static const _zoomSteps = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  late final TabController _tabs = TabController(length: 2, vsync: this);
  ReceiptBusiness? _business;
  double _zoom = 1.0;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    LayoutActions.realBusiness().then((b) {
      if (mounted) setState(() => _business = b);
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _zoomBy(int delta) {
    final i = _zoomSteps.indexOf(_zoom);
    final next = (i + delta).clamp(0, _zoomSteps.length - 1);
    setState(() => _zoom = _zoomSteps[next]);
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
          messenger.showSnackBar(
            const SnackBar(content: Text('Layout saved.')),
          );
        }
      },
      builder: (context, state) {
        final online = widget.isOnline();
        final editable = online && !state.draft.isBuiltIn;
        return PopScope(
          canPop: !state.dirty || _leaving,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _leave(context, state);
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      state.draft.name.isEmpty
                          ? 'Receipt layout'
                          : state.draft.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (state.dirty) ...[
                    const SizedBox(width: Sp.sm),
                    Tooltip(
                      message: 'Unsaved changes',
                      child: Container(
                        key: const Key('editor-unsaved-dot'),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.warning,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              leading: BackButton(
                key: const Key('editor-back'),
                onPressed: () => _leave(context, state),
              ),
            ),
            body: Column(
              children: [
                if (!online)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(Sp.lg, Sp.md, Sp.lg, 0),
                    child: OfflineNotice(
                      key: Key('editor-offline-notice'),
                      message: ReceiptLayoutsCubit.offlineMessage,
                    ),
                  ),
                if (state.draft.isBuiltIn)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(Sp.lg, Sp.md, Sp.lg, 0),
                    child: OfflineNotice(
                      message:
                          'This is the built-in receipt used until your layouts reach this device. '
                          'Create a layout from the Receipt Layouts list to change it.',
                    ),
                  ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final form = _EditorForm(state: state, enabled: editable);
                      final preview = _PreviewPane(
                        state: state,
                        business: _business,
                        zoom: _zoom,
                        onZoom: _zoomBy,
                      );
                      if (c.maxWidth >= kEditorTwoPaneWidth) {
                        final left = (c.maxWidth * 0.5)
                            .clamp(440.0, 580.0)
                            .toDouble();
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(width: left, child: form),
                            const VerticalDivider(
                              width: 1,
                              color: AppColors.border,
                            ),
                            Expanded(child: preview),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Material(
                            color: AppColors.surface,
                            child: TabBar(
                              key: const Key('editor-tabs'),
                              controller: _tabs,
                              labelColor: AppColors.primary,
                              indicatorColor: AppColors.primary,
                              tabs: const [
                                Tab(
                                  key: Key('tab-edit'),
                                  icon: Icon(Icons.tune),
                                  text: 'Edit',
                                ),
                                Tab(
                                  key: Key('tab-preview'),
                                  icon: Icon(Icons.receipt_long),
                                  text: 'Preview',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: AnimatedBuilder(
                              animation: _tabs,
                              builder: (context, _) => IndexedStack(
                                index: _tabs.index,
                                children: [form, preview],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _ActionBar(state: state, online: online),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _leave(
    BuildContext context,
    ReceiptLayoutEditorState state,
  ) async {
    void goBack() {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(RouteNames.settingsReceiptLayouts);
      }
    }

    if (!state.dirty) {
      goBack();
      return;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key('leave-dialog'),
        title: const Text('Leave without saving?'),
        content: const Text('Your changes to this layout have not been saved.'),
        actions: [
          TextButton(
            key: const Key('leave-keep'),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            key: const Key('leave-discard'),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (leave == true && context.mounted) {
      setState(() => _leaving = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) goBack();
      });
    }
  }
}

// ───────────────────────── bottom action bar ─────────────────────────

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.state, required this.online});

  final ReceiptLayoutEditorState state;
  final bool online;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptLayoutEditorCubit>();
    final dirty = state.dirty;
    final status = Row(
      key: const Key('editor-unsaved-indicator'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          dirty ? Icons.circle : Icons.check_circle_outline,
          size: dirty ? 10 : 16,
          color: dirty ? AppColors.warning : AppColors.success,
        ),
        const SizedBox(width: Sp.sm),
        Flexible(
          child: Text(
            dirty ? 'Unsaved changes' : 'All changes saved',
            style: AppTextStyles.bodySmall.copyWith(
              color: dirty ? AppColors.warning : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
    final actions = Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: Sp.sm,
      runSpacing: Sp.sm,
      children: [
        Tooltip(
          message: 'Throw away the changes you made since the last save',
          child: TextButton(
            key: const Key('editor-discard'),
            onPressed: dirty && !state.saving ? cubit.discard : null,
            child: const Text('Discard'),
          ),
        ),
        Tooltip(
          message: 'Save the sample receipt as a PDF file',
          child: OutlinedButton.icon(
            key: const Key('editor-save-pdf'),
            onPressed: () => LayoutActions.savePdf(context, state.draft),
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
            label: const Text('Save as PDF'),
          ),
        ),
        Tooltip(
          message: 'Print the sample receipt on your receipt printer',
          child: OutlinedButton.icon(
            key: const Key('editor-test-print'),
            onPressed: () => LayoutActions.testPrint(context, state.draft),
            icon: const Icon(Icons.print_outlined, size: 18),
            label: const Text('Test print'),
          ),
        ),
        Tooltip(
          message: online
              ? 'Save this layout'
              : 'Connect to the internet to save',
          child: FilledButton.icon(
            key: const Key('editor-save'),
            onPressed: online && dirty && !state.saving ? cubit.save : null,
            icon: state.saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: const Text('Save'),
          ),
        ),
      ],
    );
    return Material(
      color: AppColors.surface,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sp.lg,
            vertical: Sp.md,
          ),
          child: LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 700) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    status,
                    const SizedBox(height: Sp.sm),
                    actions,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: status,
                    ),
                  ),
                  const SizedBox(width: Sp.lg),
                  Flexible(flex: 3, child: actions),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── live preview ─────────────────────────

class _PreviewPane extends StatelessWidget {
  const _PreviewPane({
    required this.state,
    required this.business,
    required this.zoom,
    required this.onZoom,
  });

  final ReceiptLayoutEditorState state;
  final ReceiptBusiness? business;
  final double zoom;
  final void Function(int delta) onZoom;

  @override
  Widget build(BuildContext context) {
    final model = LayoutPreviewModel.build(state.draft, business: business);
    final paperWidth = ReceiptView.paperWidth(model);
    return Container(
      key: const Key('preview-pane'),
      color: const Color(0xFFEDF1F6),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Sp.lg, Sp.md, Sp.lg, Sp.sm),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Live preview', style: AppTextStyles.titleMedium),
                      Text(
                        '${state.draft.paper.title} · ${state.draft.config.language.badge}',
                        key: const Key('preview-caption'),
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  key: const Key('preview-zoom-out'),
                  tooltip: 'Zoom out',
                  onPressed: zoom > 0.5 ? () => onZoom(-1) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                SizedBox(
                  width: 48,
                  child: Text(
                    '${(zoom * 100).round()}%',
                    key: const Key('preview-zoom-label'),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('preview-zoom-in'),
                  tooltip: 'Zoom in',
                  onPressed: zoom < 2.0 ? () => onZoom(1) : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final avail = (c.maxWidth - 2 * Sp.xl)
                    .clamp(160.0, 4000.0)
                    .toDouble();
                final scale =
                    (avail < paperWidth ? avail / paperWidth : 1.0) * zoom;
                final frame = SizedBox(
                  width: paperWidth * scale,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    child: ReceiptView(
                      key: const Key('layout-live-preview'),
                      model: model,
                    ),
                  ),
                );
                return Scrollbar(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sp.xl,
                      vertical: Sp.lg,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: avail),
                        child: Center(child: frame),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Sp.sm),
            child: Text(
              'Made with a sample sale. The paper prints just like this.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── editor form ─────────────────────────

class _EditorForm extends StatelessWidget {
  const _EditorForm({required this.state, required this.enabled});

  final ReceiptLayoutEditorState state;
  final bool enabled;

  static const _sections = <String, (IconData, String, String)>{
    ReceiptSwitches.header: (
      Icons.storefront_outlined,
      'Header',
      'Logo, shop name and contact details at the top.',
    ),
    ReceiptSwitches.details: (
      Icons.tag,
      'Receipt details',
      'Receipt number, date, cashier and customer.',
    ),
    ReceiptSwitches.items: (
      Icons.format_list_bulleted,
      'Items',
      'What is printed for each product sold.',
    ),
    ReceiptSwitches.totals: (
      Icons.calculate_outlined,
      'Totals',
      'Subtotal, discount, tax, payments and change.',
    ),
    ReceiptSwitches.footer: (
      Icons.short_text,
      'Footer',
      'Thank-you message, QR code and a small credit line.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptLayoutEditorCubit>();
    final c = state.draft.config;
    return AbsorbPointer(
      absorbing: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: FocusTraversalGroup(
          policy: ReadingOrderTraversalPolicy(),
          // A plain scroll view (not a lazy list): there are only a few
          // collapsed cards, and every field stays reachable by keyboard.
          child: SingleChildScrollView(
            key: const Key('editor-form'),
            padding: const EdgeInsets.all(Sp.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DesignCard(state: state),
                const SizedBox(height: Sp.lg),
                for (final group in ReceiptSwitches.groups.entries) ...[
                  SectionCard(
                    id: _id(group.key),
                    icon: _sections[group.key]!.$1,
                    title: _sections[group.key]!.$2,
                    description: _sections[group.key]!.$3,
                    initiallyExpanded: group.key == ReceiptSwitches.header,
                    children: [
                      for (final spec in group.value)
                        _switchRow(cubit, c, spec),
                      ..._extras(context, group.key),
                    ],
                  ),
                  const SizedBox(height: Sp.md),
                ],
                SectionCard(
                  id: 'language-style',
                  icon: Icons.translate,
                  title: 'Language & Style',
                  description:
                      'Receipt language, paper size, text size and wording.',
                  children: [_LanguageStyle(state: state)],
                ),
                const SizedBox(height: Sp.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _id(String title) => title.toLowerCase().replaceAll(' ', '-');

  static bool _bool(ReceiptLayoutConfig c, String section, String key) {
    final j = c.toJson()[section];
    return j is Map && j[key] == true;
  }

  static Widget _switchRow(
    ReceiptLayoutEditorCubit cubit,
    ReceiptLayoutConfig c,
    ReceiptSwitchSpec spec,
  ) {
    final value = _bool(c, spec.section, spec.key);
    return SettingRow(
      title: spec.title,
      help: spec.help,
      onTap: () => cubit.setSwitch(spec.section, spec.key, !value),
      trailing: Switch(
        key: Key('switch-${spec.section}-${spec.key}'),
        value: value,
        onChanged: (v) => cubit.setSwitch(spec.section, spec.key, v),
      ),
    );
  }

  List<Widget> _extras(BuildContext context, String group) {
    final cubit = context.read<ReceiptLayoutEditorCubit>();
    final c = state.draft.config;
    final language = c.language;
    switch (group) {
      case ReceiptSwitches.header:
        final extra = c.header.extraLines;
        return [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              key: const Key('change-logo-link'),
              onPressed: () => context.push(RouteNames.settingsBusiness),
              icon: const Icon(Icons.image_outlined, size: 18),
              label: const Text('Change logo in Business Profile'),
            ),
          ),
          _FieldBlock(
            child: TextFormField(
              key: ValueKey('ntn-label-${state.revision}'),
              initialValue: c.header.ntnLabel,
              decoration: const InputDecoration(
                labelText: 'Word printed before the NTN',
                helperText:
                    'Usually "NTN". The number itself comes from your Business Profile.',
                helperMaxLines: 2,
              ),
              onChanged: (v) => cubit.setText('header', 'ntn_label', v),
            ),
          ),
          for (var i = 0; i < 3; i++)
            _FieldBlock(
              child: TextFormField(
                key: ValueKey('extra-$i-${state.revision}'),
                initialValue: i < extra.length ? extra[i] : '',
                decoration: InputDecoration(
                  labelText: 'Extra line ${i + 1}',
                  helperText: i == 0
                      ? 'For example a website or a license number.'
                      : null,
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
          _FieldBlock(
            child: DropdownButtonFormField<String>(
              key: ValueKey('number-source-${state.revision}'),
              initialValue: c.meta.numberSource,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Which receipt number to print',
                helperText:
                    'Counter number is made on this counter (like C1-0042) and is always there. '
                    'Invoice number comes from the server after the sale syncs; until then the counter number is used.',
                helperMaxLines: 4,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'register',
                  child: Text('Counter number (C1-0042)'),
                ),
                DropdownMenuItem(
                  value: 'official',
                  child: Text('Invoice number (INV-0042)'),
                ),
              ],
              onChanged: (v) {
                if (v != null) cubit.setText('meta', 'number_source', v);
              },
            ),
          ),
          _FieldBlock(
            child: TextFormField(
              key: ValueKey('walkin-${state.revision}'),
              initialValue: c.meta.walkinLabel,
              decoration: const InputDecoration(
                labelText: 'Walk-in customer wording',
                helperText:
                    'Printed when no customer was chosen. Leave empty to print nothing.',
                helperMaxLines: 2,
              ),
              onChanged: (v) => cubit.setText('meta', 'walkin_label', v),
            ),
          ),
        ];
      case ReceiptSwitches.items:
        return [
          Padding(
            padding: const EdgeInsets.only(top: Sp.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: Sp.sm),
                Expanded(
                  child: Text(
                    'Product names print exactly as you typed them in Products. '
                    'The language setting only changes the captions around them.',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ];
      case ReceiptSwitches.footer:
        return [
          if (language != ReceiptLanguage.ur)
            _FieldBlock(
              child: TextFormField(
                key: ValueKey('footer-en-${state.revision}'),
                initialValue: c.footer.textEn,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Thank-you message (English)',
                  helperText:
                      'Printed at the bottom, e.g. "Thank you! Come again."',
                ),
                onChanged: (v) => cubit.setText('footer', 'text_en', v),
              ),
            ),
          if (language != ReceiptLanguage.en)
            _FieldBlock(
              child: TextFormField(
                key: ValueKey('footer-ur-${state.revision}'),
                initialValue: c.footer.textUr,
                maxLines: 2,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  labelText: 'Thank-you message (اردو)',
                  helperText: 'Printed at the bottom of an Urdu receipt.',
                ),
                onChanged: (v) => cubit.setText('footer', 'text_ur', v),
              ),
            ),
        ];
    }
    return const [];
  }
}

/// Vertical breathing room around a text field inside a section.
class _FieldBlock extends StatelessWidget {
  const _FieldBlock({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Sp.md),
    child: child,
  );
}

// ───────────────────────── design picker ─────────────────────────

class _DesignCard extends StatelessWidget {
  const _DesignCard({required this.state});

  final ReceiptLayoutEditorState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptLayoutEditorCubit>();
    final d = state.draft;
    return ReceiptCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: ValueKey('name-${state.revision}'),
            initialValue: d.name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Layout name',
              helperText: 'Only you see this name, e.g. "Counter receipt".',
            ),
            onChanged: cubit.setName,
          ),
          const SizedBox(height: Sp.xl),
          Text('Design', style: AppTextStyles.titleMedium),
          const SizedBox(height: Sp.xs),
          Text(d.design.description, style: AppTextStyles.bodySmall),
          const SizedBox(height: Sp.md),
          LayoutBuilder(
            builder: (context, c) {
              final cols = c.maxWidth >= 380 ? 2 : 1;
              final w = (c.maxWidth - Sp.md * (cols - 1)) / cols;
              return Wrap(
                spacing: Sp.md,
                runSpacing: Sp.md,
                children: [
                  for (final design in ReceiptDesign.values)
                    SizedBox(
                      width: w,
                      child: _DesignOption(
                        design: design,
                        selected: design == d.design,
                        sample: ReceiptLayout(
                          id: 'design-${design.code}',
                          name: design.title,
                          design: design,
                          paper: design.defaultPaper,
                          config: ReceiptLayoutConfig.defaultsFor(
                            design,
                          ).withLanguage(d.config.language),
                        ),
                        onTap: () => _pick(context, cubit, design),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: Sp.lg),
          Wrap(
            spacing: Sp.sm,
            runSpacing: Sp.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Quick start:', style: AppTextStyles.bodySmall),
              for (final p in ReceiptPreset.all)
                if (p.design.isA4 == d.design.isA4)
                  Tooltip(
                    message: p.description,
                    child: OutlinedButton(
                      key: Key('preset-${p.id}'),
                      onPressed: () => cubit.applyPreset(p),
                      child: Text(p.title),
                    ),
                  ),
              Tooltip(
                message:
                    "Back to this design's own settings (name and paper stay)",
                child: TextButton(
                  key: const Key('reset-defaults'),
                  onPressed: cubit.resetToDefaults,
                  child: const Text('Reset to design defaults'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pick(
    BuildContext context,
    ReceiptLayoutEditorCubit cubit,
    ReceiptDesign design,
  ) async {
    if (design == state.draft.design) return;
    final make = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key('design-switch-dialog'),
        title: Text('Use the ${design.title} design?'),
        content: const Text(
          'A layout keeps its design. To use another one we make a new layout with this '
          'design and your current settings. This layout stays as it is.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('design-switch-confirm'),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Make new layout'),
          ),
        ],
      ),
    );
    if (make != true || !context.mounted) return;
    final created = await cubit.startFromDesign(design);
    if (created != null && context.mounted) {
      context.pushReplacement(RouteNames.settingsReceiptLayoutPath(created.id));
    }
  }
}

class _DesignOption extends StatelessWidget {
  const _DesignOption({
    required this.design,
    required this.selected,
    required this.sample,
    required this.onTap,
  });

  final ReceiptDesign design;
  final bool selected;
  final ReceiptLayout sample;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: design.title,
      child: Material(
        key: Key('design-card-${design.code}'),
        color: selected
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Sp.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutThumbnail(layout: sample, width: 56, height: 72),
                const SizedBox(width: Sp.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        design.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: Sp.xs),
                      InfoBadge(design.isA4 ? 'A4' : design.defaultPaper.title),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle,
                    key: Key('design-selected-check'),
                    size: 20,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Language & Style ─────────────────────────

class _LanguageStyle extends StatefulWidget {
  const _LanguageStyle({required this.state});

  final ReceiptLayoutEditorState state;

  @override
  State<_LanguageStyle> createState() => _LanguageStyleState();
}

class _LanguageStyleState extends State<_LanguageStyle> {
  bool _showOther = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptLayoutEditorCubit>();
    final state = widget.state;
    final d = state.draft;
    final c = d.config;
    final language = c.language;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldBlock(
          child: _Labelled(
            title: 'Receipt language',
            help:
                'Every word on the receipt prints in this one language. '
                '"Both" prints the Urdu under the English on a second line.',
            child: SegmentedButton<ReceiptLanguage>(
              key: const Key('language-segmented'),
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: ReceiptLanguage.en,
                  label: Text('English', key: Key('language-en')),
                ),
                ButtonSegment(
                  value: ReceiptLanguage.ur,
                  label: Text('اردو', key: Key('language-ur')),
                ),
                ButtonSegment(
                  value: ReceiptLanguage.both,
                  label: Text('Both', key: Key('language-both')),
                ),
              ],
              selected: {language},
              onSelectionChanged: (s) => cubit.setLanguage(s.first),
            ),
          ),
        ),
        _FieldBlock(
          child: _Labelled(
            title: 'Paper size',
            help: d.design.papers.length > 1
                ? 'Match the paper roll in your printer.'
                : 'This design always prints on A4 paper.',
            child: SegmentedButton<ReceiptPaper>(
              key: const Key('paper-size'),
              showSelectedIcon: false,
              segments: [
                for (final p in ReceiptPaper.values)
                  ButtonSegment(
                    value: p,
                    enabled: d.design.papers.contains(p),
                    label: Text(switch (p) {
                      ReceiptPaper.roll58 => '58 mm',
                      ReceiptPaper.roll80 => '80 mm',
                      ReceiptPaper.a4 => 'A4',
                    }, key: Key('paper-${p.code}')),
                  ),
              ],
              selected: {d.paper},
              onSelectionChanged: (s) => cubit.setPaper(s.first),
            ),
          ),
        ),
        _FieldBlock(
          child: _Labelled(
            title: 'Text size  ·  ${(c.style.fontScale * 100).round()}%',
            help: 'Make everything on the receipt smaller or bigger.',
            child: Slider(
              key: const Key('font-scale'),
              value: c.style.fontScale,
              min: 0.8,
              max: 1.4,
              divisions: 6,
              label: '${(c.style.fontScale * 100).round()}%',
              onChanged: cubit.setFontScale,
            ),
          ),
        ),
        const SizedBox(height: Sp.sm),
        SettingRow(
          title: 'Divider lines',
          help: 'Thin lines between the parts of the receipt.',
          onTap: () =>
              cubit.setSwitch('style', 'show_dividers', !c.style.showDividers),
          trailing: Switch(
            key: const Key('switch-style-show_dividers'),
            value: c.style.showDividers,
            onChanged: (v) => cubit.setSwitch('style', 'show_dividers', v),
          ),
        ),
        SettingRow(
          title: 'Tight item rows',
          help: 'Uses less paper by putting each item on fewer lines.',
          onTap: () =>
              cubit.setSwitch('style', 'compact_items', !c.style.compactItems),
          trailing: Switch(
            key: const Key('switch-style-compact_items'),
            value: c.style.compactItems,
            onChanged: (v) => cubit.setSwitch('style', 'compact_items', v),
          ),
        ),
        const SizedBox(height: Sp.lg),
        Text('Words on the receipt', style: AppTextStyles.titleMedium),
        const SizedBox(height: Sp.xs),
        Text(
          language == ReceiptLanguage.both
              ? 'Change any caption in both languages.'
              : 'Change any caption. Only ${language == ReceiptLanguage.ur ? 'Urdu' : 'English'} '
                    'words are shown here because that is what prints.',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: Sp.md),
        _LabelGrid(
          key: const Key('label-grid'),
          state: state,
          codes: switch (language) {
            ReceiptLanguage.en => const ['en'],
            ReceiptLanguage.ur => const ['ur'],
            ReceiptLanguage.both => const ['en', 'ur'],
          },
        ),
        if (language != ReceiptLanguage.both) ...[
          const SizedBox(height: Sp.sm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              key: const Key('show-other-language'),
              onPressed: () => setState(() => _showOther = !_showOther),
              icon: Icon(
                _showOther ? Icons.expand_less : Icons.expand_more,
                size: 18,
              ),
              label: Text(
                _showOther
                    ? 'Hide other language fields'
                    : 'Show other language fields',
              ),
            ),
          ),
          if (_showOther) ...[
            Text(
              language == ReceiptLanguage.en
                  ? 'Urdu words (not printed while the receipt is English)'
                  : 'English words (not printed while the receipt is Urdu)',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: Sp.md),
            _LabelGrid(
              key: const Key('label-grid-other'),
              state: state,
              codes: [language == ReceiptLanguage.en ? 'ur' : 'en'],
            ),
          ],
        ],
      ],
    );
  }
}

class _Labelled extends StatelessWidget {
  const _Labelled({
    required this.title,
    required this.help,
    required this.child,
  });

  final String title;
  final String help;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: Sp.xs),
      Text(help, style: AppTextStyles.bodySmall),
      const SizedBox(height: Sp.sm),
      child,
    ],
  );
}

/// Caption fields in a clean two-column grid. [codes] are the languages shown:
/// one language flows two captions per row, "both" puts English and Urdu of
/// the same caption side by side.
class _LabelGrid extends StatelessWidget {
  const _LabelGrid({super.key, required this.state, required this.codes});

  final ReceiptLayoutEditorState state;
  final List<String> codes;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptLayoutEditorCubit>();
    final c = state.draft.config;
    return LayoutBuilder(
      builder: (context, box) {
        final cols = box.maxWidth >= 360 ? 2 : 1;
        final w = (box.maxWidth - Sp.md * (cols - 1)) / cols;
        return Wrap(
          spacing: Sp.md,
          runSpacing: Sp.md,
          children: [
            for (final key in ReceiptSwitches.editableLabels)
              for (final code in codes)
                SizedBox(
                  width: w,
                  child: TextFormField(
                    key: ValueKey('label-$key-$code-${state.revision}'),
                    initialValue: code == 'en'
                        ? c.label(key).en
                        : c.label(key).ur,
                    textDirection: code == 'ur'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: codes.length > 1
                          ? '${ReceiptLabelDefaults.friendlyNames[key] ?? key} · ${code == 'en' ? 'English' : 'اردو'}'
                          : ReceiptLabelDefaults.friendlyNames[key] ?? key,
                    ),
                    onChanged: (v) => code == 'en'
                        ? cubit.setLabel(key, en: v)
                        : cubit.setLabel(key, ur: v),
                  ),
                ),
          ],
        );
      },
    );
  }
}
