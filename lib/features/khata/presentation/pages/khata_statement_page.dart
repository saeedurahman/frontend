import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/file_share_service.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/core/session/active_branch_resolver.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/domain/khata_format.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/statement_period.dart';
import 'package:frantend/features/khata/domain/text/statement_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_message_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_statement_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_message_dialog.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_segmented.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';
import 'package:frantend/features/khata/presentation/widgets/statement_preview.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

/// A customer's or supplier's statement: choose the period, look at it, send
/// it, save it or print it.
class KhataStatementPage extends StatelessWidget {
  const KhataStatementPage({
    super.key,
    required this.partyType,
    required this.partyId,
    this.createCubit,
    this.repository,
    this.launcher,
  });

  final PartyType partyType;
  final String partyId;

  /// Tests supply their own cubit (not yet loaded).
  final KhataStatementCubit Function()? createCubit;
  final KhataRepository? repository;
  final UrlLauncherService? launcher;

  KhataStatementCubit _create() =>
      createCubit?.call() ??
      KhataStatementCubit(
        repository: repository ?? sl<KhataRepository>(),
        files: sl<FileSaverService>(),
        printer: sl<PrinterService>(),
        share: sl<FileShareService>(),
        partyType: partyType,
        partyId: partyId,
      );

  static Future<String?> _branch() async =>
      sl.isRegistered<ActiveBranchResolver>()
          ? sl<ActiveBranchResolver>().resolve()
          : null;

  @override
  Widget build(BuildContext context) {
    final view = _StatementView(repository: repository, launcher: launcher);
    return BlocProvider(
      key: ValueKey('statement-${partyType.apiValue}-$partyId'),
      create: (_) => _create()..start(_branch),
      child: !sl.isRegistered<BranchSelectorCubit>()
          ? view
          : BlocListener<BranchSelectorCubit, BranchSelectorState>(
              bloc: sl<BranchSelectorCubit>(),
              listenWhen: (a, b) =>
                  a.selectedBranchId != b.selectedBranchId && b.isInitialized,
              listener: (context, branch) => context
                  .read<KhataStatementCubit>()
                  .onBranchChanged(branch.selectedBranchId),
              child: view,
            ),
    );
  }
}

class _StatementView extends StatelessWidget {
  const _StatementView({this.repository, this.launcher});

  final KhataRepository? repository;
  final UrlLauncherService? launcher;

  /// From this width the controls sit beside the paper.
  static const _wideFrom = 1100.0;

  Future<void> _perform(
    BuildContext context,
    Future<StatementNotice?> Function() action,
  ) async {
    final cubit = context.read<KhataStatementCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final notice = await action();
    if (notice == null || !context.mounted) return;
    final path = notice.savedPath;
    if (path != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(notice.message),
            backgroundColor: AppColors.success,
            action: SnackBarAction(
              label: StatementText.openFolder,
              textColor: Colors.white,
              onPressed: () => cubit.openFolder(path),
            ),
          ),
        );
    } else if (notice.isError) {
      AppAlerts.showErrorMessage(context, notice.message);
    } else {
      AppAlerts.showSuccessMessage(context, notice.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KhataStatementCubit, StatementViewState>(
      builder: (context, state) {
        final cubit = context.read<KhataStatementCubit>();
        bool canUsePdf() =>
            cubit.state.data != null &&
            !cubit.state.loading &&
            cubit.isOnline;
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.keyS, control: true): () {
              if (canUsePdf()) _perform(context, cubit.savePdf);
            },
            const SingleActivator(LogicalKeyboardKey.keyP, control: true): () {
              if (canUsePdf()) _perform(context, cubit.printPdf);
            },
          },
          child: Focus(
            autofocus: true,
            child: LayoutBuilder(
              builder: (context, box) {
                final wide = box.maxWidth >= _wideFrom;
                final controls = _Controls(
                  state: state,
                  repository: repository,
                  launcher: launcher,
                  perform: (action) => _perform(context, action),
                  stacked: wide,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TopBar(state: state),
                    const SizedBox(height: AppDimensions.spacing12),
                    Expanded(
                      child: wide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: 360,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.only(
                                      top: AppDimensions.spacingXs,
                                      right: AppDimensions.spacingXs,
                                      bottom: AppDimensions.spacingMd,
                                    ),
                                    child: controls,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.spacingMd),
                                Expanded(
                                  child: CustomScrollView(
                                    key: const Key('statement-scroll'),
                                    slivers: _preview(context, state),
                                  ),
                                ),
                              ],
                            )
                          : CustomScrollView(
                              key: const Key('statement-scroll'),
                              slivers: [
                                SliverToBoxAdapter(child: controls),
                                const SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: AppDimensions.spacingMd,
                                  ),
                                ),
                                ..._preview(context, state),
                              ],
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> _preview(BuildContext context, StatementViewState state) {
    final cubit = context.read<KhataStatementCubit>();
    final data = state.data;
    final failure = state.failure;
    if (data == null) {
      return [
        SliverToBoxAdapter(
          child: failure == null
              ? const _PaperSkeleton()
              : _Problem(failure: failure, cubit: cubit),
        ),
      ];
    }
    return [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Always takes its room, so a reload does not move the paper.
            SizedBox(
              height: AppDimensions.spacingXs,
              child: state.loading
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(minHeight: 2),
                    )
                  : null,
            ),
            if (data.offline)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppDimensions.spacingSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnlineOnlyBanner(
                      message: StatementText.offlineCopy(
                        data.value.periodLabel,
                      ),
                    ),
                    if (data.asOf != null) ...[
                      const SizedBox(height: AppDimensions.spacingXs),
                      AsOfLabel(asOf: data.asOf!),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
      SliverAnimatedOpacity(
        opacity: state.loading ? 0.5 : 1,
        duration: KhataStyle.fast,
        sliver: StatementSliver(statement: data.value),
      ),
      const SliverToBoxAdapter(
        child: SizedBox(height: AppDimensions.spacingMd),
      ),
    ];
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state});

  final StatementViewState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<KhataStatementCubit>();
    final name = state.data?.value.partyName;
    return Row(
      children: [
        IconButton(
          key: const Key('statement-back'),
          tooltip: StatementText.back,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go(cubit.partyType.detailRoute(cubit.partyId));
            }
          },
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(
          child: Text(
            name == null || name.isEmpty
                ? StatementText.title
                : '${StatementText.title} · $name',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.state,
    required this.perform,
    this.repository,
    this.launcher,
    this.stacked = false,
  });

  final StatementViewState state;
  final void Function(Future<StatementNotice?> Function()) perform;

  /// In the side panel the buttons fill the width, one under another.
  final bool stacked;
  final KhataRepository? repository;
  final UrlLauncherService? launcher;

  Future<void> _pickDates(BuildContext context) async {
    final cubit = context.read<KhataStatementCubit>();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final from = state.customFrom;
    final to = state.customTo ?? today;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(today.year - 20),
      lastDate: today,
      initialDateRange: from == null || from.isAfter(to)
          ? null
          : DateTimeRange(start: from, end: to),
      helpText: StatementText.pickDates,
    );
    if (picked == null) return;
    await cubit.setPeriod(
      StatementPeriod.custom,
      from: picked.start,
      to: picked.end,
    );
  }

  void _message(BuildContext context, {required bool withLink}) {
    final cubit = context.read<KhataStatementCubit>();
    final statement = state.data!.value;
    final range = cubit.range;
    showKhataMessageDialog(
      context,
      MessageRequest(
        partyType: cubit.partyType,
        partyId: cubit.partyId,
        name: statement.partyName,
        phone: statement.partyPhone,
        kind: MessageKind.statement,
        branchId: cubit.branchId,
        from: range.from,
        to: range.to,
        detail: state.detail,
        withLink: withLink,
        knownDue: statement.closingDue > Decimal.zero
            ? statement.closingDue
            : Decimal.zero,
      ),
      repository: repository,
      launcher: launcher,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<KhataStatementCubit>();
    final custom = state.period == StatementPeriod.custom;
    final from = state.customFrom;
    final to = state.customTo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        KhataCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Heading(StatementText.periodHeading),
              Wrap(
                spacing: AppDimensions.spacingSm,
                runSpacing: AppDimensions.spacingSm,
                children: [
                  for (final p in StatementPeriod.values)
                    KhataFilterPill(
                      key: ValueKey('period-${p.name}'),
                      label: StatementText.period(p),
                      showDot: false,
                      selected: state.period == p,
                      onTap: () => p == StatementPeriod.custom
                          ? _pickDates(context)
                          : cubit.setPeriod(p),
                    ),
                ],
              ),
              if (custom && from != null && to != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.spacingSm),
                  child: Text(
                    '${KhataFormat.fullDay(from)} – '
                    '${KhataFormat.fullDay(to)}',
                    key: const Key('statement-custom-dates'),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              const SizedBox(height: AppDimensions.spacingMd),
              const _Heading(StatementText.detailHeading),
              KhataSegmented<StatementDetail>(
                key: const Key('statement-detail'),
                options: const [
                  (StatementDetail.summary, StatementText.summary),
                  (StatementDetail.detailed, StatementText.detailed),
                ],
                selected: state.detail,
                onChanged: cubit.setDetail,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        KhataCard(
          child: OfflineAwareBuilder(
            builder: (context, offlineProbe) {
              final ready = state.data != null && !state.loading;
              final offline = offlineProbe || !cubit.isOnline;
              final canLink = hasPermission(context, Perm.khataStatementCreate);
              final fileReady = ready && !offline && state.busy == null;
              final linkReady = fileReady && canLink;
              String fileHint(String hint) =>
                  offline ? StatementText.needsInternet : hint;
              String linkHint(String hint) => !canLink
                  ? StatementText.noLinkPermission
                  : fileHint(hint);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Heading(StatementText.sendHeading),
                  _ActionGroup(
                    stacked: stacked,
                    children: [
                      _Action(
                        id: 'share',
                        icon: Icons.ios_share,
                        label: StatementText.sharePdf,
                        hint: fileHint(
                          cubit.canShareFiles
                              ? StatementText.shareFileHint
                              : StatementText.shareHint,
                        ),
                        primary: true,
                        busy: state.busy == StatementAction.share,
                        onPressed: fileReady
                            ? () => perform(cubit.sharePdf)
                            : null,
                      ),
                      _Action(
                        id: 'save',
                        icon: Icons.save_alt,
                        label: StatementText.savePdf,
                        hint: fileHint(StatementText.saveHint),
                        busy: state.busy == StatementAction.save,
                        onPressed:
                            fileReady ? () => perform(cubit.savePdf) : null,
                      ),
                      _Action(
                        id: 'print',
                        icon: Icons.print_outlined,
                        label: StatementText.print,
                        hint: fileHint(StatementText.printHint),
                        busy: state.busy == StatementAction.print,
                        onPressed:
                            fileReady ? () => perform(cubit.printPdf) : null,
                      ),
                      _Action(
                        id: 'whatsapp',
                        icon: Icons.chat_outlined,
                        label: StatementText.whatsappMessage,
                        // Works offline, from the saved figures.
                        hint: StatementText.messageHint,
                        onPressed: ready
                            ? () => _message(context, withLink: false)
                            : null,
                      ),
                      _Action(
                        id: 'whatsapp-link',
                        icon: Icons.add_link,
                        label: StatementText.whatsappLink,
                        hint: linkHint(StatementText.linkMessageHint),
                        onPressed: linkReady
                            ? () => _message(context, withLink: true)
                            : null,
                      ),
                      _Action(
                        id: 'copy-link',
                        icon: Icons.link,
                        label: StatementText.copyLink,
                        hint: linkHint(StatementText.copyLinkHint),
                        busy: state.busy == StatementAction.copyLink,
                        onPressed:
                            linkReady ? () => perform(cubit.copyLink) : null,
                      ),
                    ],
                  ),
                  if (!cubit.canShareFiles) ...[
                    const SizedBox(height: AppDimensions.spacing12),
                    const Row(
                      key: Key('statement-attach-hint'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: AppDimensions.spacingSm),
                        Expanded(
                          child: Text(
                            StatementText.attachHint,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      );
}

class _ActionGroup extends StatelessWidget {
  const _ActionGroup({required this.stacked, required this.children});

  final bool stacked;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (!stacked) {
      return Wrap(
        spacing: AppDimensions.spacingSm,
        runSpacing: AppDimensions.spacingSm,
        children: children,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: AppDimensions.spacingSm),
          children[i],
        ],
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.id,
    required this.icon,
    required this.label,
    required this.hint,
    required this.onPressed,
    this.primary = false,
    this.busy = false,
  });

  final String id;
  final IconData icon;
  final String label;
  final String hint;
  final VoidCallback? onPressed;
  final bool primary;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final lead = busy
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icon, size: 18);
    final key = Key('statement-$id');
    return Tooltip(
      message: hint,
      child: primary
          ? FilledButton.icon(
              key: key,
              onPressed: onPressed,
              icon: lead,
              label: Text(label),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(0, 40),
              ),
            )
          : OutlinedButton.icon(
              key: key,
              onPressed: onPressed,
              icon: lead,
              label: Text(label),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 40),
              ),
            ),
    );
  }
}

/// Grey shapes in the layout of the paper.
class _PaperSkeleton extends StatelessWidget {
  const _PaperSkeleton();

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: const KhataShimmer(
            key: Key('statement-loading'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SkeletonBox(height: 96),
                SizedBox(height: AppDimensions.spacing12),
                SkeletonBox(height: 72),
                SizedBox(height: AppDimensions.spacing12),
                SkeletonBox(height: 40),
                SizedBox(height: AppDimensions.spacingSm),
                SkeletonBox(height: 40),
                SizedBox(height: AppDimensions.spacingSm),
                SkeletonBox(height: 40),
                SizedBox(height: AppDimensions.spacingSm),
                SkeletonBox(height: 40),
              ],
            ),
          ),
        ),
      );
}

class _Problem extends StatelessWidget {
  const _Problem({required this.failure, required this.cubit});

  final Failure failure;
  final KhataStatementCubit cubit;

  @override
  Widget build(BuildContext context) {
    final (icon, title, message, action, onAction) = switch (failure) {
      _ when failure.code == 'statement_too_large' => (
          Icons.unfold_less,
          StatementText.tooLongTitle,
          StatementText.tooLongMessage,
          StatementText.showThisMonth,
          cubit.showThisMonthSummary,
        ),
      _ when failure.code == 'invalid_date_range' => (
          Icons.event_busy_outlined,
          StatementText.badDatesTitle,
          StatementText.badDatesMessage,
          StatementText.showThisMonth,
          cubit.showThisMonthSummary,
        ),
      NetworkFailure() => (
          Icons.cloud_off,
          StatementText.offlineTitle,
          StatementText.offlineMessage,
          StatementText.retry,
          cubit.load,
        ),
      _ => (
          Icons.error_outline,
          StatementText.failedTitle,
          failure.message,
          StatementText.retry,
          cubit.load,
        ),
    };
    return KhataEmptyState(
      key: const Key('statement-problem'),
      icon: icon,
      title: title,
      message: message,
      actionLabel: action,
      onAction: onAction,
    );
  }
}
