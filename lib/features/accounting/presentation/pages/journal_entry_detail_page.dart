import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';
import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entry_detail_cubit.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entry_detail_state.dart';
import 'package:frantend/features/accounting/presentation/widgets/journal_lines_table.dart';
import 'package:frantend/features/accounting/presentation/widgets/journal_status_chip.dart';
import 'package:frantend/features/accounting/presentation/widgets/post_journal_entry_dialog.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class JournalEntryDetailPage extends StatelessWidget {
  const JournalEntryDetailPage({super.key, required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<JournalEntryDetailCubit>()..load(entryId),
      child: _JournalEntryDetailView(entryId: entryId),
    );
  }
}

class _JournalEntryDetailView extends StatelessWidget {
  const _JournalEntryDetailView({required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalEntryDetailCubit, JournalEntryDetailState>(
      listener: (context, state) {
        if (state.loadError != null && state.entry == null && !state.isLoading) {
          AppAlerts.showErrorMessage(context, state.loadError!);
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.entry == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.loadError != null && state.entry == null) {
          return Center(child: Text(state.loadError!));
        }

        final entry = state.entry;
        if (entry == null) {
          return const Center(child: Text('Journal entry not found'));
        }

        final isDraft = entry.status == JournalEntryStatus.draft;
        final isPosted = entry.status == JournalEntryStatus.posted;
        final balance = computeJournalBalanceFromResponseLines(entry.lines);
        final parsedDate = DateTime.tryParse(entry.entryDate);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(entry.entryNumber, style: AppTextStyles.headlineMedium),
                  const SizedBox(width: 12),
                  JournalStatusChip(status: entry.status),
                ],
              ),
              if (isPosted) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: AppColors.success.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.postedAt != null
                              ? 'This entry was posted on ${_formatDateTime(entry.postedAt!)} and cannot be edited or deleted.'
                              : 'This entry is posted and cannot be edited or deleted.',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.spacingLg),
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingLg),
                decoration: BoxDecoration(
                  color: isPosted
                      ? AppColors.background
                      : Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DetailRow(
                      label: 'Date',
                      value: parsedDate != null
                          ? DateFormatter.formatDate(parsedDate)
                          : entry.entryDate,
                    ),
                    const SizedBox(height: 8),
                    _DetailRow(
                      label: 'Description',
                      value: entry.description?.trim().isNotEmpty == true
                          ? entry.description!
                          : '—',
                    ),
                    const SizedBox(height: 16),
                    JournalLinesTable(
                      lines: entry.lines,
                      totalDebit: entry.totalDebit,
                      totalCredit: entry.totalCredit,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Difference: ${formatPKR(double.tryParse(balance.difference.toString()) ?? 0)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: balance.isBalanced
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isDraft) ...[
                const SizedBox(height: AppDimensions.spacingLg),
                Row(
                  children: [
                    if (state.canCreate) ...[
                      OutlinedButton.icon(
                        onPressed: state.isPosting || state.isDeleting
                            ? null
                            : () async {
                                final saved = await context.push<bool>(
                                  RouteNames.accountingJournalEditPath(entryId),
                                );
                                if (saved == true && context.mounted) {
                                  await context
                                      .read<JournalEntryDetailCubit>()
                                      .load(entryId);
                                }
                              },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: state.isPosting || state.isDeleting
                            ? null
                            : () => _delete(context),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Delete'),
                      ),
                    ],
                    const Spacer(),
                    if (state.canPost)
                      FilledButton.icon(
                        onPressed: state.isPosting || state.isDeleting
                            ? null
                            : () => _post(context, balance),
                        icon: state.isPosting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text('Post entry'),
                      ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormatter.formatDateTime(parsed.toLocal());
  }

  Future<void> _delete(BuildContext context) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete draft entry?',
      message: 'This draft journal entry will be permanently deleted.',
    );
    if (ok != true || !context.mounted) return;

    final err = await context.read<JournalEntryDetailCubit>().deleteEntry();
    if (!context.mounted) return;
    if (err != null) {
      AppAlerts.showErrorMessage(context, err);
    } else {
      AppAlerts.showSuccessMessage(context, 'Journal entry deleted');
      context.pop(true);
    }
  }

  Future<void> _post(
    BuildContext context,
    JournalBalanceSummary balance,
  ) async {
    final state = context.read<JournalEntryDetailCubit>().state;
    final entry = state.entry;
    if (entry == null) return;

    final confirmed = await PostJournalEntryDialog.show(
      context,
      entry: entry,
      balanceSummary: balance,
    );
    if (confirmed != true || !context.mounted) return;

    final err = await context.read<JournalEntryDetailCubit>().postEntry();
    if (!context.mounted) return;
    if (err != null) {
      AppAlerts.showErrorMessage(context, err);
    } else {
      AppAlerts.showSuccessMessage(context, 'Journal entry posted');
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}
