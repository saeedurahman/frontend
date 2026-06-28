import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_history_cubit.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_history_state.dart';
import 'package:frantend/features/cash_register/presentation/widgets/shift_history_table.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ShiftHistoryPage extends StatelessWidget {
  const ShiftHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ShiftHistoryCubit>()..init(),
      child: const _ShiftHistoryView(),
    );
  }
}

class _ShiftHistoryView extends StatelessWidget {
  const _ShiftHistoryView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftHistoryCubit, ShiftHistoryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text(
                      'Back',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Shift History', style: AppTextStyles.headlineMedium),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingLg,
              ),
              child: _FilterBar(state: state),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingLg,
                ),
                child: Text(
                  state.error!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingLg,
                ),
                child: switch ((state.isLoading, state.shifts.isEmpty)) {
                  (true, _) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100,
                      child: const AppDataTableShimmer(),
                    ),
                  (false, true) => const Center(
                      child: Text('No closed shifts found'),
                    ),
                  _ => ShiftHistoryTable(state: state),
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});

  final ShiftHistoryState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShiftHistoryCubit>();

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DropdownButton<ShiftDatePreset>(
          value: state.datePreset,
          items: const [
            DropdownMenuItem(value: ShiftDatePreset.today, child: Text('Today')),
            DropdownMenuItem(
              value: ShiftDatePreset.last7Days,
              child: Text('Last 7 days'),
            ),
            DropdownMenuItem(
              value: ShiftDatePreset.last30Days,
              child: Text('Last 30 days'),
            ),
            DropdownMenuItem(value: ShiftDatePreset.all, child: Text('All')),
          ],
          onChanged: (value) {
            if (value != null) cubit.setDatePreset(value);
          },
        ),
        if (state.registers.length > 1)
          DropdownButton<String?>(
            value: state.selectedRegisterId,
            hint: const Text('All registers'),
            items: [
              const DropdownMenuItem(value: null, child: Text('All registers')),
              ...state.registers.map(
                (CashRegisterModel r) =>
                    DropdownMenuItem(value: r.id, child: Text(r.name)),
              ),
            ],
            onChanged: cubit.setRegisterFilter,
          ),
      ],
    );
  }
}
