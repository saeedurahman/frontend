import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/cash_register/presentation/cubit/current_shift_cubit.dart';
import 'package:frantend/features/cash_register/presentation/cubit/current_shift_state.dart';
import 'package:frantend/features/cash_register/presentation/widgets/shift_summary_widgets.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:go_router/go_router.dart';

class CurrentShiftPage extends StatelessWidget {
  const CurrentShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CurrentShiftCubit>()..load(),
      child: const _CurrentShiftView(),
    );
  }
}

class _CurrentShiftView extends StatelessWidget {
  const _CurrentShiftView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentShiftCubit, CurrentShiftState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => context.read<CurrentShiftCubit>().refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('Cash Register', style: AppTextStyles.headlineMedium),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => context.push(RouteNames.shiftHistory),
                      icon: const Icon(Icons.history),
                      label: const Text('Shift History'),
                    ),
                    if (state.isRefreshing)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  ],
                ),
                if (state.error != null) ...[
                  const SizedBox(height: 12),
                  Text(state.error!, style: const TextStyle(color: AppColors.error)),
                ],
                const SizedBox(height: AppDimensions.spacingMd),
                if (state.openShifts.isEmpty)
                  _EmptyState()
                else
                  _ActiveShiftContent(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.point_of_sale_outlined, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text('No Active Shift', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Open a shift from the POS screen to start selling and tracking cash.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Go to POS',
            fullWidth: false,
            onPressed: () => context.go(RouteNames.pos),
          ),
        ],
      ),
    );
  }
}

class _ActiveShiftContent extends StatelessWidget {
  const _ActiveShiftContent({required this.state});

  final CurrentShiftState state;

  @override
  Widget build(BuildContext context) {
    final selected = state.selectedShift!;
    final summary = selected.summary;
    final shift = selected.shift;
    final register = selected.register;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.openShifts.length > 1) ...[
          DropdownButtonFormField<String>(
            value: shift.id,
            decoration: const InputDecoration(
              labelText: 'Open Register',
              border: OutlineInputBorder(),
            ),
            items: state.openShifts
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.shift.id,
                    child: Text(entry.register.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<CurrentShiftCubit>().selectShift(value);
              }
            },
          ),
          const SizedBox(height: AppDimensions.spacingMd),
        ],
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(register.name, style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text(
                'Cashier: ${state.cashierName ?? '—'}',
                style: AppTextStyles.bodySmall,
              ),
              Text(
                'Opened: ${ShiftFormatUtils.formatDateTime(shift.openedAt)} '
                '(${ShiftFormatUtils.formatDuration(shift.openedAt)})',
                style: AppTextStyles.bodySmall,
              ),
              Text(
                'Opening Float: ${ShiftFormatUtils.formatMoney(shift.openingFloat)}',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        if (summary != null)
          ShiftSummaryBreakdown(summary: summary)
        else
          const Center(child: CircularProgressIndicator()),
        const SizedBox(height: AppDimensions.spacingLg),
        PrimaryButton(
          label: 'Close Shift',
          icon: Icons.lock_outline,
          onPressed: summary == null
              ? null
              : () => context.push(
                    RouteNames.closeShift,
                    extra: {
                      'shiftId': shift.id,
                      'summary': summary,
                      'registerName': register.name,
                    },
                  ).then((_) {
                    if (context.mounted) {
                      context.read<CurrentShiftCubit>().refresh();
                    }
                  }),
        ),
      ],
    );
  }
}
