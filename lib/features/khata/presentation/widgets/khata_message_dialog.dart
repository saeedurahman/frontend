import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/domain/khata_format.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/domain/text/reminder_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_message_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

/// Preview, change and send a WhatsApp reminder or statement. True when the
/// user said it was sent.
Future<bool> showKhataMessageDialog(
  BuildContext context,
  MessageRequest request, {
  KhataRepository? repository,
  UrlLauncherService? launcher,
}) async {
  final canLink = hasPermission(context, Perm.khataStatementCreate);
  final canLog = hasPermission(context, Perm.khataFollowupsCreate);
  final sent = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider(
      create: (_) => KhataMessageCubit(
        repository: repository ?? sl<KhataRepository>(),
        launcher: launcher ?? sl<UrlLauncherService>(),
        request: request,
        canLink: canLink,
        canLog: canLog,
      )..load(),
      child: const KhataMessageDialog(),
    ),
  );
  return sent ?? false;
}

/// Closing after "Yes, I sent it" still counts as sent.
void _close(BuildContext context) => Navigator.of(context).pop(
      context.read<KhataMessageCubit>().state.stage == MessageStage.done,
    );

class KhataMessageDialog extends StatefulWidget {
  const KhataMessageDialog({super.key});

  @override
  State<KhataMessageDialog> createState() => _KhataMessageDialogState();
}

class _KhataMessageDialogState extends State<KhataMessageDialog> {
  final _text = TextEditingController();
  final _phone = TextEditingController();
  int _revision = -1;

  @override
  void dispose() {
    _text.dispose();
    _phone.dispose();
    super.dispose();
  }

  /// Takes the text the app wrote; typing is never overwritten.
  void _adopt(MessageState state) {
    if (state.revision == _revision) return;
    _revision = state.revision;
    _text.text = state.text;
    if (_phone.text.isEmpty) _phone.text = state.phone;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<KhataMessageCubit>();
    final request = cubit.request;
    return Dialog(
      insetPadding: const EdgeInsets.all(AppDimensions.spacingLg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.enter, control: true):
                cubit.openWhatsApp,
            const SingleActivator(LogicalKeyboardKey.escape): () =>
                _close(context),
          },
          child: Focus(
            autofocus: true,
            child: BlocBuilder<KhataMessageCubit, MessageState>(
              builder: (context, state) {
                _adopt(state);
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingLg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(
                        title: request.kind == MessageKind.reminder
                            ? ReminderText.reminderTitle
                            : ReminderText.statementTitle,
                        subtitle: request.name,
                        offline: state.offline,
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      AnimatedSize(
                        duration: KhataStyle.normal,
                        curve: KhataStyle.curve,
                        alignment: Alignment.topCenter,
                        child: AnimatedSwitcher(
                          duration: KhataStyle.fast,
                          child: switch (state.stage) {
                            MessageStage.loading => const _Preparing(),
                            MessageStage.unavailable => _Unavailable(state),
                            MessageStage.editing => _editor(context, state),
                            MessageStage.confirming => _Confirm(state),
                            MessageStage.done => _Done(state),
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _editor(BuildContext context, MessageState state) {
    final cubit = context.read<KhataMessageCubit>();
    final linkReason = !cubit.canLink
        ? ReminderText.linkNoPermission
        : !cubit.isOnline
            ? ReminderText.linkOffline
            : null;
    final expires = state.link?.expiresAt;
    return Column(
      key: const ValueKey('message-editor'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.phoneNeeded) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  key: const Key('message-phone'),
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  onChanged: cubit.editPhone,
                  decoration: InputDecoration(
                    labelText: ReminderText.phoneLabel,
                    hintText: ReminderText.phoneHint,
                    helperText: ReminderText.phoneMissing,
                    helperMaxLines: 2,
                    errorText: state.phoneProblem,
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.spacing12),
                child: OutlinedButton(
                  key: const Key('message-save-phone'),
                  onPressed: state.busy ? null : cubit.savePhone,
                  child: const Text(ReminderText.savePhone),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
        ],
        Tooltip(
          message: linkReason ?? '',
          child: SwitchListTile(
            key: const Key('message-include-link'),
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text(ReminderText.includeLink),
            subtitle: state.linkBusy
                ? const Text(ReminderText.creatingLink)
                : linkReason != null
                    ? Text(linkReason)
                    : state.includeLink && expires != null
                        ? Text(
                            ReminderText.linkExpires(
                              KhataFormat.fullDay(expires),
                            ),
                          )
                        : null,
            value: state.includeLink,
            onChanged: linkReason != null || state.linkBusy
                ? null
                : cubit.setIncludeLink,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        TextField(
          key: const Key('message-text'),
          controller: _text,
          minLines: 8,
          maxLines: 14,
          onChanged: cubit.editText,
          style: const TextStyle(fontSize: 14, height: 1.4),
          decoration: const InputDecoration(
            labelText: ReminderText.messageLabel,
            alignLabelWithHint: true,
            filled: true,
            fillColor: Color(0xFFF1F8F3),
            border: OutlineInputBorder(),
          ),
        ),
        if (state.edited)
          Align(
            alignment: Alignment.centerRight,
            child: Tooltip(
              message: ReminderText.resetTextHint,
              child: TextButton.icon(
                key: const Key('message-reset'),
                onPressed: cubit.resetText,
                icon: const Icon(Icons.restart_alt, size: 16),
                label: const Text(ReminderText.resetText),
              ),
            ),
          ),
        _Messages(state),
        const SizedBox(height: AppDimensions.spacingMd),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(KhataUiText.cancel),
            ),
            OutlinedButton.icon(
              onPressed: cubit.copyText,
              icon: const Icon(Icons.copy_outlined, size: 16),
              label: const Text(ReminderText.copyText),
            ),
            Tooltip(
              message: ReminderText.openWhatsAppHint,
              child: FilledButton.icon(
                key: const Key('message-open-whatsapp'),
                onPressed: state.busy || state.linkBusy
                    ? null
                    : cubit.openWhatsApp,
                icon: const Icon(Icons.chat_outlined, size: 16),
                label: const Text(ReminderText.openWhatsApp),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.offline,
  });

  final String title;
  final String subtitle;
  final bool offline;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                if (offline) ...[
                  const SizedBox(height: AppDimensions.spacingSm),
                  const KhataChip(
                    label: ReminderText.offlineNote,
                    color: AppColors.warning,
                    textColor: Color(0xFF9C4410),
                    icon: Icons.cloud_off_outlined,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: KhataUiText.close,
            onPressed: () => _close(context),
            icon: const Icon(Icons.close),
          ),
        ],
      );
}

class _Preparing extends StatelessWidget {
  const _Preparing() : super(key: const ValueKey('message-loading'));

  @override
  Widget build(BuildContext context) => const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ReminderText.preparing,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.spacing12),
          SkeletonRows(count: 4, height: 32),
        ],
      );
}

class _Unavailable extends StatelessWidget {
  const _Unavailable(this.state);

  final MessageState state;

  @override
  Widget build(BuildContext context) => KhataEmptyState(
        key: const ValueKey('message-unavailable'),
        icon: Icons.cloud_off_outlined,
        color: AppColors.warning,
        title: state.error ?? ReminderText.needsInternetOnce,
        message: ReminderText.needsInternetOnce,
        actionLabel: KhataUiText.retry,
        onAction: context.read<KhataMessageCubit>().load,
      );
}

/// Errors and notes under the message.
class _Messages extends StatelessWidget {
  const _Messages(this.state);

  final MessageState state;

  @override
  Widget build(BuildContext context) {
    final text = state.error ?? state.notice;
    if (text == null) return const SizedBox.shrink();
    final color = state.error == null ? AppColors.info : AppColors.error;
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            state.error == null ? Icons.info_outline : Icons.error_outline,
            size: 16,
            color: color,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(text, style: TextStyle(color: color, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _Confirm extends StatelessWidget {
  const _Confirm(this.state) : super(key: const ValueKey('message-confirm'));

  final MessageState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<KhataMessageCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const KhataEmptyState(
          icon: Icons.mark_chat_read_outlined,
          title: ReminderText.didYouSend,
          message: ReminderText.didYouSendBody,
        ),
        _Messages(state),
        const SizedBox(height: AppDimensions.spacingSm),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: [
            OutlinedButton(
              key: const Key('message-not-sent'),
              onPressed: state.busy ? null : cubit.notSent,
              child: const Text(ReminderText.notYet),
            ),
            FilledButton.icon(
              key: const Key('message-yes-sent'),
              autofocus: true,
              onPressed: state.busy ? null : cubit.confirmSent,
              icon: const Icon(Icons.check, size: 16),
              label: const Text(ReminderText.yesSent),
            ),
          ],
        ),
      ],
    );
  }
}

class _Done extends StatelessWidget {
  const _Done(this.state) : super(key: const ValueKey('message-done'));

  final MessageState state;

  @override
  Widget build(BuildContext context) => KhataEmptyState(
        icon: Icons.check_circle_outline,
        color: AppColors.success,
        title:
            state.logged ? ReminderText.noted : ReminderText.sentNotNoted,
        actionLabel: ReminderText.done,
        onAction: () => Navigator.of(context).pop(true),
      );
}
