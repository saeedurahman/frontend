import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/domain/message_template.dart';
import 'package:frantend/features/khata/domain/text/khata_settings_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_messages_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_segmented.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';
import 'package:frantend/utils/app_alerts.dart';

/// Settings > Khata messages.
class KhataMessagesPage extends StatelessWidget {
  const KhataMessagesPage({super.key, this.createCubit, this.probe});

  /// Tests supply their own cubit (not yet loaded).
  final KhataMessagesCubit Function()? createCubit;
  final ConnectivityProbe? probe;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) =>
            (createCubit?.call() ?? KhataMessagesCubit(sl<KhataRepository>()))
              ..load(),
        child: _View(probe: probe),
      );
}

class _View extends StatefulWidget {
  const _View({this.probe});

  final ConnectivityProbe? probe;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _template = TextEditingController();
  final _terms = TextEditingController();
  final _templateFocus = FocusNode();
  int _revision = -1;

  /// From this width the preview sits beside the editor.
  static const _wideFrom = 900.0;

  @override
  void dispose() {
    _template.dispose();
    _terms.dispose();
    _templateFocus.dispose();
    super.dispose();
  }

  /// Takes the text the app wrote; typing is never overwritten.
  void _adopt(KhataMessagesState state) {
    if (state.revision == _revision) return;
    _revision = state.revision;
    _template.text = state.template;
    if (_terms.text.isEmpty) _terms.text = state.terms;
  }

  /// Puts a variable where the cursor is.
  void _insert(String variable) {
    final token = '{$variable}';
    final text = _template.text;
    final selection = _template.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    _template.value = TextEditingValue(
      text: text.replaceRange(start, end, token),
      selection: TextSelection.collapsed(offset: start + token.length),
    );
    context.read<KhataMessagesCubit>().editTemplate(_template.text);
    _templateFocus.requestFocus();
  }

  Future<void> _save() async {
    final cubit = context.read<KhataMessagesCubit>();
    if (!cubit.state.dirty || !cubit.state.isValid) return;
    final error = await cubit.save();
    if (!mounted) return;
    if (error == null) {
      AppAlerts.showSuccessMessage(context, KhataSettingsText.saved);
    } else {
      AppAlerts.showErrorMessage(context, error);
    }
  }

  @override
  Widget build(BuildContext context) => OfflineAwareBuilder(
        probe: widget.probe,
        builder: (context, offline) => PermissionGate(
          permission: Perm.settingsManage,
          mode: GateMode.disable,
          mutating: true,
          builder: (context, allowed) =>
              BlocBuilder<KhataMessagesCubit, KhataMessagesState>(
            builder: (context, state) {
              if (state.loading) {
                return const SingleChildScrollView(
                  child: SkeletonRows(count: 4, height: 96),
                );
              }
              if (state.error != null) {
                return KhataEmptyState(
                  icon: Icons.error_outline,
                  title: KhataSettingsText.loadFailed,
                  message: state.error,
                  actionLabel: KhataSettingsText.retry,
                  onAction: context.read<KhataMessagesCubit>().load,
                );
              }
              _adopt(state);
              final editable = allowed && !offline;
              return CallbackShortcuts(
                bindings: {
                  const SingleActivator(
                    LogicalKeyboardKey.keyS,
                    control: true,
                  ): () {
                    if (editable) _save();
                  },
                },
                child: _body(state, offline, editable),
              );
            },
          ),
        ),
      );

  Widget _body(KhataMessagesState state, bool offline, bool editable) {
    final cubit = context.read<KhataMessagesCubit>();
    final problem = state.problem;

    final editor = KhataCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KhataSegmented<TemplateKind>(
            key: const Key('template-tabs'),
            options: const [
              (TemplateKind.reminder, KhataSettingsText.reminderTab),
              (TemplateKind.statement, KhataSettingsText.statementTab),
            ],
            selected: state.tab,
            onChanged: cubit.setTab,
          ),
          const SizedBox(height: AppDimensions.spacing12),
          TextField(
            key: const Key('template-field'),
            controller: _template,
            focusNode: _templateFocus,
            enabled: editable,
            minLines: 8,
            maxLines: 14,
            decoration: InputDecoration(
              labelText: KhataSettingsText.templateLabel,
              alignLabelWithHint: true,
              errorText:
                  problem == null ? null : KhataSettingsText.problem(problem),
              errorMaxLines: 3,
              border: const OutlineInputBorder(),
            ),
            onChanged: cubit.editTemplate,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          const Text(
            KhataSettingsText.variablesHint,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingSm,
            children: [
              for (final v in MessageTemplate.variables)
                ActionChip(
                  key: ValueKey('variable-$v'),
                  label: Text(KhataSettingsText.variable(v)),
                  tooltip: '{$v}',
                  onPressed: editable ? () => _insert(v) : null,
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              key: const Key('template-reset'),
              onPressed: editable ? cubit.resetTemplate : null,
              icon: const Icon(Icons.restart_alt, size: 18),
              label: const Text(KhataSettingsText.reset),
            ),
          ),
        ],
      ),
    );

    final preview = KhataCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            KhataSettingsText.preview,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const Text(
            KhataSettingsText.previewHint,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.spacing12),
          // A chat bubble, as the customer sees it.
          AnimatedSize(
            duration: KhataStyle.fast,
            curve: KhataStyle.curve,
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
              decoration: const BoxDecoration(
                color: Color(0xFFE7F7DE),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppDimensions.radiusLg),
                  bottomLeft: Radius.circular(AppDimensions.radiusLg),
                  bottomRight: Radius.circular(AppDimensions.radiusLg),
                ),
              ),
              child: Text(
                state.preview,
                key: const Key('template-preview'),
                style: const TextStyle(fontSize: 13, height: 1.45),
              ),
            ),
          ),
        ],
      ),
    );

    final choices = KhataCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            KhataSettingsText.choices,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          SwitchListTile(
            key: const Key('show-items'),
            contentPadding: EdgeInsets.zero,
            title: const Text(KhataSettingsText.showItems),
            subtitle: const Text(KhataSettingsText.showItemsHint),
            value: state.showItems,
            onChanged: editable ? cubit.setShowItems : null,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          TextField(
            key: const Key('default-terms'),
            controller: _terms,
            enabled: editable,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            decoration: InputDecoration(
              labelText: KhataSettingsText.terms,
              helperText: KhataSettingsText.termsHint,
              helperMaxLines: 2,
              errorText: state.termsDays == null
                  ? KhataSettingsText.termsInvalid
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: cubit.setTerms,
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (offline) ...[
          const OnlineOnlyBanner(message: OfflineMessages.editingNotice),
          const SizedBox(height: AppDimensions.spacing12),
        ],
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppDimensions.spacingMd,
          runSpacing: AppDimensions.spacingSm,
          children: [
            const Text(
              KhataSettingsText.messagesTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            FilledButton(
              key: const Key('messages-save'),
              onPressed:
                  editable && state.dirty && state.isValid && !state.saving
                      ? _save
                      : null,
              child: Text(
                state.saving
                    ? KhataSettingsText.saving
                    : KhataSettingsText.save,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        const Text(
          KhataSettingsText.messagesSubtitle,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, box) => SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
              child: box.maxWidth >= _wideFrom
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              editor,
                              const SizedBox(height: AppDimensions.spacingMd),
                              choices,
                            ],
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingMd),
                        Expanded(flex: 2, child: preview),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        editor,
                        const SizedBox(height: AppDimensions.spacingMd),
                        preview,
                        const SizedBox(height: AppDimensions.spacingMd),
                        choices,
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
