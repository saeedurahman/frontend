import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_history_cubit.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_history_state.dart';
import 'package:frantend/features/cash_register/presentation/widgets/shift_summary_widgets.dart';
import 'package:go_router/go_router.dart';

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
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  Text('Shift History', style: AppTextStyles.headlineMedium),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
              child: _FilterBar(state: state),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                child: Text(state.error!, style: const TextStyle(color: AppColors.error)),
              ),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.shifts.isEmpty
                      ? const Center(child: Text('No closed shifts found'))
                      : _ShiftTable(state: state),
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
            DropdownMenuItem(value: ShiftDatePreset.last7Days, child: Text('Last 7 days')),
            DropdownMenuItem(value: ShiftDatePreset.last30Days, child: Text('Last 30 days')),
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
                (r) => DropdownMenuItem(value: r.id, child: Text(r.name)),
              ),
            ],
            onChanged: cubit.setRegisterFilter,
          ),
      ],
    );
  }
}

class _ShiftTable extends StatelessWidget {
  const _ShiftTable({required this.state});

  final ShiftHistoryState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShiftHistoryCubit>();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Cashier')),
                  DataColumn(label: Text('Register')),
                  DataColumn(label: Text('Opened')),
                  DataColumn(label: Text('Closed')),
                  DataColumn(label: Text('Duration')),
                  DataColumn(label: Text('Opening Float')),
                  DataColumn(label: Text('Expected')),
                  DataColumn(label: Text('Counted')),
                  DataColumn(label: Text('Variance')),
                  DataColumn(label: Text('Status')),
                ],
                rows: state.shifts.map((shift) => _buildRow(context, shift, cubit)).toList(),
              ),
            ),
          ),
        ),
        if (state.hasMore)
          Padding(
            padding: const EdgeInsets.all(12),
            child: state.isLoadingMore
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: cubit.loadMore,
                    child: const Text('Load more'),
                  ),
          ),
      ],
    );
  }

  DataRow _buildRow(
    BuildContext context,
    RegisterShiftModel shift,
    ShiftHistoryCubit cubit,
  ) {
    final variance = shift.cashDifference == null
        ? Decimal.zero
        : DecimalUtils.parse(shift.cashDifference!);
    final varianceColor = ShiftFormatUtils.varianceColor(variance);

    return DataRow(
      onSelectChanged: (_) {
        if (shift.status == 'open') {
          context.go(RouteNames.cashRegister);
        } else {
          context.push(RouteNames.shiftDetailPath(shift.id));
        }
      },
      cells: [
        DataCell(Text(shift.openedByName ?? '—')),
        DataCell(Text(cubit.registerName(shift.cashRegisterId) ?? '—')),
        DataCell(Text(ShiftFormatUtils.formatDateTime(shift.openedAt))),
        DataCell(Text(ShiftFormatUtils.formatDateTime(shift.closedAt))),
        DataCell(Text(ShiftFormatUtils.formatDuration(shift.openedAt, closedAt: shift.closedAt))),
        DataCell(Text(ShiftFormatUtils.formatMoney(shift.openingFloat))),
        DataCell(Text(ShiftFormatUtils.formatMoney(shift.expectedCash))),
        DataCell(Text(ShiftFormatUtils.formatMoney(shift.actualCash))),
        DataCell(
          Text(
            shift.cashDifference == null
                ? '—'
                : ShiftFormatUtils.varianceLabel(variance),
            style: TextStyle(color: varianceColor, fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(_StatusChip(status: shift.status)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isOpen = status == 'open';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isOpen ? AppColors.success : AppColors.textSecondary)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOpen ? 'Open' : 'Closed',
        style: TextStyle(
          fontSize: 12,
          color: isOpen ? AppColors.success : AppColors.textSecondary,
        ),
      ),
    );
  }
}
