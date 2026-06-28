import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/audit/presentation/cubit/audit_logs_cubit.dart';
import 'package:frantend/features/audit/presentation/cubit/audit_logs_state.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_filter_bar.dart';
import 'package:frantend/features/audit/presentation/widgets/audit_logs_table.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:shimmer/shimmer.dart';

class AuditLogsPage extends StatelessWidget {
  const AuditLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuditLogsCubit>()..init(),
      child: const _AuditLogsView(),
    );
  }
}

class _AuditLogsView extends StatelessWidget {
  const _AuditLogsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditLogsCubit, AuditLogsState>(
      builder: (context, state) {
        if (state is AuditLogsAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view audit logs",
          );
        }

        final cubit = context.read<AuditLogsCubit>();
        final filters = switch (state) {
          AuditLogsLoading(:final filters) => filters,
          AuditLogsLoaded(:final filters) => filters,
          AuditLogsError(:final filters) => filters,
          _ => const AuditLogsFilters(),
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Audit Logs', style: AppTextStyles.headlineMedium),
                const SizedBox(width: 12),
                if (state is AuditLogsLoaded)
                  Text(
                    '${state.total} entries',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  tooltip: 'Refresh',
                  icon: const Icon(Icons.refresh),
                  onPressed: state is AuditLogsLoading ? null : cubit.refresh,
                ),
              ],
            ),
            const SizedBox(height: 12),
            AuditFilterBar(
              filters: filters,
              onApply: cubit.applyFilters,
              onClear: cubit.clearFilters,
            ),
            const SizedBox(height: 12),
            if (state is AuditLogsError)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            Expanded(
              child: switch (state) {
                AuditLogsLoading() => Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                AuditLogsLoaded(:final logs, :final filters) => logs.isEmpty
                    ? const EmptyState(
                        icon: Icons.history,
                        message: 'No audit entries match your filters',
                      )
                    : AuditLogsTable(
                        key: ValueKey(filters),
                        state: state,
                      ),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        );
      },
    );
  }
}
