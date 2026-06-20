import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_detail_cubit.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_detail_state.dart';
import 'package:frantend/features/cash_register/presentation/widgets/shift_summary_widgets.dart';

class ShiftDetailPage extends StatelessWidget {
  const ShiftDetailPage({super.key, required this.shiftId});

  final String shiftId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<ShiftDetailCubit>();
        sl<AuthLocalDataSource>().getCachedUser().then((user) {
          cubit.load(shiftId, branchId: user?.branchId);
        });
        return cubit;
      },
      child: _ShiftDetailView(shiftId: shiftId),
    );
  }
}

class _ShiftDetailView extends StatelessWidget {
  const _ShiftDetailView({required this.shiftId});

  final String shiftId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftDetailCubit, ShiftDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text(state.error!));
        }

        final shift = state.shift;
        final summary = state.summary;
        if (shift == null || summary == null) {
          return const Center(child: Text('Shift not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Text('Shift Report', style: AppTextStyles.headlineMedium),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${state.register?.name ?? 'Register'} · '
                '${ShiftFormatUtils.formatDateTime(shift.openedAt)}',
                style: AppTextStyles.bodySmall,
              ),
              Text(
                'Opened by: ${shift.openedByName ?? '—'}',
                style: AppTextStyles.bodySmall,
              ),
              if (shift.closedByName != null)
                Text(
                  'Closed by: ${shift.closedByName}',
                  style: AppTextStyles.bodySmall,
                )
              else if (shift.status == 'open')
                Text(
                  'Closed by: Still open',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (shift.closedAt != null)
                Text(
                  'Closed: ${ShiftFormatUtils.formatDateTime(shift.closedAt)} '
                  '(${ShiftFormatUtils.formatDuration(shift.openedAt, closedAt: shift.closedAt)})',
                  style: AppTextStyles.bodySmall,
                ),
              const SizedBox(height: AppDimensions.spacingMd),
              ShiftSummaryBreakdown(summary: summary),
            ],
          ),
        );
      },
    );
  }
}
